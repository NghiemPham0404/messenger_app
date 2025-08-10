import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pulse_chat/features/group/domain/entities/group.dart';
import 'package:pulse_chat/features/group/domain/entities/group_member_check.dart';
import 'package:pulse_chat/features/group/domain/usecase/group/get_user_invite_groups.dart';
import 'package:pulse_chat/features/group/domain/usecase/group/get_user_joined_groups.dart';
import 'package:pulse_chat/features/group/domain/usecase/group_member/accept_member.dart';

class UserGroupsNotifier extends ChangeNotifier {
  // DEPENDENCIES --------------------------------------------------------------------------------
  final LocalAuthSource _localAuthSource;

  final GetUserJoinedGroups _getUserJoinedGroups;

  final GetUserInviteGroup _getUserInviteGroup;

  final AcceptMember _acceptJoinGroupInvite;

  UserGroupsNotifier({
    required LocalAuthSource localAuthSource,
    required GetUserJoinedGroups getUserJoinedGroups,
    required GetUserInviteGroup getUserInviteGroup,
    required AcceptMember acceptMember,
  }) : _localAuthSource = localAuthSource,
       _getUserJoinedGroups = getUserJoinedGroups,
       _getUserInviteGroup = getUserInviteGroup,
       _acceptJoinGroupInvite = acceptMember;

  // PROPERTIES ----------------------------------------------------------------------------------
  List<Group> _userGroups = [];
  List<Group> get userGroups => _userGroups;

  int _userGroupPage = 0;
  int get userGroupPage => _userGroupPage;

  bool _userGroupHasNext = false;
  bool get userGroupHasNext => _userGroupHasNext;

  int _totalUserGroup = 0;
  int get totalUserGroup => _totalUserGroup;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void getUserGroups(int page) async {
    _setLoading(true);
    try {
      final response = await _getUserJoinedGroups(page: page);
      _userGroupPage = response.page;
      if (page == 1) {
        _userGroups = response.results;
        _totalUserGroup = response.totalResults;
      } else {
        _userGroups.addAll(response.results);
      }
      _userGroupHasNext = response.page < response.totalPages;
    } on DioException catch (e) {
      _setError("[Group List]: ${e.response?.data?["detail"]}");
    } finally {
      debugPrint(_userGroups.length.toString());
      _setLoading(false);
    }
  }

  void getUserGroupNext() {
    if (_userGroupHasNext) {
      getUserGroups(_userGroupPage + 1);
    }
  }

  List<Group> _joiningInvites = [];
  List<Group> get joiningInvites => _joiningInvites;

  Map<int, GroupMemberCheck> memberStatusMap = {};

  int _joiningInvitePage = 0;
  int get joiningInvitePage => _joiningInvitePage;

  bool _joiningInviteHasNext = false;
  bool get joiningInviteHasNext => _joiningInviteHasNext;

  int _totalInvites = 0;
  int get totalInvites => _totalInvites;

  void getUserJoiningGroupInvites(int page) async {
    _setLoading(true);
    try {
      final response = await _getUserInviteGroup(page: page);
      _joiningInvitePage = response.page;
      if (page == 1) {
        _joiningInvites = response.results;

        for (final group in _joiningInvites) {
          memberStatusMap[group.id] = GroupMemberCheck(
            userId: _localAuthSource.getCachedUser()?.id ?? 0,
            isHost: false,
            isSubHost: false,
            status: 0,
          );
        }

        _totalInvites = response.totalResults;
      } else {
        _joiningInvites.addAll(response.results);
      }
      _joiningInviteHasNext = response.page < response.totalPages;
    } on DioException catch (e) {
      _setError("[Group List]: ${e.response?.data?["detail"]}");
    } finally {
      _setLoading(false);
    }
  }

  void getUserJoinningGroupInvitesNext() {
    if (_joiningInviteHasNext) {
      getUserJoiningGroupInvites(_joiningInvitePage + 1);
    }
  }

  void acceptRequest(int groupId, int groupMemberId) async {
    _isLoading = true;
    try {
      final response = await _acceptJoinGroupInvite(groupId, groupMemberId);
      if (response.success) {
        int index = _joiningInvites.indexWhere((item) => item.id == groupId);
        _userGroups.add(_joiningInvites[index]);
        _joiningInvites.removeAt(index);
        memberStatusMap[groupId]!.status = 1;
      }
    } on DioException catch (e) {
      String detail = e.response!.data["detail"].toString();
      _errorMessage = "error happens when read group members, please try again";
      debugPrint("[Group member - accept joining request] $detail");
    } catch (e) {
      debugPrint("[Group member - accept joining request] $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
