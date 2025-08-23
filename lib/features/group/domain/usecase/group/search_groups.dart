import 'package:pulse_chat/core/responses/list_response.dart';
import 'package:pulse_chat/features/group/domain/entities/group.dart';
import 'package:pulse_chat/features/group/domain/repositories/group_repository.dart';

class SearchGroups {
  final GroupRepository _groupRepository;

  SearchGroups({required GroupRepository groupRepository})
    : _groupRepository = groupRepository;

  Future<ListResponse<Group>> call({String query = "", int page = 1}) {
    return _groupRepository.listGroup(query: query, page: page);
  }
}
