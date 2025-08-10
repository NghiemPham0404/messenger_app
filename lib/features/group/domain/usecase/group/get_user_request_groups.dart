import 'package:pulse_chat/core/responses/list_response.dart';
import 'package:pulse_chat/features/group/domain/entities/group.dart';
import 'package:pulse_chat/features/group/domain/repositories/group_repository.dart';

class ListUserRequestGroup {
  final GroupRepository _groupRepository;

  ListUserRequestGroup({required GroupRepository groupRepository})
    : _groupRepository = groupRepository;

  Future<ListResponse<Group>> call({int page = 1}) {
    return _groupRepository.getUserGroups(page: page, status: 2);
  }
}
