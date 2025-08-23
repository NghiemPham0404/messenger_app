import 'package:pulse_chat/core/responses/list_response.dart';
import 'package:pulse_chat/features/user/domain/entities/user_extend.dart';
import 'package:pulse_chat/features/user/domain/repositories/user_repository.dart';

class SearchUsers {
  final UserRepository userRepository;

  SearchUsers(this.userRepository);

  Future<ListResponse<UserExtended>> call(
    String query, {
    required int page,
  }) async {
    return userRepository.fetchUsers(query, page: page);
  }
}
