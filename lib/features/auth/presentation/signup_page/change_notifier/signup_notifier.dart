// ignore_for_file: unused_import
import 'dart:async';

import 'package:pulse_chat/core/util/page_state.dart';
import 'package:pulse_chat/data/models/account.dart';
import 'package:pulse_chat/data/models/user.dart';
import 'package:pulse_chat/features/auth/domain/entities/signup.dart';
import 'package:pulse_chat/features/auth/domain/usecases/sign_up_by_email.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpNotifier extends ChangeNotifier {
  final SignUpByEmail signUpByEmail;

  SignUpNotifier(this.signUpByEmail);

  PageState _pageState = PageState.initial;
  PageState get pageState => _pageState;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void register(
    String email,
    String name,
    String password, {
    required VoidCallback onSuccess,
  }) async {
    _pageState = PageState.loading;

    if (email.isEmpty || name.isEmpty || password.isEmpty) {
      _setError("All fields are required");
      _pageState = PageState.error;
      notifyListeners();
      return;
    }

    final signUpBody = SignUp(email: email, name: name, password: password);
    try {
      final res = await signUpByEmail(signUpBody);
      if (res.success) {
        _setError(null);
        onSuccess();
      }
    } on DioException catch (e) {
      final errorDetail = e.response?.data['detail'] ?? e.message;
      debugPrint("[SignUp] : $errorDetail");
      _pageState = PageState.error;
      _setError("Failed to fetch users: $errorDetail");
    } finally {
      notifyListeners();
    }
  }

  void avatarGenerate(String name) {
    if (name.length > 1) {
      notifyListeners();
    }
  }
}
