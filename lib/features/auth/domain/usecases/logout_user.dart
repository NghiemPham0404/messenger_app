import 'package:pulse_chat/features/auth/domain/repositories/auth_repository.dart';

class LogoutUser {
  final AuthRepository _authRepository;

  LogoutUser(this._authRepository);

  Future<void> call() async {
    return await _authRepository.logout();
  }
}
