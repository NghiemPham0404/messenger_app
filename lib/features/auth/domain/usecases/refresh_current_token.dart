import '../entities/auth_res.dart';
import '../entities/refresh_token.dart';
import '../repositories/auth_repository.dart';

class RefreshCurrentToken {
  final AuthRepository _authRepository;

  RefreshCurrentToken(this._authRepository);

  Future<AuthResponse> call(RefreshToken refreshTokenEntity) async {
    return await _authRepository.refreshToken(refreshTokenEntity);
  }
}
