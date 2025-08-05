import 'package:pulse_chat/features/auth/domain/entities/login_google.dart';
import 'package:pulse_chat/features/auth/domain/repositories/auth_repository.dart';

class GetSigninGoogle {
  final AuthRepository _authRepository;

  GetSigninGoogle(this._authRepository);

  Future<GoogleLogin> call() async {
    return await _authRepository.getSignInGoogleAccount();
  }
}
