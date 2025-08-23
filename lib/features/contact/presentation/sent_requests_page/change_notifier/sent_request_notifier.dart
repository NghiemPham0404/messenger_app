import 'package:pulse_chat/core/responses/list_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pulse_chat/features/contact/domain/entities/contact.dart';
import 'package:pulse_chat/features/contact/domain/usecase/delete_contact.dart';
import 'package:pulse_chat/features/contact/domain/usecase/get_contacts_list.dart';

class SentRequestsNotifier extends ChangeNotifier {
  SentRequestsNotifier({
    required GetUserSentRequests getUserSentRequests,
    required DeleteContact deleteContact,
  }) : _getUserSentRequests = getUserSentRequests,
       _deleteContact = deleteContact;

  // DEPENDENCIES

  final GetUserSentRequests _getUserSentRequests;

  final DeleteContact _deleteContact;

  // PROPERTIES

  ListResponse<Contact>? _sentRequestList;

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

  /// Fetch sent requests
  Future<void> getSentRequests() async {
    _setLoading(true);
    try {
      final response = await _getUserSentRequests();
      _sentRequestList = response;
    } on DioException catch (e) {
      _setError("[Sent Requests]: ${e.response?.data?["detail"]}");
    } finally {
      _setLoading(false);
    }
  }

  // Cancel a friend request
  Future<int> cancelRequest(int contactId) async {
    _setLoading(true);
    try {
      final response = await _deleteContact(contactId);
      if (response.success) {
        _sentRequestList?.results.removeWhere((c) => c.id == contactId);
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
}
