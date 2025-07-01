import 'dart:async';

import 'package:chatting_app/data/models/user.dart';
import 'package:chatting_app/data/network/api_client.dart';
import 'package:chatting_app/data/responses/list_response.dart';

class UserRepo {
  static final ApiClient _apiClient = ApiClient();

  UserRepo.internal();

  static final UserRepo _instance = UserRepo.internal();

  factory UserRepo() => _instance;

  Future<ListResponse<UserExtended>?> fetchUsers(
    String keyword, {
    int page = 1,
  }) async {
    return await _apiClient.userApi.getUsers(keyword, page);
  }
}
