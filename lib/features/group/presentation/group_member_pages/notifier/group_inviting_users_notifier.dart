import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pulse_chat/features/contact/domain/entities/contact.dart';
import 'package:pulse_chat/features/contact/domain/usecase/get_contacts_list.dart';
import 'package:pulse_chat/features/group/domain/entities/group_member_check.dart';
import 'package:pulse_chat/features/group/domain/entities/group_member_create.dart';
import 'package:pulse_chat/features/group/domain/usecase/group_member/check_member.dart';
import 'package:pulse_chat/features/group/domain/usecase/group_member/create_member.dart';
import 'package:pulse_chat/features/group/domain/usecase/group_member/delete_member.dart';
import 'package:pulse_chat/features/group/domain/usecase/group_member/get_group_members.dart';

import '../../../../../core/responses/list_response.dart';
import '../../../domain/entities/group_member.dart';

class GroupInvitingUsersNotifier extends ChangeNotifier {
  GroupInvitingUsersNotifier({
    required GetGroupInvitedUsers getGroupInvitedUsers,
    required InviteMember inviteMember,
    required DeleteMember deleteMember,
    required GetUserContacts getUsereContacts,
    required CheckMemberStatus checkMemberStatus,
  }) : _getGroupInvitedUsers = getGroupInvitedUsers,
       _inviteMember = inviteMember,
       _deleteMember = deleteMember,
       _getUsereContacts = getUsereContacts,
       _checkMemberStatus = checkMemberStatus;

  // DEPENDENCIES -------------------------------------------------------------------------------
  final GetGroupInvitedUsers _getGroupInvitedUsers;

  final CheckMemberStatus _checkMemberStatus;

  final InviteMember _inviteMember;

  final DeleteMember _deleteMember;

  final GetUserContacts _getUsereContacts;

  // PROPERTIES-----------------------------------------------------------------------------------
  bool _loadingSentRequest = false;
  bool get loadingSentRequest => _loadingSentRequest;

  String? _errorSentRequest;
  String? get errorSentRequest => _errorSentRequest;

  List<GroupMember> _sentRequests = [];
  List<GroupMember> get sentRequests => _sentRequests;

  bool _sentRequestHasNext = false;
  bool get sentRequestHasNext => _sentRequestHasNext;

  int _sentRequestPage = 0;
  int get sentRequestPage => _sentRequestPage;

  ListResponse<Contact>? _friendList;
  ListResponse<Contact>? get friendList => _friendList;

  Map<int, GroupMemberCheck> _checkedGroupMembers = {};
  Map<int, GroupMemberCheck> get checkedGroupMembers => _checkedGroupMembers;

  List<GroupMemberSelection>? _addtionalUsers;
  List<GroupMemberSelection>? get addtionalUsers => _addtionalUsers;

  // METHODS -------------------------------------------------------------------------------------

  void getGroupSentRequests(int groupId, int page) async {
    _loadingSentRequest = true;
    _errorSentRequest = null;
    try {
      final response = await _getGroupInvitedUsers(groupId, page: page);
      final requests = response.results;
      _sentRequests = requests;
      _sentRequestPage = response.page;
      _sentRequestHasNext = response.page < response.totalPages;
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
      final friendsResponse = await _getUsereContacts();
      _friendList = friendsResponse;
      final userIds =
          _friendList?.results.map((item) => item.otherUser.id).toList() ?? [];

      final response = await _checkMemberStatus(groupId, userIds);
      debugPrint(userIds.toString());
      for (var item in response.results) {
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
      final response = await _inviteMember(groupId: groupId, userId: userId);
      if (response.success) {
        _sentRequests.add(response.result);
        _checkedGroupMembers[userId]?.status = 0;
        removeMemberSelection(userId);
      }
    } on DioException catch (e) {
      String detail = e.response!.data["detail"].toString();
      _errorSentRequest =
          "error happens when add group members sent request user_id = $userId, please try again";
      debugPrint("[Group - add sent request] $detail");
    } catch (e) {
      debugPrint("[Group - add sent request] $e");
    } finally {
      _loadingSentRequest = false;
      notifyListeners();
    }
  }

  void cancelSentRequest(int groupId, int groupMemberId) async {
    try {
      final response = await _deleteMember(groupId, groupMemberId);
      if (response.success) {
        _sentRequests.removeWhere((item) => item.id == groupMemberId);
      }
    } on DioException catch (e) {
      String detail = e.response!.data["detail"].toString();
      _errorSentRequest =
          "error happens when read group members, please try again";
      debugPrint("[Group - cancel sent request] $detail");
    } catch (e) {
      debugPrint("[Group - cancel sent request] $e");
    } finally {
      _loadingSentRequest = false;
      notifyListeners();
    }
  }
}
