import 'package:chatting_app/data/models/group.dart';
import 'package:chatting_app/data/models/group_member.dart';
import 'package:chatting_app/data/repositories/auth_repo.dart';
import 'package:chatting_app/data/repositories/contact_repo.dart';
import 'package:chatting_app/data/repositories/group_member_repo.dart';
import 'package:chatting_app/data/repositories/group_repo.dart';
import 'package:chatting_app/data/repositories/media_file_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

part 'group_view_model.create.dart';

class GroupViewModel extends ChangeNotifier {
  final ContactRepo _contactRepo = ContactRepo();
  final AuthRepo _authRepo = AuthRepo();

  final _groupRepo = GroupRepo();
  final _groupMemberRepo = GroupMemberRepo();
  final _fileRepo = MediaFileRepo();

  XFile? _choosenAvatar;
  XFile? get choosenAvatar => _choosenAvatar;

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

  List<GroupMemberSelection>? _groupInitialUsers;
  List<GroupMemberSelection>? get groupInitialUser => _groupInitialUsers;

  GroupViewModel() {
    getUserGroups(1);
    getUserJoiningGroupInvites(1);
  }

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
      final response = await _contactRepo.fetchGroupRequests(
        _authRepo.currentUser!.id,
        page: page,
      );
      _userGroupPage = response.page ?? 0;
      if (page == 1) {
        _userGroups = response.results ?? [];
        _totalUserGroup = response.totalResults ?? 0;
      } else {
        _userGroups.addAll(response.results ?? []);
      }
      _userGroupHasNext = (response.page ?? 0) < (response.totalPages ?? 0);
    } on DioException catch (e) {
      _setError("[Group List]: ${e.response?.data?["detail"]}");
    } finally {
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
      final response = await _contactRepo.fetchGroupRequests(
        _authRepo.currentUser!.id,
        status: 0,
        page: page,
      );
      _joiningInvitePage = response.page ?? 0;
      if (page == 1) {
        _joiningInvites = response.results ?? [];

        for (final group in _joiningInvites) {
          final groupMemberStatus = await _groupMemberRepo.checkGroupMember(
            group.id,
            [_authRepo.currentUser!.id],
          );
          memberStatusMap[group.id] =
              groupMemberStatus.results != null
                  ? groupMemberStatus.results![0]
                  : GroupMemberCheck(
                    userId: _authRepo.currentUser!.id,
                    isHost: false,
                    isSubHost: false,
                    status: 0,
                  );
        }

        _totalInvites = response.totalResults ?? 0;
      } else {
        _joiningInvites.addAll(response.results ?? []);
      }
      _joiningInviteHasNext = response.page! < response.totalPages!;
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
      final groupMemberUpdate = GroupMemberUpdate(
        isHost: false,
        isSubHost: false,
        status: 1,
      );
      final response = await _groupMemberRepo.updateGroupMember(
        groupId,
        groupMemberId,
        groupMemberUpdate,
      );
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
