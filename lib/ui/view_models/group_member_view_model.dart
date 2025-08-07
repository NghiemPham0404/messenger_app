import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:pulse_chat/data/models/contact.dart';
import 'package:pulse_chat/data/models/group_member.dart';
import 'package:pulse_chat/data/repositories/contact_repo.dart';
import 'package:pulse_chat/data/repositories/group_member_repo.dart';
import 'package:pulse_chat/core/responses/list_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

part 'group_member_view_model.members.dart';
part 'group_member_view_model.sent_request.dart';
part 'group_member_view_model.waiting_request.dart';

class GroupMemberViewModel extends ChangeNotifier {
  final _groupMemberRepo = GroupMemberRepo();
  final _contactRepo = ContactRepo();
  late final LocalAuthSource localAuthSource;

  int get userId => localAuthSource.getCachedUser()?.id ?? 0;

  GroupMemberViewModel(int groupId) {
    getGroupMembers(groupId, 1);
    getGroupSentRequests(groupId, 1);
    getGroupWaitingRequests(groupId, 1);
    checkPreSendRequest(groupId);
  }

  // Attributes for group members manage
  bool _loadingMembers = false;
  bool get loadingMembers => _loadingMembers;

  String? _errorMembers;
  String? get errorMembers => _errorMembers;

  int _membersPage = 0;
  int get membersPage => _membersPage;

  bool _membersHasNext = false;
  bool get memberHasNext => _membersHasNext;

  List<GroupMember> _groupMembers = [];
  List<GroupMember> get groupMembers => _groupMembers;

  // Attributes for group member requests manage
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

  // Attributes for pending group joining requests from user
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
}
