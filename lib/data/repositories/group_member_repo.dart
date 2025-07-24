import 'package:chatting_app/data/models/group_member.dart';
import 'package:chatting_app/data/network/api_client.dart';
import 'package:chatting_app/data/responses/list_response.dart';
import 'package:chatting_app/data/responses/message_response.dart';
import 'package:chatting_app/data/responses/object_response.dart';

class GroupMemberRepo {
  GroupMemberRepo.internal();

  static final GroupMemberRepo _instance = GroupMemberRepo.internal();

  factory GroupMemberRepo() => _instance;

  final ApiClient _apiClient = ApiClient();

  Future<ListResponse<GroupMember>> fetchGroupMember(
    int groupId,
    int status,
    int page,
  ) async {
    return _apiClient.groupMemberApi.getGroupMember(groupId, status, page);
  }

  Future<ObjectResponse<GroupMember>> createGroupMember(
    int groupId,
    GroupMemberCreate groupMemberCreate,
  ) async {
    return _apiClient.groupMemberApi.createGroupMember(
      groupId,
      groupMemberCreate,
    );
  }

  Future<ListResponse<GroupMemberCheck>> checkGroupMember(
    int groupId,
    List<int> userIds,
  ) async {
    return _apiClient.groupMemberApi.checkGroupMember(groupId, userIds);
  }

  Future<ObjectResponse<GroupMember>> updateGroupMember(
    int groupId,
    int groupMemberId,
    GroupMemberUpdate groupMemberUpdate,
  ) async {
    return _apiClient.groupMemberApi.updateGroupMember(
      groupId,
      groupMemberId,
      groupMemberUpdate,
    );
  }

  Future<MessageResponse> deleteGroupMember(
    int groupId,
    int groupMemberId,
  ) async {
    return _apiClient.groupMemberApi.deleteGroupMember(groupId, groupMemberId);
  }
}
