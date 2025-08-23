import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/user/domain/entities/user_extend.dart';
import 'package:pulse_chat/features/user/domain/repositories/user_repository.dart';

class GetUser {
  // DEPENDENCIES
  final UserRepository _userRepository;

  // CONSTRUCTOR
  GetUser({required UserRepository userRepository})
    : _userRepository = userRepository;

  // METHODS
  Future<ObjectResponse<UserExtended>> call(int id) async {
    return _userRepository.getUserById(id);
  }
}
