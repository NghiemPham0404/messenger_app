import 'package:pulse_chat/features/auth/domain/entities/user.dart';
import 'package:pulse_chat/features/auth/domain/repositories/auth_repository.dart';

class CachedLoginUser {
  final AuthRepository _authRepository;

  CachedLoginUser(this._authRepository);

  Future<void> call(User user) async {
    return _authRepository.cachedUser(user);
  }
}
