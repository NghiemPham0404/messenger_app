import '../entities/user.dart';
import 'package:pulse_chat/core/network/responses/object_response.dart';
import '../repositories/auth_repository.dart';

class ReloginCurrentUser {
  final AuthRepository _authRepo;

  ReloginCurrentUser(this._authRepo);

  Future<ObjectResponse<User>> call() async {
    return _authRepo.reLogin();
  }
}
