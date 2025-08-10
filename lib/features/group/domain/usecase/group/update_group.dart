import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/group/domain/entities/group.dart';
import 'package:pulse_chat/features/group/domain/entities/group_update.dart';
import 'package:pulse_chat/features/group/domain/repositories/group_repository.dart';

class UpdateGroup {
  final GroupRepository _groupRepository;

  UpdateGroup({required GroupRepository groupRepository})
    : _groupRepository = groupRepository;

  Future<ObjectResponse<Group>> call(int groupId, GroupUpdate groupUpdate) {
    return _groupRepository.updateGroup(groupId, groupUpdate);
  }
}
