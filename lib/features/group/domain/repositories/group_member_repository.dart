import 'package:pulse_chat/core/responses/list_response.dart';
import 'package:pulse_chat/core/responses/message_response.dart';
import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/group/domain/entities/group_member.dart';
import 'package:pulse_chat/features/group/domain/entities/group_member_check.dart';
import 'package:pulse_chat/features/group/domain/entities/group_member_create.dart';
import 'package:pulse_chat/features/group/domain/entities/group_member_update.dart';

abstract class GroupMemberRepository {
  Future<ObjectResponse<GroupMember>> addGroupMember(
    int groupId,
    GroupMemberCreate groupMemberCreate,
  );

  Future<ObjectResponse<GroupMember>> updateGroupMember({
    required int groupId,
    required int groupMemberId,
    required GroupMemberUpdate groupMemberUpdate,
  });

  Future<ListResponse<GroupMemberCheck>> checkGroupMember(
    int groupId,
    List<int> userIds,
  );

  Future<ListResponse<GroupMember>> getGroupMembers({
    required int groupId,
    required int status,
    int page = 1,
  });

  Future<MessageResponse> deleteGroupMember({
    required int groupId,
    required int groupMemberId,
  });
}
