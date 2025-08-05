import 'dart:async';

import 'package:pulse_chat/core/network/responses/object_response.dart';
import 'package:pulse_chat/features/auth/data/models/login_google_model.dart';
import 'package:pulse_chat/features/auth/data/models/login_model.dart';
import 'package:pulse_chat/features/auth/data/models/refresh_token_model.dart';
import 'package:pulse_chat/features/auth/data/models/signup_model.dart';
import 'package:pulse_chat/features/auth/data/source/firebase/firebase_auth_source.dart';
import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:pulse_chat/features/auth/data/source/network/api_auth_source.dart';
import 'package:pulse_chat/features/auth/domain/entities/auth_res.dart';
import 'package:pulse_chat/features/auth/domain/entities/login.dart';
import 'package:pulse_chat/features/auth/domain/entities/login_google.dart';
import 'package:pulse_chat/features/auth/domain/entities/refresh_token.dart';
import 'package:pulse_chat/features/auth/domain/entities/signup.dart';
import 'package:pulse_chat/features/auth/domain/entities/user.dart';
import 'package:pulse_chat/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiAuthSource _apiAuthSource;
  final LocalAuthSource _localAuthSource;
  final _firebaseAuthSource = FirebaseAuthSource();

  AuthRepositoryImpl(this._apiAuthSource, this._localAuthSource);

  final _currentUserController = StreamController<User?>.broadcast();

  @override
  Future<ObjectResponse<User>> getCurrentUser() async {
    final token = await _localAuthSource.getToken();
    final response = await _apiAuthSource.getCurrentUser("Bearer $token");
    if (response.result != null) {
      _currentUserController.add(response.result);
      _localAuthSource.cachedUser(response.result!);
    }
    return response;
  }

  @override
  Future<AuthResponse> login(Login loginEntity) async {
    final loginModel = LoginModel(
      email: loginEntity.email,
      password: loginEntity.password,
    );

    final res = await _apiAuthSource.login(loginModel);
    _localAuthSource.saveToken(res.accessToken, res.refreshToken);
    return res;
  }

  @override
  Future<GoogleLoginModel> getSignInGoogleAccount() async {
    final gUser = await _firebaseAuthSource.signInWithGoogle();

    if (gUser == null) {
      throw {"detail": "cancel"};
    }

    final googleLoginModel = GoogleLoginModel(
      email: gUser.email,
      username: gUser.displayName ?? gUser.email,
      avatar:
          gUser.photoUrl ??
          "https://api.dicebear.com/9.x/initials/png?seed=${gUser.email}&backgroundType=gradientLinear",
      providerId: gUser.id,
    );

    return googleLoginModel;
  }

  @override
  Future<AuthResponse> loginGoogle(GoogleLogin googleLoginEntity) async {
    final googleLoginModel = GoogleLoginModel(
      email: googleLoginEntity.email,
      username: googleLoginEntity.username,
      avatar: googleLoginEntity.avatar,
      providerId: googleLoginEntity.providerId,
    );
    final res = await _apiAuthSource.loginByGoogle(googleLoginModel);
    _localAuthSource.saveToken(res.accessToken, res.refreshToken);
    return res;
  }

  @override
  Future<AuthResponse> refreshToken(RefreshToken refreshTokenEntity) async {
    final refreshTokenModel = RefreshTokenModel(
      refreshToken: refreshTokenEntity.refreshToken,
    );
    return _apiAuthSource.refreshToken(refreshTokenModel);
  }

  @override
  Future<ObjectResponse<User>> signUp(SignUp signUpEntity) async {
    final signUpModel = SignUpModel(
      email: signUpEntity.email,
      password: signUpEntity.password,
      name: signUpEntity.name,
    );
    final response = await _apiAuthSource.signUp(signUpModel);
    if (response.result != null) {
      _currentUserController.add(response.result);
      _localAuthSource.cachedUser(response.result!);
    }
    return response;
  }

  @override
  Future<ObjectResponse<User>> reLogin() async {
    final token = await _localAuthSource.getToken();
    final refreshToken = await _localAuthSource.getRefreshToken();
    try {
      return await _apiAuthSource.getCurrentUser("Bearer $token");
    } catch (e) {
      final refreshRes = await _apiAuthSource.refreshToken(
        RefreshTokenModel(refreshToken: refreshToken!),
      );
      return await _apiAuthSource.getCurrentUser(
        "Bearer ${refreshRes.accessToken}",
      );
    }
  }
}
