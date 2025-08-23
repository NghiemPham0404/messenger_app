import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/group/domain/entities/group.dart';
import 'package:pulse_chat/features/group/domain/entities/group_create.dart';
import 'package:pulse_chat/features/group/domain/repositories/group_repository.dart';

class CreateGroup {
  final GroupRepository _groupRepository;

  CreateGroup({required GroupRepository groupRepository})
    : _groupRepository = groupRepository;

  Future<ObjectResponse<Group>> call(GroupCreate groupCreate) {
    return _groupRepository.createGroup(groupCreate);
  }
}
