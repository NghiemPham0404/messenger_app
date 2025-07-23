// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
part of 'group_member_view_model.dart';

extension GroupMemberViewModelSentRequest on GroupMemberViewModel {
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

  void getGroupSentRequestsNext(int groupId) async {
    getGroupSentRequests(groupId, _sentRequestPage + 1);
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
