// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
part of 'group_member_view_model.dart';

extension GroupMemberViewModelSentRequest on GroupMemberViewModel {
  /// get all sent joining group requests of a group
  void getGroupSentRequests(int groupId, int page) async {
    _loadingSentRequest = true;
    _errorSentRequest = null;
    try {
      final response = await _groupMemberRepo.fetchGroupMember(
        groupId,
        0,
        page,
      );
      final requests = response.results!;
      _sentRequests = requests;
      _sentRequestPage = response.page!;
      _sentRequestHasNext = response.page! < response.totalPages!;
    } on DioException catch (e) {
      String detail = e.response!.data["detail"].toString();
      _errorSentRequest =
          "error happens when read joining group sent request , please try again";
      debugPrint(detail);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _loadingSentRequest = false;
      notifyListeners();
    }
  }

  /// get all sent joining group requests of a group
  void getGroupSentRequestsNext(int groupId) async {
    getGroupSentRequests(groupId, _sentRequestPage + 1);
  }

  //
  void checkPreSendRequest(int groupId) async {
    _loadingSentRequest = true;
    _errorSentRequest = null;
    try {
      final friendsResponse = await _contactRepo.fetchFriendList();
      _friendList = friendsResponse;
      final userIds =
          _friendList?.results!.map((item) => item.otherUser.id).toList() ?? [];

      final response = await _groupMemberRepo.checkGroupMember(
        groupId,
        userIds,
      );
      debugPrint(userIds.toString());
      for (var item in response.results!) {
        _checkedGroupMembers[item.userId] = item;
      }
    } on DioException catch (e) {
      String detail = e.response!.data["detail"].toString();
      _errorSentRequest =
          "error happens when checking available user to send joining group request , please try again";
      debugPrint(detail);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _loadingSentRequest = false;
      notifyListeners();
    }
  }

  void addMemberSelection(int id, String? avatar) {
    _addtionalUsers ??= [];
    _addtionalUsers?.add(GroupMemberSelection(id: id, avatar: avatar));
    debugPrint("${_addtionalUsers?.length}");
    notifyListeners();
  }

  void removeMemberSelection(int id) {
    _addtionalUsers?.removeWhere((element) => element.id == id);
    if (_addtionalUsers!.isEmpty) {
      _addtionalUsers = null;
    }
    notifyListeners();
  }

  void confirmAddingSentRequests(int groupId) async {
    List<Future> addingSentRequestsTask =
        _addtionalUsers!.map((user) async {
          addSentRequest(groupId, user.id);
        }).toList();

    await Future.wait(addingSentRequestsTask);
  }

  void addSentRequest(int groupId, int userId) async {
    try {
      final sentRequest = GroupMemberCreate(
        userId: userId,
        groupId: groupId,
        isHost: false,
        status: 0,
      );
      final response = await _groupMemberRepo.createGroupMember(
        groupId,
        sentRequest,
      );
      if (response.success) {
        _sentRequests.add(response.result!);
        _checkedGroupMembers[userId]?.status = 0;
        removeMemberSelection(userId);
      }
    } on DioException catch (e) {
      String detail = e.response!.data["detail"].toString();
      _errorMembers =
          "error happens when add group members sent request user_id = $userId, please try again";
      debugPrint("[Group - add sent request] $detail");
    } catch (e) {
      debugPrint("[Group - add sent request] $e");
    } finally {
      _loadingMembers = false;
      notifyListeners();
    }
  }

  void cancelSentRequest(int groupId, int groupMemberId) async {
    try {
      final response = await _groupMemberRepo.deleteGroupMember(
        groupId,
        groupMemberId,
      );
      if (response.success) {
        _sentRequests.removeWhere((item) => item.id == groupMemberId);
      }
    } on DioException catch (e) {
      String detail = e.response!.data["detail"].toString();
      _errorMembers = "error happens when read group members, please try again";
      debugPrint("[Group - cancel sent request] $detail");
    } catch (e) {
      debugPrint("[Group - cancel sent request] $e");
    } finally {
      _loadingMembers = false;
      notifyListeners();
    }
  }
}
