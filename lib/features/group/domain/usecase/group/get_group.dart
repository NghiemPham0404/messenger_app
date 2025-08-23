import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/group/domain/entities/group.dart';
import 'package:pulse_chat/features/group/domain/repositories/group_repository.dart';

class GetGroup {
  final GroupRepository _groupRepository;

  GetGroup({required GroupRepository groupRepository})
    : _groupRepository = groupRepository;

  Future<ObjectResponse<Group>> call(int groupId) {
    return _groupRepository.getGroup(groupId);
  }
}
