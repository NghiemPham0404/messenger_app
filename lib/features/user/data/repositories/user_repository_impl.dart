import 'package:pulse_chat/core/responses/list_response.dart';
import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/user/data/source/network/user_service.dart';
import 'package:pulse_chat/features/user/domain/entities/user_extend.dart';
import 'package:pulse_chat/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserService _userService;

  UserRepositoryImpl({required UserService userService})
    : _userService = userService;

  @override
  Future<ListResponse<UserExtended>> fetchUsers(
    String query, {
    int page = 1,
  }) async {
    return _userService.getUsers(query, page);
  }

  @override
  Future<ObjectResponse<UserExtended>> getUserById(int id) {
    return _userService.getUser(id);
  }
}
