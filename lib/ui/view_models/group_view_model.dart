import 'package:chatting_app/data/models/groups.dart';
import 'package:chatting_app/data/repositories/auth_repo.dart';
import 'package:chatting_app/data/repositories/contact_repo.dart';
import 'package:chatting_app/data/responses/list_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class GroupViewModel extends ChangeNotifier {
  final ContactRepo _contactRepo = ContactRepo();
  final AuthRepo _authRepo = AuthRepo();

  ListResponse<Group>? _groupList;
  ListResponse<Group>? get groupList => _groupList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  GroupViewModel() {
    getUserGroups(1);
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
      );
      if (page == 1) {
        _groupList = response;
      } else {
        _groupList?.page = response.page;
        _groupList?.results = response.results;
      }
    } on DioException catch (e) {
      _setError("[Group List]: ${e.response?.data?["detail"]}");
    } finally {
      _setLoading(false);
    }
  }

  void getNextPage() {
    getUserGroups((_groupList?.page ?? 0) + 1);
  }
}
