import '../repositories/auth_repository.dart';
import '../entities/login.dart';
import '../entities/auth_res.dart';

class LoginByEmail {
  final AuthRepository _authRepository;

  LoginByEmail(this._authRepository);

  Future<AuthResponse> call(Login loginEntity) async {
    return await _authRepository.login(loginEntity);
  }
}
