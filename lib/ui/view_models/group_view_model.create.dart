// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

part of 'group_view_model.dart';

extension GroupMemberViewModel on GroupViewModel {
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
    final imageUploaded = await _fileRepo.postImageToServer(_choosenAvatar!);
    return imageUploaded.result!.imageUrl;
  }

  Future<Group?> createNewGroup(String name) async {
    try {
      String? avatarUrl = await uploadAvatarUrl();
      final groupCreate = GroupCreate(subject: name, avatar: avatarUrl);
      final group = await _groupRepo.createGroup(groupCreate);
      addHostToGroup(group.result!.id, _authRepo.currentUser!.id);
      initGroupMember(group.result!.id);
      return group.result!;
    } on DioException catch (e) {
      debugPrint("[Group create] : ${e.response?.data["detail"] ?? "$e"}");
    } catch (e) {
      debugPrint("[Group create] : $e");
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
    addMemberToGroup(groupId, userId, isHost: true);
  }

  Future<GroupMember?> addMemberToGroup(
    int groupId,
    int userId, {
    bool isHost = false,
  }) async {
    try {
      final groupMemberCreate = GroupMemberCreate(
        userId: userId,
        groupId: groupId,
        isHost: isHost,
      );
      final response = await _groupMemberRepo.createGroupMember(
        groupId,
        groupMemberCreate,
      );
      return response.result!;
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
