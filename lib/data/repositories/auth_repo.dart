import 'dart:async';

import 'package:chatting_app/data/models/user.dart';
import 'package:chatting_app/data/network/api_client.dart';
import 'package:chatting_app/data/services/auth_service.dart';
import 'package:chatting_app/data/responses/auth_response.dart';
import 'package:chatting_app/data/responses/object_response.dart';
import 'package:chatting_app/util/web_socket_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/account.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, GoogleAuthProvider;

class AuthRepo {
  static final AuthApiClient _authApiClient = AuthApiClient();
  static final ApiClient _apiClient = ApiClient();
  static final AuthService _authService = _authApiClient.getAuthApi();

  AuthRepo.internal();

  static final AuthRepo _instance = AuthRepo.internal();

  factory AuthRepo() => _instance;

  final StreamController<User?> _userOutStream = StreamController.broadcast();

  User? _currentUser;

  Stream<User?> get currentUserStream => _userOutStream.stream;

  User? get currentUser => _currentUser;

  Future<AuthResponse?> login(LoginModel loginModel) async {
    return await _authService.login(loginModel);
  }

  void initAPIClient(String accessToken) {
    _apiClient.initialize(accessToken);
  }

  Future<User?> requestGetCurrentUser(String accessToken) async {
    // init api client once when user login successfully
    initAPIClient(accessToken);

    if (!_userOutStream.isClosed) {
      final user = await _authService.getCurrentUser('Bearer $accessToken');
      if (user != null) {
        _userOutStream.add(user.result!);
        _currentUser = user.result;

        final webSocketService = WebSocketService();
        webSocketService.connect(user.result!.id, accessToken);
      }
      return user!.result;
    }
    return null;
  }

  Future<ObjectResponse<User>> signUp(SignUpModel signUpBody) async {
    return await _authService.signUp(signUpBody);
  }

  void logOut() {
    _currentUser = null;
    _userOutStream.add(_currentUser);
    _apiClient.destroy();
  }

  /// GOOGLE SIGN IN PROPERTY
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// sign in with Google
  Future<AuthResponse?> signInWithGoogle() async {
    // begin interactive sign process (show popup dialog with google account selections)
    final GoogleSignInAccount? gUser = await _googleSignIn.signIn();

    if (gUser == null) {
      throw {"detail": "cancel"};
    }

    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    await _firebaseAuth.signInWithCredential(credential);

    GoogleLoginModel googleLoginModel = GoogleLoginModel(
      email: gUser.email,
      username: gUser.displayName ?? gUser.email,
      avatar:
          gUser.photoUrl ??
          "https://api.dicebear.com/9.x/initials/png?seed=${gUser.email}&backgroundType=gradientLinear",
      providerId: gUser.id,
    );

    return await _authService.loginByGoogle(googleLoginModel);
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
  }

  Future<AuthResponse?> refreshToken(String refreshToken) async {
    final refreshTokenBody = RefreshTokenModel(refreshToken: refreshToken);
    return await _authService.refreshToken(refreshTokenBody);
  }
}
