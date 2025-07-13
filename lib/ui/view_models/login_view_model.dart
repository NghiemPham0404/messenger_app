import 'dart:async';

import 'package:chatting_app/data/models/account.dart';
import 'package:chatting_app/data/models/user.dart';
import 'package:chatting_app/data/repositories/auth_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepo _authRepo = AuthRepo();

  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      final loginModel = LoginModel(email: email, password: password);

      final data = await _authRepo.login(loginModel);

      if (data != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("access_token", data.accessToken);
        await prefs.setString("refresh_token", data.refreshToken);

        _authRepo.requestGetCurrentUser(data.accessToken);
      }
    } on DioException catch (e) {
      debugPrint("[Login] DioException: $e");
      final errorDetail = e.response?.data['detail'] ?? e.message;
      _setError("Login failed: $errorDetail");
    } catch (e) {
      debugPrint("[Login] error: $e");
      _setError("Unexpected error: $e");
    } finally {
      _setLoading(false);
    }
  }

  Stream<User?> getCurrentUser() => _authRepo.currentUserStream;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void loginByGoogle() async {
    _setLoading(true);
    try {
      final data = await _authRepo.signInWithGoogle();

      if (data != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("access_token", data.accessToken);
        await prefs.setString("refresh_token", data.refreshToken);

        _authRepo.requestGetCurrentUser(data.accessToken);
      }
    } on DioException catch (e) {
      final errorDetail = e.response?.data['detail'] ?? e.message;
      debugPrint("[Login Google] DioException: $errorDetail");
      _setError("Login failed: $errorDetail");
    } catch (e) {
      debugPrint("[Login Google] error: $e");
      _setError("Unexpected error: $e");
    } finally {
      _setLoading(false);
    }
  }

  void signOutGoogle() async {
    try {
      _authRepo.signOutGoogle();
    } catch (error) {
      debugPrint("Sign out error: $error");
    }
  }
}
