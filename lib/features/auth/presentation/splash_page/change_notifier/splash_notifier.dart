import 'dart:async';

import 'package:pulse_chat/features/auth/domain/usecases/cached_login_user.dart';
import 'package:pulse_chat/features/auth/domain/usecases/relogin_current_user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashNotifier extends ChangeNotifier {
  bool _loading = true;
  bool get loading => _loading;

  ReloginCurrentUser reloginCurrentUser;
  CachedLoginUser cachedLoginUser;

  SplashNotifier({
    required this.reloginCurrentUser,
    required this.cachedLoginUser,
  });

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
      final res = await reloginCurrentUser();
      cachedLoginUser(res.result);
      onSuccess();
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
