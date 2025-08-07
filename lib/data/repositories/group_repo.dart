import 'package:pulse_chat/data/models/group.dart';
import 'package:pulse_chat/data/network/api_client.dart';
import 'package:pulse_chat/core/responses/list_response.dart';
import 'package:pulse_chat/core/responses/message_response.dart';
import 'package:pulse_chat/core/responses/object_response.dart';

class GroupRepo {
  GroupRepo.internal();

  static final GroupRepo _instance = GroupRepo.internal();

  factory GroupRepo() => _instance;

  final ApiClient _apiClient = ApiClient();

  Future<ListResponse<Group>?> fetchGroups(
    String keyword, {
    int page = 1,
  }) async {
    return _apiClient.groupApi.getGroups(keyword, page);
  }

  Future<ObjectResponse<Group>> getGroupById(int id) async {
    return _apiClient.groupApi.getGroup(id);
  }

  Future<ObjectResponse<Group>> createGroup(GroupCreate groupCreate) async {
    return _apiClient.groupApi.createGroup(groupCreate);
  }

  Future<ObjectResponse<Group>> updateGroup(
    int id,
    GroupUpdate groupUpdate,
  ) async {
    return _apiClient.groupApi.updateGroup(id, groupUpdate);
  }

  Future<MessageResponse> deleteGroup(int id) async {
    return _apiClient.groupApi.deleteGroup(id);
  }
}
