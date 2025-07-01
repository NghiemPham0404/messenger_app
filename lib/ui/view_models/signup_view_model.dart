// ignore_for_file: unused_import

import 'package:chatting_app/data/models/account.dart';
import 'package:chatting_app/data/models/user.dart';
import 'package:chatting_app/data/repositories/auth_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpViewModel extends ChangeNotifier {
  final _authRepo = AuthRepo();

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

  void register(String email, String name, String password) async {
    _setLoading(true);

    if (email.isEmpty || name.isEmpty || password.isEmpty) {
      _setError("All fields are required");
      _setLoading(false);
      return;
    }

    final signUpBody = SignUpModel(
      email: email,
      name: name,
      password: password,
    );
    try {
      _authRepo.signUp(signUpBody).then((data) async {
        final loginModel = LoginModel(email: email, password: password);

        final data = await _authRepo.login(loginModel);

        if (data != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("access_token", data.accessToken);
          await prefs.setString("refresh_token", data.refreshToken);

          _authRepo.requestGetCurrentUser(data.accessToken);
        }
      });
    } on DioException catch (e) {
      final errorDetail = e.response?.data['detail'] ?? e.message;
      debugPrint("[SignUp] : $errorDetail");
      _setError("Failed to fetch users: $errorDetail");
    } finally {
      _setLoading(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void avatarGenerate(String name) {
    if (name.length > 1) {
      notifyListeners();
    }
  }
}
