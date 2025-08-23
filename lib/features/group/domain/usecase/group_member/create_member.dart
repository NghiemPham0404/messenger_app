import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/group/domain/entities/group_member.dart';
import 'package:pulse_chat/features/group/domain/entities/group_member_create.dart';
import 'package:pulse_chat/features/group/domain/repositories/group_member_repository.dart';

class AddGroupHostMember {
  final GroupMemberRepository _groupMemberRepository;

  AddGroupHostMember({required GroupMemberRepository groupMemberRepository})
    : _groupMemberRepository = groupMemberRepository;

  Future<ObjectResponse<GroupMember>> call(int groupId, int userId) {
    final groupHostMember = GroupMemberCreate(
      groupId: groupId,
      userId: userId,
      isHost: true,
      status: 1,
    );
    return _groupMemberRepository.addGroupMember(groupId, groupHostMember);
  }
}

class InviteMember {
  final GroupMemberRepository _groupMemberRepository;

  InviteMember({required GroupMemberRepository groupMemberRepository})
    : _groupMemberRepository = groupMemberRepository;

  Future<ObjectResponse<GroupMember>> call({
    required int groupId,
    required int userId,
  }) {
    final invitedMember = GroupMemberCreate(
      groupId: groupId,
      userId: userId,
      isHost: false,
      status: 0,
    );
    return _groupMemberRepository.addGroupMember(groupId, invitedMember);
  }
}

class RequestToJoinGroup {
  final GroupMemberRepository _groupMemberRepository;

  RequestToJoinGroup({required GroupMemberRepository groupMemberRepository})
    : _groupMemberRepository = groupMemberRepository;

  Future<ObjectResponse<GroupMember>> call(int groupId, int userId) {
    final invitedMember = GroupMemberCreate(
      groupId: groupId,
      userId: userId,
      isHost: false,
      status: 2,
    );
    return _groupMemberRepository.addGroupMember(groupId, invitedMember);
  }
}
