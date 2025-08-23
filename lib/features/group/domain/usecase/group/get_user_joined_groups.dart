import 'package:pulse_chat/core/responses/list_response.dart';
import 'package:pulse_chat/features/group/domain/entities/group.dart';
import 'package:pulse_chat/features/group/domain/repositories/group_repository.dart';

class GetUserJoinedGroups {
  final GroupRepository _groupRepository;

  GetUserJoinedGroups({required GroupRepository groupRepository})
    : _groupRepository = groupRepository;

  Future<ListResponse<Group>> call({int page = 1}) {
    return _groupRepository.getUserGroups(page: page, status: 1);
  }
}
