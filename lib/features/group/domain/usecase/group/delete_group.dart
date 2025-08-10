import 'package:pulse_chat/core/responses/message_response.dart';
import 'package:pulse_chat/features/group/domain/repositories/group_repository.dart';

class DeleteGroup {
  final GroupRepository _groupRepository;

  DeleteGroup({required GroupRepository groupRepository})
    : _groupRepository = groupRepository;

  Future<MessageResponse> call(int groupId) {
    return _groupRepository.deleteGroup(groupId);
  }
}
