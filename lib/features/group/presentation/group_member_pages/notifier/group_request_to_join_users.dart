import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pulse_chat/features/group/domain/entities/group_member.dart';
import 'package:pulse_chat/features/group/domain/usecase/group_member/accept_member.dart';
import 'package:pulse_chat/features/group/domain/usecase/group_member/delete_member.dart';
import 'package:pulse_chat/features/group/domain/usecase/group_member/get_group_members.dart';

class GroupRequestToJoinUsersNotifier extends ChangeNotifier {
  GroupRequestToJoinUsersNotifier({
    required GetGroupRequestToJoinUsers getRequestToJoinUsers,
    required DeleteMember deleteMember,
    required AcceptMember acceptMember,
  }) : _groupRequestToJoinUsers = getRequestToJoinUsers,
       _deleteMember = deleteMember,
       _acceptMember = acceptMember;

  // DEPENDENCIES --------------------------------------------------------------------------------
  final GetGroupRequestToJoinUsers _groupRequestToJoinUsers;

  final DeleteMember _deleteMember;

  final AcceptMember _acceptMember;

  // PROPERTIES-----------------------------------------------------------------------------------
  bool _loadingWaitingRequest = false;
  bool get loadingWaitingRequest => _loadingWaitingRequest;

  String? _errorWaitingRequest;
  String? get errorWaitingRequest => _errorWaitingRequest;

  List<GroupMember> _waitingRequests = [];
  List<GroupMember> get groupWaitings => _waitingRequests;

  bool _waitingRequestHasNext = false;
  bool get waitingRequestHasNext => _waitingRequestHasNext;

  int _waitingRequestPage = 0;
  int get waitingRequestPage => _waitingRequestPage;

  // METHODS -------------------------------------------------------------------------------------
  void getGroupWaitingRequests(int groupId, int page) async {
    _loadingWaitingRequest = true;
    _errorWaitingRequest = null;
    try {
      final response = await _groupRequestToJoinUsers(groupId, page: page);
      final requests = response.results;
      _waitingRequests = requests;
      _waitingRequestPage = response.page;
      _waitingRequestHasNext = response.page < response.totalPages;
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

  void acceptRequest(int groupId, int groupMemberId) async {
    try {
      final response = await _acceptMember(groupId, groupMemberId);
      if (response.success) {
        int index = _waitingRequests.indexWhere(
          (item) => item.id == groupMemberId,
        );
        _waitingRequests.removeAt(index);
      }
    } on DioException catch (e) {
      String detail = e.response!.data["detail"].toString();
      _errorWaitingRequest =
          "error happens when read group members, please try again";
      debugPrint("[Group member - accept joining request] $detail");
    } catch (e) {
      debugPrint("[Group member - accept joining request] $e");
    } finally {
      _loadingWaitingRequest = false;
      notifyListeners();
    }
  }

  void declineRequest(int groupId, int requestId) async {
    try {
      final response = await _deleteMember(groupId, requestId);
      if (response.success) {
        _waitingRequests.removeWhere((item) => item.id == requestId);
      }
    } on DioException catch (e) {
      String detail = e.response!.data["detail"].toString();
      _errorWaitingRequest =
          "error happens when read group members, please try again";
      debugPrint("[Group member - cancel sent request] $detail");
    } catch (e) {
      debugPrint("[Group member - cancel sent request] $e");
    } finally {
      _loadingWaitingRequest = false;
      notifyListeners();
    }
  }
}
