import 'package:pulse_chat/data/models/contact.dart';
import 'package:pulse_chat/data/models/user.dart';
import 'package:pulse_chat/data/models/group.dart';
import 'package:pulse_chat/data/repositories/group_repo.dart';
import 'package:pulse_chat/data/repositories/user_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class SearchViewModel extends ChangeNotifier {
  final UserRepo _userRepo = UserRepo();
  final GroupRepo _groupRepo = GroupRepo();

  List<UserExtended> users = [];
  List<Group> groups = [];

  int _usersPage = 0;
  int _usersMaxPage = 0;
  int usersTotal = 0;
  bool usersMore = false;

  int _groupsPage = 0;
  int _groupsMaxPage = 0;
  int groupsTotal = 0;
  bool groupsMore = false;

  String cachedQuery = "";

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

  Future<void> fetchUsers(String query, {int page = 1}) async {
    cachedQuery = query;
    _setLoading(true);
    _setError(null);
    try {
      await _userRepo.fetchUsers(query, page: page).then((data) {
        if (data != null) {
          if (page == 1) {
            _usersPage = 1;
            users = data.results ?? [];
            _usersMaxPage = data.totalPages ?? _usersMaxPage;
            usersTotal = data.totalResults ?? 0;
          } else {
            users.addAll(data.results ?? []);
            _usersPage = data.page ?? _usersPage;
          }
          usersMore = _usersPage < _usersMaxPage;
        }
      });
    } on DioException catch (e) {
      _setError("Failed to fetch users: ${e.message}");
      final errorDetail = e.response?.data['detail'] ?? e.message;
      debugPrint(errorDetail);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchUsersNext() async {
    if (usersMore) {
      fetchUsers(cachedQuery, page: _usersPage + 1);
    }
  }

  Future<void> fetchGroups(String query, {int page = 1}) async {
    _setLoading(true);
    _setError(null);
    try {
      await _groupRepo.fetchGroups(query, page: page).then((data) {
        if (data != null) {
          if (page == 1) {
            groups = data.results ?? [];
            _groupsPage = 1;
            _groupsMaxPage = data.totalPages ?? _groupsMaxPage;
            groupsTotal = data.totalResults ?? 0;
          } else {
            groups.addAll(data.results ?? []);
            _groupsPage = data.page ?? _groupsPage;
          }
          groupsMore = _groupsPage < _groupsMaxPage;
        }
      });
    } on DioException catch (e) {
      _setError("Failed to fetch groups: ${e.message}");
      final errorDetail = e.response?.data['detail'] ?? e.message;
      debugPrint(errorDetail);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchGroupsNext() async {
    if (groupsMore) {
      fetchGroups(cachedQuery);
    }
  }

  /// Update a user that we just sent friend request to
  void sentRequest(Contact contact) {
    for (int i = 0; i < users.length; i++) {
      if (users[i].id == contact.contactUserId) {
        users[i].relationship.contactId = contact.id;
        users[i].relationship.contactStatus = 0;
        users[i].relationship.isSentRequest = true;
        break;
      }
    }

    notifyListeners();
  }

  /// Update a user that we just accept or dismiss their friend request
  void acceptPendingRequest(int contactId) {
    for (int i = 0; i < users.length; i++) {
      if (users[i].relationship.contactId == contactId) {
        users[i].relationship.contactStatus = 1;
        break;
      }
    }
    notifyListeners();
  }

  void dismissOrDeleteRequest(int contactId) {
    for (int i = 0; i < users.length; i++) {
      if (users[i].relationship.contactId == contactId) {
        users[i].relationship.contactId = -1;
        users[i].relationship.isSentRequest = false;
        users[i].relationship.contactStatus = -1;
        break;
      }
    }
    notifyListeners();
  }
}
