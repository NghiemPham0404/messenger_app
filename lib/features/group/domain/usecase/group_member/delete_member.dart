import 'package:pulse_chat/core/responses/message_response.dart';
import 'package:pulse_chat/features/group/domain/repositories/group_member_repository.dart';

class DeleteMember {
  final GroupMemberRepository _groupMemberRepository;

  DeleteMember({required GroupMemberRepository groupMemberRepository})
    : _groupMemberRepository = groupMemberRepository;

  Future<MessageResponse> call(int groupId, int groupMemberId) async {
    return _groupMemberRepository.deleteGroupMember(
      groupId: groupId,
      groupMemberId: groupMemberId,
    );
  }
}
