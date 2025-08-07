import 'package:pulse_chat/core/responses/object_response.dart';

import '../entities/login.dart';
import '../entities/login_google.dart';
import '../entities/refresh_token.dart';
import '../entities/signup.dart';
import '../entities/auth_res.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<AuthResponse> login(Login login);
  Future<GoogleLogin> getSignInGoogleAccount();
  Future<AuthResponse> loginGoogle(GoogleLogin googleLogin);
  Future<ObjectResponse<User>> getCurrentUser();
  Future<void> cachedUser(User user);
  Future<ObjectResponse<User>> signUp(SignUp signUp);
  Future<ObjectResponse<User>> reLogin();
  Future<AuthResponse> refreshToken(RefreshToken refreshToken);
  Future<void> logout();
}
