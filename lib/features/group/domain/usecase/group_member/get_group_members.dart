import 'package:pulse_chat/core/responses/list_response.dart';
import 'package:pulse_chat/features/group/domain/entities/group_member.dart';
import 'package:pulse_chat/features/group/domain/repositories/group_member_repository.dart';

class GetGroupMembers {
  final GroupMemberRepository _groupMemberRepo;

  GetGroupMembers(GroupMemberRepository groupMemberRepo)
    : _groupMemberRepo = groupMemberRepo;

  Future<ListResponse<GroupMember>> call(int groupId, {int page = 1}) {
    return _groupMemberRepo.getGroupMembers(
      groupId: groupId,
      status: 1,
      page: page,
    );
  }
}

class GetGroupInvitedUsers {
  final GroupMemberRepository _groupMemberRepo;

  GetGroupInvitedUsers(GroupMemberRepository groupMemberRepo)
    : _groupMemberRepo = groupMemberRepo;

  Future<ListResponse<GroupMember>> call(int groupId, {int page = 1}) {
    return _groupMemberRepo.getGroupMembers(
      groupId: groupId,
      status: 0,
      page: page,
    );
  }
}

class GetGroupRequestToJoinUsers {
  final GroupMemberRepository _groupMemberRepo;

  GetGroupRequestToJoinUsers(GroupMemberRepository groupMemberRepo)
    : _groupMemberRepo = groupMemberRepo;

  Future<ListResponse<GroupMember>> call(int groupId, {int page = 1}) {
    return _groupMemberRepo.getGroupMembers(
      groupId: groupId,
      status: 2,
      page: page,
    );
  }
}
