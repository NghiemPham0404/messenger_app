import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:pulse_chat/data/models/group.dart';
import 'package:pulse_chat/data/models/group_member.dart';
import 'package:pulse_chat/data/repositories/group_member_repo.dart';
import 'package:pulse_chat/data/repositories/group_repo.dart';
import 'package:pulse_chat/data/repositories/media_file_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class GroupDetailViewModel extends ChangeNotifier {
  final _groupRepo = GroupRepo();
  final _fileRepo = MediaFileRepo();

  final _groupMemberRepo = GroupMemberRepo();
  late final LocalAuthSource localAuthSource;

  late Group group;

  GroupDetailViewModel(this.group);

  GroupDetailViewModel.fromId(int id) {
    getGroupById(id);
  }

  bool _loadingAvatar = false;
  bool get loadingAvatar => _loadingAvatar;

  bool _loading = true;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  late GroupMemberCheck groupMemberStatus;

  void setError(String? error) {
    _error = error;
    Future.delayed(Duration(seconds: 5), () => setError(null));
  }

  void getGroupById(int id) async {
    _loading = true;
    try {
      final response = await _groupRepo.getGroupById(id);
      group = response.result!;

      /// get group member status of current user to
      /// know if current login user is admin or subadmin or not
      final memberStatusResponse = await getGroupMemberStatus(
        id,
        localAuthSource.getCachedUser()?.id ?? 0,
      );
      groupMemberStatus = memberStatusResponse;
    } on DioException catch (e) {
      final detail =
          e.response!.data["detail"] ?? "fail to get group infomations";
      _error = detail;
      debugPrint(" [Group-detail] error : $detail");
    } catch (e) {
      debugPrint(" [Group-detail] error : $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// get group member status of current user to
  /// know if current login user is admin or subadmin or not
  Future<GroupMemberCheck> getGroupMemberStatus(int groupId, int userId) async {
    final response = await _groupMemberRepo.checkGroupMember(groupId, [userId]);
    return response.results![0];
  }

  void updateGroupAvatar(int id, XFile? avatarFile) async {
    if (avatarFile == null) {
      return;
    }

    _loadingAvatar = true;

    try {
      final uploadAvatar = await _fileRepo.postImageToServer(avatarFile);
      group.avatar = uploadAvatar.result?.imageUrl;
      updateGroupInfo(id, avatar: uploadAvatar.result?.imageUrl);
    } on DioException catch (e) {
      final detail = e.response!.data["detail"] ?? "fail to upload avatar";
      _error = detail;
      debugPrint(" [Group-detail--update avatar] error : $detail");
    } catch (e) {
      debugPrint(" [Group-detail--update avatar] error : $e");
    } finally {
      _loadingAvatar = false;
      notifyListeners();
    }
  }

  void updateGroupInfo(
    int id, {
    String? subject,
    bool? isPublic,
    bool? isMemberMute,
    String? avatar,
  }) async {
    try {
      _loading = true;
      final groupUpdate = GroupUpdate(
        subject: subject ?? group.subject,
        isMemberMute: isMemberMute ?? group.isMemberMute,
        isPublic: isPublic ?? group.isPublic,
        avatar: avatar ?? group.avatar,
      );
      final response = await _groupRepo.updateGroup(group.id, groupUpdate);
      group = response.result ?? group;
    } on DioException catch (e) {
      final detail = e.response!.data["detail"].toString();
      setError("Update group unsuccessfully, pls try again");
      debugPrint(" [Group-detail--update info] error : $detail");
    } catch (e) {
      debugPrint(" [Group-detail--update info] error : $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteGroup(groupId) async {
    try {
      _loading = true;
      final response = await _groupRepo.deleteGroup(groupId);
      return response.success;
    } on DioException catch (e) {
      final detail = e.response!.data["detail"].toString();
      setError("Update group unsuccessfully, pls try again");
      debugPrint(" [Group-detail--delete] error : $detail");
      return false;
    } catch (e) {
      debugPrint(" [Group-detail--delete] error : $e");
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> leaveGroup() async {
    try {
      _loading = true;
      final groupMemberUpdate = GroupMemberUpdate(
        isHost: groupMemberStatus.isHost,
        isSubHost: groupMemberStatus.isSubHost,
        status: 3,
      );
      final response = await _groupMemberRepo.updateGroupMember(
        group.id,
        groupMemberStatus.groupMemberId!,
        groupMemberUpdate,
      );
      return response.success;
    } on DioException catch (e) {
      final detail = e.response!.data["detail"].toString();
      setError("leave group unsuccessfully, pls try again");
      debugPrint(" [Group-detail--leave group] error : $detail");
      return false;
    } catch (e) {
      debugPrint(" [Group-detail--leave group] error : $e");
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void requestJoinGroup(int groupId, int userId) async {
    try {
      final sentRequest = GroupMemberCreate(
        userId: userId,
        groupId: groupId,
        isHost: false,
        status: 2,
      );
      final response = await _groupMemberRepo.createGroupMember(
        groupId,
        sentRequest,
      );
      if (response.success) {
        groupMemberStatus.groupMemberId = response.result!.id;
        groupMemberStatus.status = 2;
      }
    } on DioException catch (e) {
      String detail = e.response!.data["detail"].toString();
      _error =
          "error happens when request joinning group, $detail , please try again";
      debugPrint(
        "[Group - add sent request]  error happens when request joinning group userId = $userId",
      );
    } catch (e) {
      debugPrint("[Group - add sent request] $e");
    } finally {
      notifyListeners();
    }
  }
}
