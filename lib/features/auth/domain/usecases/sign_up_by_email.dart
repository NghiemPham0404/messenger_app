import 'package:pulse_chat/core/responses/object_response.dart';

import '../entities/signup.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUpByEmail {
  final AuthRepository _authRepository;

  SignUpByEmail(this._authRepository);

  Future<ObjectResponse<User>> call(SignUp signUpEntity) async {
    return await _authRepository.signUp(signUpEntity);
  }
}
