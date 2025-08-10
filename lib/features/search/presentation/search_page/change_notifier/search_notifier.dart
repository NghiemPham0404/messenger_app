import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:pulse_chat/features/contact/domain/usecase/create_contact.dart';
import 'package:pulse_chat/features/contact/domain/usecase/delete_contact.dart';
import 'package:pulse_chat/features/contact/domain/usecase/update_contact.dart';
import 'package:pulse_chat/features/group/domain/entities/group.dart';
import 'package:pulse_chat/features/group/domain/usecase/group/search_groups.dart';
import 'package:pulse_chat/features/user/domain/entities/user_extend.dart';
import 'package:pulse_chat/features/user/domain/usecase/search_users.dart';

class SearchNotifier extends ChangeNotifier {
  SearchNotifier({
    required SearchUsers searchUsers,
    required SearchGroups searchGroups,
    required SendFriendRequest sendFriendRequest,
    required AcceptFriendRequest acceptFriendRequest,
    required DeleteContact dismissFriendRequest,
  }) : _searchUsers = searchUsers,
       _searchGroups = searchGroups,
       _sendFriendRequest = sendFriendRequest,
       _acceptFriendRequest = acceptFriendRequest,
       _dismissFriendRequest = dismissFriendRequest;

  // DEPENDENCIES ---------------------------------------------------------------------------------
  final SearchUsers _searchUsers;
  final SearchGroups _searchGroups;
  final SendFriendRequest _sendFriendRequest;
  final AcceptFriendRequest _acceptFriendRequest;
  final DeleteContact _dismissFriendRequest;

  // PROPERTIES------------------------------------------------------------------------------------
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

  // METHODS ------------------------------------------------------------------------------------

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
      await _searchUsers(query, page: page).then((data) {
        if (page == 1) {
          _usersPage = 1;
          users = data.results;
          _usersMaxPage = data.totalPages;
          usersTotal = data.totalResults;
        } else {
          users.addAll(data.results);
          _usersPage = data.page;
        }
        usersMore = _usersPage < _usersMaxPage;
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
      await _searchGroups(query: query, page: page).then((data) {
        if (page == 1) {
          groups = data.results;
          _groupsPage = 1;
          _groupsMaxPage = data.totalPages;
          groupsTotal = data.totalResults;
        } else {
          groups.addAll(data.results);
          _groupsPage = data.page;
        }
        groupsMore = _groupsPage < _groupsMaxPage;
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
  void sentRequest(int contactUserId) async {
    try {
      final response = await _sendFriendRequest(contactUserId);

      for (int i = 0; i < users.length; i++) {
        if (users[i].id == contactUserId) {
          users[i].relationship.contactId = response.result.id;
          users[i].relationship.contactStatus = 0;
          users[i].relationship.isSentRequest = true;
          break;
        }
      }
    } on DioException catch (e) {
      final errorDetail = e.response?.data['detail'] ?? e.message;
      debugPrint(errorDetail);
      _setError("An error occurred, please try again");
    } finally {}

    notifyListeners();
  }

  /// Update a user that we just accept or dismiss their friend request
  void acceptPendingRequest(int contactId) async {
    try {
      final response = await _acceptFriendRequest(contactId);

      for (int i = 0; i < users.length; i++) {
        if (users[i].id == response.result.contactUserId) {
          users[i].relationship.contactStatus = 1;
          users[i].relationship.isSentRequest = true;
          break;
        }
      }
    } on DioException catch (e) {
      final errorDetail = e.response?.data['detail'] ?? e.message;
      debugPrint(errorDetail);
      _setError("An error occurred, please try again");
    } finally {
      notifyListeners();
    }
  }

  void dismissOrDeleteRequest(int contactId) async {
    try {
      await _dismissFriendRequest(contactId);

      for (int i = 0; i < users.length; i++) {
        if (users[i].relationship.contactId == contactId) {
          users[i].relationship.contactId = -1;
          users[i].relationship.isSentRequest = false;
          users[i].relationship.contactStatus = -1;
        }
      }
    } on DioException catch (e) {
      final errorDetail = e.response?.data['detail'] ?? e.message;
      debugPrint(errorDetail);
      _setError("An error occurred, please try again");
    } finally {
      notifyListeners();
    }
  }
}
