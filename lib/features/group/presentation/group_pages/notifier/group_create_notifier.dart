import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:pulse_chat/features/group/domain/entities/group.dart';
import 'package:pulse_chat/features/group/domain/entities/group_create.dart';
import 'package:pulse_chat/features/group/domain/entities/group_member.dart';
import 'package:pulse_chat/features/group/domain/entities/group_member_create.dart';
import 'package:pulse_chat/features/group/domain/usecase/group/create_group.dart';
import 'package:pulse_chat/features/group/domain/usecase/group_member/create_member.dart';
import 'package:pulse_chat/features/media/domain/usecase/upload_image_file.dart';

class GroupCreateNotifier extends ChangeNotifier {
  // DEPENDENCIES --------------------------------------------------------------------------------
  final LocalAuthSource _localAuthSource;
  final CreateGroup _createGroup;
  final UploadImageFile _postImageToServer;
  final InviteMember _createGroupMember;
  final AddGroupHostMember _addGroupHostMember;

  GroupCreateNotifier({
    required LocalAuthSource localAuthSource,
    required CreateGroup createGroup,
    required UploadImageFile postImageToServer,
    required InviteMember createGroupMember,
    required AddGroupHostMember addGroupHostMember,
  }) : _localAuthSource = localAuthSource,
       _createGroup = createGroup,
       _postImageToServer = postImageToServer,
       _createGroupMember = createGroupMember,
       _addGroupHostMember = addGroupHostMember;

  // PROPERTIES ----------------------------------------------------------------------------------
  List<GroupMemberSelection>? _groupInitialUsers;
  List<GroupMemberSelection>? get groupInitialUser => _groupInitialUsers;

  XFile? _choosenAvatar;
  XFile? get choosenAvatar => _choosenAvatar;

  // METHODS---------------------------------------------------------------------------------------

  void addMemberSelection(int id, String? avatar) {
    _groupInitialUsers ??= [];
    _groupInitialUsers?.add(GroupMemberSelection(id: id, avatar: avatar));
    debugPrint("${_groupInitialUsers?.length}");
    notifyListeners();
  }

  void removeMemberSelection(int id) {
    _groupInitialUsers?.removeWhere((element) => element.id == id);
    if (_groupInitialUsers!.isEmpty) {
      _groupInitialUsers = null;
    }
    notifyListeners();
  }

  void selectAvatarImage(XFile? image) {
    _choosenAvatar = image;
    debugPrint(_choosenAvatar!.path);
    notifyListeners();
  }

  Future<String?> uploadAvatarUrl() async {
    if (_choosenAvatar == null) return null;
    final imageUploaded = await _postImageToServer(_choosenAvatar!);
    return imageUploaded.result.imageUrl;
  }

  Future<Group?> createNewGroup(String name) async {
    try {
      String? avatarUrl = await uploadAvatarUrl();
      final groupCreate = GroupCreate(subject: name, avatar: avatarUrl);
      final group = await _createGroup(groupCreate);
      addHostToGroup(group.result.id, _localAuthSource.getCachedUser()!.id);
      initGroupMember(group.result.id);
      return group.result;
    } on DioException catch (e) {
      debugPrint("[Group create] : ${e.response?.data["detail"] ?? "$e"}");
      return null;
    } catch (e) {
      debugPrint("[Group create] : $e");
      return null;
    }
  }

  void initGroupMember(int groupId) async {
    List<Future> initGroupMemberTask =
        _groupInitialUsers!.map((user) async {
          addMemberToGroup(groupId, user.id);
        }).toList();

    await Future.wait(initGroupMemberTask);
  }

  void addHostToGroup(int groupId, int userId) async {
    await _addGroupHostMember(groupId, userId);
  }

  Future<GroupMember?> addMemberToGroup(int groupId, int userId) async {
    try {
      final response = await _createGroupMember(
        groupId: groupId,
        userId: userId,
      );
      return response.result;
    } on DioException catch (e) {
      debugPrint(e.response?.data["detail"]);
      return null;
    } catch (e) {
      debugPrint("[Add member to Group]");
      return null;
    }
  }

  void clearCreateGroupData() {
    _groupInitialUsers = null;
    _choosenAvatar = null;
  }
}
