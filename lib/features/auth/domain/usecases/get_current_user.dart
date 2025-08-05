import 'package:pulse_chat/core/network/responses/object_response.dart';
import 'package:pulse_chat/features/auth/domain/repositories/auth_repository.dart';

import '../entities/user.dart';

class GetCurrentUser {
  final AuthRepository _authRepository;

  GetCurrentUser(this._authRepository);

  Future<ObjectResponse<User>> call() async {
    return _authRepository.getCurrentUser();
  }
}
