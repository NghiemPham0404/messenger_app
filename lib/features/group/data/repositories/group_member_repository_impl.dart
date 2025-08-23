import 'package:pulse_chat/core/responses/list_response.dart';
import 'package:pulse_chat/core/responses/message_response.dart';
import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/group/data/model/group_member_create_model.dart';
import 'package:pulse_chat/features/group/data/model/group_member_model.dart';
import 'package:pulse_chat/features/group/data/model/group_member_update_model.dart';
import 'package:pulse_chat/features/group/data/source/network/group_member_service.dart';
import 'package:pulse_chat/features/group/domain/entities/group_member.dart';
import 'package:pulse_chat/features/group/domain/entities/group_member_check.dart';
import 'package:pulse_chat/features/group/domain/entities/group_member_create.dart';
import 'package:pulse_chat/features/group/domain/entities/group_member_update.dart';
import 'package:pulse_chat/features/group/domain/repositories/group_member_repository.dart';

class GroupMemberRepositoryImpl implements GroupMemberRepository {
  final GroupMemberService _groupMemberService;

  GroupMemberRepositoryImpl({required GroupMemberService groupMemberService})
    : _groupMemberService = groupMemberService;

  @override
  Future<ObjectResponse<GroupMember>> addGroupMember(
    int groupId,
    GroupMemberCreate groupMemberCreate,
  ) async {
    final groupMemberCreateModel = GroupMemberCreateModel(
      groupId: groupMemberCreate.groupId,
      userId: groupMemberCreate.userId,
      status: groupMemberCreate.status,
      isHost: groupMemberCreate.isHost,
    );
    return _groupMemberService.createGroupMember(
      groupId,
      groupMemberCreateModel,
    );
  }

  @override
  Future<ListResponse<GroupMemberModel>> getGroupMembers({
    required int groupId,
    required int status,
    int page = 1,
  }) {
    return _groupMemberService.getGroupMember(groupId, status, page);
  }

  @override
  Future<ListResponse<GroupMemberCheck>> checkGroupMember(
    int groupId,
    List<int> userIds,
  ) async {
    return _groupMemberService.checkGroupMember(groupId, userIds);
  }

  @override
  Future<MessageResponse> deleteGroupMember({
    required int groupId,
    required int groupMemberId,
  }) async {
    return _groupMemberService.deleteGroupMember(groupId, groupMemberId);
  }

  @override
  Future<ObjectResponse<GroupMember>> updateGroupMember({
    required int groupId,
    required int groupMemberId,
    required GroupMemberUpdate groupMemberUpdate,
  }) async {
    final groupMemberUpdateModel = GroupMemberUpdateModel(
      status: groupMemberUpdate.status,
      isHost: groupMemberUpdate.isHost,
      isSubHost: groupMemberUpdate.isSubHost,
    );
    return _groupMemberService.updateGroupMember(
      groupId,
      groupMemberId,
      groupMemberUpdateModel,
    );
  }
}
