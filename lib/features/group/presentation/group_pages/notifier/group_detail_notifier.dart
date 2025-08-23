import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pulse_chat/features/group/domain/entities/group.dart';
import 'package:pulse_chat/features/group/domain/entities/group_member_check.dart';
import 'package:pulse_chat/features/group/domain/entities/group_update.dart';
import 'package:pulse_chat/features/group/domain/usecase/group/delete_group.dart';
import 'package:pulse_chat/features/group/domain/usecase/group/get_group.dart';
import 'package:pulse_chat/features/group/domain/usecase/group/update_group.dart';
import 'package:pulse_chat/features/group/domain/usecase/group_member/check_member.dart';
import 'package:pulse_chat/features/group/domain/usecase/group_member/create_member.dart';
import 'package:pulse_chat/features/group/domain/usecase/group_member/delete_member.dart';
import 'package:pulse_chat/features/media/domain/usecase/upload_image_file.dart';

class GroupDetailNotifier extends ChangeNotifier {
  // DEPENDENCIES
  final LocalAuthSource _localAuthSource;

  final GetGroup _getGroup;

  final CheckMemberStatus _checkMemberStatus;

  final UploadImageFile _uploadImageFile;

  final UpdateGroup _updateGroup;

  final DeleteGroup _deleteGroup;

  final RequestToJoinGroup _requestToJoinGroup;

  final DeleteMember _deleteMember;

  // PROPERTIES
  late Group group;

  bool _loadingAvatar = false;
  bool get loadingAvatar => _loadingAvatar;

  bool _loading = true;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  late GroupMemberCheck groupMemberStatus;

  GroupDetailNotifier({
    required LocalAuthSource localAuthSource,
    required GetGroup getGroup,
    required CheckMemberStatus checkMemberStatus,
    required UploadImageFile uploadImageFile,
    required UpdateGroup updateGroup,
    required DeleteGroup deleteGroup,
    required RequestToJoinGroup requestToJoinGroup,
    required DeleteMember deleteMember,
  }) : _localAuthSource = localAuthSource,
       _getGroup = getGroup,
       _checkMemberStatus = checkMemberStatus,
       _uploadImageFile = uploadImageFile,
       _updateGroup = updateGroup,
       _deleteGroup = deleteGroup,
       _requestToJoinGroup = requestToJoinGroup,
       _deleteMember = deleteMember;

  void setError(String? error) {
    _error = error;
    Future.delayed(Duration(seconds: 5), () => setError(null));
  }

  void getGroupById(int id) async {
    _loading = true;
    try {
      final response = await _getGroup(id);
      group = response.result;

      /// get group member status of current user to
      /// know if current login user is admin or subadmin or not
      final memberStatusResponse = await getGroupMemberStatus(
        id,
        _localAuthSource.getCachedUser()?.id ?? 0,
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
    final response = await _checkMemberStatus(groupId, [userId]);
    return response.results[0];
  }

  void updateGroupAvatar(int id, XFile? avatarFile) async {
    if (avatarFile == null) {
      return;
    }

    _loadingAvatar = true;

    try {
      final uploadAvatar = await _uploadImageFile(avatarFile);
      group.avatar = uploadAvatar.result.imageUrl;
      updateGroupInfo(id, avatar: uploadAvatar.result.imageUrl);
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
      final response = await _updateGroup(group.id, groupUpdate);
      group = response.result;
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
      final response = await _deleteGroup(groupId);
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
      final response = await _deleteMember(
        group.id,
        groupMemberStatus.groupMemberId!,
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
      final sentRequest = _requestToJoinGroup(groupId, userId);
      final response = await sentRequest;
      groupMemberStatus.groupMemberId = response.result.id;
      groupMemberStatus.status = 2;
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
