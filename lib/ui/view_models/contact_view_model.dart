import 'package:chatting_app/data/models/contact.dart';
import 'package:chatting_app/data/repositories/auth_repo.dart';
import 'package:chatting_app/data/repositories/contact_repo.dart';
import 'package:chatting_app/data/responses/list_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ContactViewModel extends ChangeNotifier {
  ContactViewModel() {
    getFriendList();
    getPendingRequests();
    getSentRequests();
  }

  final ContactRepo _contactRepo = ContactRepo();
  final AuthRepo _authRepo = AuthRepo();

  // Contact lists
  ListResponse<Contact>? _friendList;
  ListResponse<Contact>? _pendingList;
  ListResponse<Contact>? _sentRequestList;

  ListResponse<Contact>? get friendList => _friendList;
  ListResponse<Contact>? get pendingList => _pendingList;
  ListResponse<Contact>? get sentRequestList => _sentRequestList;

  // Status
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

  /// Fetch friend list
  Future<void> getFriendList() async {
    _setLoading(true);
    try {
      final response = await _contactRepo.fetchFriendList();
      _friendList = response;
    } on DioException catch (e) {
      _setError("[Friend List]: ${e.response?.data?["detail"]}");
    } finally {
      _setLoading(false);
    }
  }

  /// Fetch received (pending) requests
  Future<void> getPendingRequests() async {
    _setLoading(true);
    try {
      final response = await _contactRepo.fetchPendingRequests();
      _pendingList = response;
    } on DioException catch (e) {
      _setError("[Pending List]: ${e.response?.data?["detail"]}");
    } finally {
      _setLoading(false);
    }
  }

  /// Fetch sent requests
  Future<void> getSentRequests() async {
    _setLoading(true);
    try {
      final response = await _contactRepo.fetchSentRequests();
      _sentRequestList = response;
    } on DioException catch (e) {
      _setError("[Sent Requests]: ${e.response?.data?["detail"]}");
    } finally {
      _setLoading(false);
    }
  }

  /// Accept a contact request
  Future<Contact?> acceptRequest(int contactId) async {
    _setLoading(true);
    try {
      final response = await _contactRepo.acceptContact(contactId);
      if (response.result != null) {
        _friendList?.results?.add(response.result!);
        _pendingList?.results?.removeWhere((c) => c.id == contactId);
      }
      debugPrint("[Accept Request] ${response.result?.toJson()}");
      return response.result!;
    } on DioException catch (e) {
      _setError("[Accept Request]: ${e.response?.data?["detail"]}");
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Dismiss a received request
  Future<int> dismissRequest(int contactId) async {
    _setLoading(true);
    try {
      final response = await _contactRepo.deleteContact(contactId);
      if (response.success) {
        _pendingList?.results?.removeWhere((c) => c.id == contactId);

        return contactId;
      }
      return -1;
    } on DioException catch (e) {
      _setError("[Dismiss Request] error : ${e.response?.data?["detail"]}");
      return -1;
    } finally {
      _setLoading(false);
    }
  }

  /// Dismiss a received request
  Future<int> cancelRequest(int contactId) async {
    _setLoading(true);
    try {
      final response = await _contactRepo.deleteContact(contactId);
      if (response.success) {
        _sentRequestList?.results?.removeWhere((c) => c.id == contactId);

        return contactId;
      }
      return -1;
    } on DioException catch (e) {
      _setError("[Dismiss Request] error : ${e.response?.data?["detail"]}");
      return -1;
    } finally {
      _setLoading(false);
    }
  }

  /// Send a new contact request
  Future<Contact?> sendRequest(int contactUserId) async {
    _setLoading(true);
    try {
      final response = await _contactRepo.sendContactRequest(
        _authRepo.currentUser!.id,
        contactUserId,
      );
      debugPrint("[Send Request] ${response.result?.toJson()}");
      if (response.success) {
        _sentRequestList?.results?.add(response.result!);
      }
      return response.result!;
    } on DioException catch (e) {
      _setError("[Send Request] error: ${e.response?.data?["detail"]}");
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Block a contact request
  Future<void> blockUser(int contactUserId) async {
    _setLoading(true);
    try {
      await _contactRepo.blockContactRequest(
        _authRepo.currentUser!.id,
        contactUserId,
      );
    } on DioException catch (e) {
      _setError("[Block User] error : ${e.response?.data?["detail"]}");
    } finally {
      _setLoading(false);
    }
  }
}
