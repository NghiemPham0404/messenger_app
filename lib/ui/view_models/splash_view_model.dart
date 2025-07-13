import 'dart:async';

import 'package:chatting_app/data/models/user.dart';
import 'package:chatting_app/data/repositories/auth_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenViewModel extends ChangeNotifier {
  final AuthRepo _authRepo = AuthRepo();

  bool _loading = true;
  bool get loading => _loading;

  Stream<User?> get loginUser => _authRepo.currentUserStream;

  Future<void> reLogin(VoidCallback onSuccess, VoidCallback onFailure) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString("access_token");
      final refreshToken = prefs.getString("refresh_token");

      if (accessToken == null || refreshToken == null) {
        onFailure();
        return;
      }

      // Try to get current user with existing access token
      User? user = await _authRepo.requestGetCurrentUser(accessToken);

      if (user == null) {
        // Try refresh token if access token is invalid
        final newTokens = await _authRepo.refreshToken(refreshToken);

        if (newTokens != null) {
          await prefs.setString("access_token", newTokens.accessToken);
          await prefs.setString("refresh_token", newTokens.refreshToken);

          user = await _authRepo.requestGetCurrentUser(newTokens.accessToken);
        } else {
          onFailure();
        }
      }

      if (user != null) {
        onSuccess();
      } else {
        onFailure();
      }
    } on DioException catch (e) {
      final detail = e.response?.data['detail'] ?? e.message;
      debugPrint("[reLogin] DioException: $detail");
      onFailure();
    } catch (e) {
      debugPrint("[reLogin] Unexpected error: $e");
      onFailure();
    } finally {
      _loading = false;
    }
  }
}
