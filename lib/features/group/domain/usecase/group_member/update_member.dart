import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/group/domain/entities/group_member.dart';
import 'package:pulse_chat/features/group/domain/entities/group_member_update.dart';
import 'package:pulse_chat/features/group/domain/repositories/group_member_repository.dart';

class UpdateMember {
  final GroupMemberRepository _groupMemberRepository;

  UpdateMember({required GroupMemberRepository groupMemberRepository})
    : _groupMemberRepository = groupMemberRepository;

  Future<ObjectResponse<GroupMember>> call({
    required int groupId,
    required int groupMemberId,
    required GroupMemberUpdate groupMemberUpdate,
  }) {
    return _groupMemberRepository.updateGroupMember(
      groupId: groupId,
      groupMemberId: groupMemberId,
      groupMemberUpdate: groupMemberUpdate,
    );
  }
}
