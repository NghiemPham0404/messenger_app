import 'package:pulse_chat/core/responses/list_response.dart';
import 'package:pulse_chat/features/user/domain/entities/user_extend.dart';

abstract class UserRepository {
  Future<ListResponse<UserExtended>> fetchUsers(String query, {int page = 1});
}
