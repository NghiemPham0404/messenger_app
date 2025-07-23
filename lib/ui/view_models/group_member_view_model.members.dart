// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

part of 'group_member_view_model.dart';

extension GroupMemberViewModelMembers on GroupMemberViewModel {
  void getGroupMembers(int groupId, int page) async {
    _loadingMembers = true;
    _errorMembers = null;
    try {
      final response = await _groupMemberRepo.fetchGroupMember(
        groupId,
        1,
        page,
      );
      final members = response.results!;
      _groupMembers = members;
      _membersPage = response.page!;
      _membersHasNext = response.page! < response.totalPages!;
    } on DioException catch (e) {
      String detail = e.response!.data["detail"].toString();
      _errorMembers = "error happens when read group members, please try again";
      debugPrint("[Group - members] $detail");
    } catch (e) {
      debugPrint("[Group - members] $e");
    } finally {
      _loadingMembers = false;
      notifyListeners();
    }
  }

  void getGroupMembersNext(int groupId) async {
    getGroupMembers(groupId, _membersPage + 1);
  }

  void grantSubHost(int groupId, int groupMemberId) async {
    try {
      final groupMemberUpdate = GroupMemberUpdate(
        isHost: false,
        isSubHost: true,
        status: 1,
      );
      final response = await _groupMemberRepo.updateGroupMember(
        groupId,
        groupMemberUpdate,
      );
      if (response.success) {
        int index = _groupMembers.indexWhere(
          (item) => item.id == groupMemberId,
        );
        _groupMembers[index] = response.result!;
      }
    } on DioException catch (e) {
      String detail = e.response!.data["detail"].toString();
      _errorMembers = "error happens when read group members, please try again";
      debugPrint("[Group - delete member] $detail");
    } catch (e) {
      debugPrint("[Group - delete member] $e");
    } finally {
      _loadingMembers = false;
      notifyListeners();
    }
  }

  void deleteGroupMember(int groupId, int groupMemberId) async {
    try {
      final response = await _groupMemberRepo.deleteGroupMember(
        groupId,
        groupMemberId,
      );
      if (response.success) {
        _groupMembers.removeWhere((item) => item.id == groupMemberId);
      }
    } on DioException catch (e) {
      String detail = e.response!.data["detail"].toString();
      _errorMembers = "error happens when read group members, please try again";
      debugPrint("[Group - delete member] $detail");
    } catch (e) {
      debugPrint("[Group - delete member] $e");
    } finally {
      _loadingMembers = false;
      notifyListeners();
    }
  }
}
