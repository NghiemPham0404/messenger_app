import 'dart:async';
import 'package:pulse_chat/features/auth/domain/entities/login.dart';
import 'package:pulse_chat/features/auth/domain/usecases/cached_login_user.dart';
import 'package:pulse_chat/features/auth/domain/usecases/get_current_user.dart';
import 'package:pulse_chat/features/auth/domain/usecases/get_signin_google.dart';
import 'package:pulse_chat/features/auth/domain/usecases/login_by_email.dart';
import 'package:pulse_chat/features/auth/domain/usecases/login_by_google.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../domain/entities/user.dart';
import 'package:pulse_chat/core/util/page_state.dart';

class LoginNotifier extends ChangeNotifier {
  final LoginByEmail _loginByEmail;
  final LoginByGoogle _loginByGoogle;
  final GetCurrentUser _getCurrentUser;
  final CachedLoginUser _cachedLoginUser;
  final GetSigninGoogle _getSigninGoogle;

  PageState _pageState = PageState.initial;
  PageState get pageState => _pageState;

  final StreamController<User?> _userOutStream = StreamController.broadcast();

  Stream<User?> getCurrentUser() => _userOutStream.stream;

  LoginNotifier({
    required LoginByEmail loginByEmail,
    required LoginByGoogle loginByGoogle,
    required GetCurrentUser getCurrentUser,
    required CachedLoginUser cachedLoginUser,
    required GetSigninGoogle getSigninGoogle,
  }) : _loginByEmail = loginByEmail,
       _loginByGoogle = loginByGoogle,
       _getCurrentUser = getCurrentUser,
       _cachedLoginUser = cachedLoginUser,
       _getSigninGoogle = getSigninGoogle;

  Future<void> login(String email, String password) async {
    _pageState = PageState.loading;
    notifyListeners();
    try {
      final loginEntity = Login(email: email, password: password);

      final data = await _loginByEmail(loginEntity);
      if (data.accessToken.isNotEmpty) {
        final currentUser = await _getCurrentUser();
        if (currentUser.success) {
          _cachedLoginUser(currentUser.result);
          _userOutStream.add(currentUser.result);
          _pageState = PageState.success;
        }
      }
    } on DioException catch (e) {
      debugPrint("[Login] DioException: $e");
      final errorDetail = e.response?.data['detail'] ?? e.message;
      _pageState = PageState.error;
      _setError("Login failed: $errorDetail");
    } catch (e) {
      debugPrint("[Login] error: $e");
      _pageState = PageState.error;
      _setError("Unexpected error: $e");
    } finally {
      notifyListeners();
    }
  }

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void loginByGoogle() async {
    _pageState = PageState.loading;
    notifyListeners();
    try {
      final signedGoogleAccount = await _getSigninGoogle();
      await _loginByGoogle(signedGoogleAccount);

      final currentUser = await _getCurrentUser();
      if (currentUser.success) {
        _cachedLoginUser(currentUser.result);
        _userOutStream.add(currentUser.result);
        _pageState = PageState.success;
      }
    } on DioException catch (e) {
      final errorDetail = e.response?.data['detail'] ?? e.message;
      debugPrint("[Login Google] DioException: $errorDetail");
      _pageState = PageState.error;
      _setError("Login failed: $errorDetail");
    } catch (e) {
      debugPrint("[Login Google] error: $e");
      _pageState = PageState.error;
      _setError("Unexpected error: $e");
    } finally {
      notifyListeners();
    }
  }
}
