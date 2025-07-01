import 'dart:async';

import 'package:chatting_app/data/models/user.dart';
import 'package:chatting_app/data/network/api_client.dart';
import 'package:chatting_app/data/network/auth_api.dart';
import 'package:chatting_app/data/responses/auth_response.dart';
import 'package:chatting_app/data/responses/object_response.dart';
import 'package:chatting_app/util/web_socket_service.dart';
import '../models/account.dart';

class AuthRepo {
  static final AuthApiClient _authApiClient = AuthApiClient();
  static final ApiClient _apiClient = ApiClient();
  static final AuthApi _authApi = _authApiClient.getAuthApi();

  AuthRepo.internal();

  static final AuthRepo _instance = AuthRepo.internal();

  factory AuthRepo() => _instance;

  final StreamController<User?> _userOutStream = StreamController.broadcast();

  User? _currentUser;

  Stream<User?> get currentUserStream => _userOutStream.stream;

  User? get currentUser => _currentUser;

  Future<AuthResponse?> login(LoginModel loginModel) async {
    return await _authApi.login(loginModel);
  }

  void initAPIClient(String accessToken) {
    _apiClient.initialize(accessToken);
  }

  void requestGetCurrentUser(String accessToken) async {
    // init api client once when user login successfully
    initAPIClient(accessToken);

    if (!_userOutStream.isClosed) {
      await _authApi.getCurrentUser('Bearer ${accessToken}').then((data) {
        _userOutStream.add(data.result!);
        _currentUser = data.result;

        final webSocketService = WebSocketService();
        webSocketService.connect(data.result!.id, accessToken);
      });
    }
  }

  Future<ObjectResponse<User>> signUp(SignUpModel signUpBody) async {
    return await _authApi.signUp(signUpBody);
  }
}
