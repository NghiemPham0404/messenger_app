import '../entities/login_google.dart';
import '../entities/auth_res.dart';
import '../repositories/auth_repository.dart';

class LoginByGoogle {
  final AuthRepository _authRepository;

  LoginByGoogle(this._authRepository);

  Future<AuthResponse> call(GoogleLogin googleLoginEntity) async {
    return await _authRepository.loginGoogle(googleLoginEntity);
  }
}
