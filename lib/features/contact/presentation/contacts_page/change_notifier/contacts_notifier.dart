import 'package:pulse_chat/core/responses/list_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pulse_chat/features/contact/domain/entities/contact.dart';
import 'package:pulse_chat/features/contact/domain/usecase/delete_contact.dart';
import 'package:pulse_chat/features/contact/domain/usecase/get_contacts_list.dart';
import 'package:pulse_chat/features/contact/domain/usecase/update_contact.dart';

class ContactsNotifier extends ChangeNotifier {
  ContactsNotifier({
    required GetUserContacts getUserContacts,
    required GetUserPendingRequests getUserPendingRequests,
    required AcceptFriendRequest acceptContact,
    required DeleteContact deleteContact,
  }) : _getUserContacts = getUserContacts,
       _getUserPendingRequests = getUserPendingRequests,
       _acceptContact = acceptContact,
       _deleteContact = deleteContact;

  // DEPENDENCIES----------------------------------------------------------------------------------
  GetUserContacts _getUserContacts;
  GetUserPendingRequests _getUserPendingRequests;
  AcceptFriendRequest _acceptContact;
  DeleteContact _deleteContact;

  // PROPERTIES -----------------------------------------------------------------------------------
  ListResponse<Contact>? _friendList;
  ListResponse<Contact>? _pendingList;

  ListResponse<Contact>? get friendList => _friendList;
  ListResponse<Contact>? get pendingList => _pendingList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // METHODS --------------------------------------------------------------------------------------
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
      final response = await _getUserContacts();
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
      final response = await _getUserPendingRequests();
      _pendingList = response;
    } on DioException catch (e) {
      _setError("[Pending List]: ${e.response?.data?["detail"]}");
    } finally {
      _setLoading(false);
    }
  }

  /// Accept a contact request
  Future<Contact?> acceptRequest(int contactId) async {
    _setLoading(true);
    try {
      final response = await _acceptContact(contactId);
      _friendList?.results.add(response.result);
      _pendingList?.results.removeWhere((c) => c.id == contactId);
      return response.result;
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
      await _deleteContact(contactId);
      _pendingList?.results.removeWhere((c) => c.id == contactId);
      return contactId;
    } on DioException catch (e) {
      _setError("[Dismiss Request] error : ${e.response?.data?["detail"]}");
      return -1;
    } finally {
      _setLoading(false);
    }
  }
}
