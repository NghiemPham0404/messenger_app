import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/group/domain/entities/group_member.dart';
import 'package:pulse_chat/features/group/domain/entities/group_member_update.dart';
import 'package:pulse_chat/features/group/domain/repositories/group_member_repository.dart';

class AcceptMember {
  final GroupMemberRepository _groupMemberRepository;

  AcceptMember({required GroupMemberRepository groupMemberRepository})
    : _groupMemberRepository = groupMemberRepository;

  Future<ObjectResponse<GroupMember>> call(int groupId, int groupMemberId) {
    final groupMemberUpdate = GroupMemberUpdate(
      isHost: false,
      isSubHost: false,
      status: 1,
    );
    return _groupMemberRepository.updateGroupMember(
      groupId: groupId,
      groupMemberId: groupMemberId,
      groupMemberUpdate: groupMemberUpdate,
    );
  }
}
