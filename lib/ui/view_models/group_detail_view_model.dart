import 'package:chatting_app/data/models/group.dart';
import 'package:chatting_app/data/repositories/auth_repo.dart';
import 'package:chatting_app/data/repositories/group_member_repo.dart';
import 'package:chatting_app/data/repositories/group_repo.dart';
import 'package:chatting_app/data/repositories/media_file_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class GroupDetailViewModel extends ChangeNotifier {
  final _groupRepo = GroupRepo();
  final _fileRepo = MediaFileRepo();

  final _groupMemberRepo = GroupMemberRepo();

  late Group group;

  GroupDetailViewModel(this.group);

  GroupDetailViewModel.fromId(int id) {
    getGroupById(id);
  }

  bool _loadingAvatar = false;
  bool get loadingAvatar => _loadingAvatar;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  void setError(String? error) {
    _error = error;
    Future.delayed(Duration(seconds: 5), () => setError(null));
  }

  void getGroupById(int id) async {
    _loading = true;
    try {
      final response = await _groupRepo.getGroupById(id);
      group = response.result!;
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

  void leaveGroup(int groupMemberId) {
    _groupMemberRepo.deleteGroupMember(group.id, groupMemberId);
  }
}
