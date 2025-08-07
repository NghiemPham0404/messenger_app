import 'dart:async';

import 'package:pulse_chat/data/models/user.dart';
import 'package:pulse_chat/data/network/api_client.dart';
import 'package:pulse_chat/core/responses/list_response.dart';

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
