// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
part of 'group_member_view_model.dart';

extension GroupMemberViewModelWaitingRequest on GroupMemberViewModel {
  void getGroupWaitingRequests(int groupId, int page) async {
    _loadingWaitingRequest = true;
    _errorWaitingRequest = null;
    try {
      final response = await _groupMemberRepo.fetchGroupMember(
        groupId,
        2,
        page,
      );
      final requests = response.results!;
      _waitingRequests = requests;
      _waitingRequestPage = response.page!;
      _waitingRequestHasNext = response.page! < response.totalPages!;
    } on DioException catch (e) {
      String detail = e.response!.data["detail"].toString();
      _errorWaitingRequest =
          "error happens when read joining group sent request , please try again";
      debugPrint(detail);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _loadingWaitingRequest = false;
      notifyListeners();
    }
  }

  void getGroupWaitingRequestsNext(int groupId) async {
    getGroupWaitingRequests(groupId, _waitingRequestPage + 1);
  }

  void declineRequest(int groupId, int requestId) async {
    try {
      final response = await _groupMemberRepo.deleteGroupMember(
        groupId,
        requestId,
      );
      if (response.success) {
        _waitingRequests.removeWhere((item) => item.id == requestId);
      }
    } on DioException catch (e) {
      String detail = e.response!.data["detail"].toString();
      _errorWaitingRequest =
          "error happens when read group members, please try again";
      debugPrint("[Group - cancel sent request] $detail");
    } catch (e) {
      debugPrint("[Group - cancel sent request] $e");
    } finally {
      _loadingWaitingRequest = false;
      notifyListeners();
    }
  }
}
