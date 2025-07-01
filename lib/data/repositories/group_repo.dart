import 'package:chatting_app/data/models/groups.dart';
import 'package:chatting_app/data/network/api_client.dart';
import 'package:chatting_app/data/responses/list_response.dart';

class GroupRepo {
  GroupRepo.internal();

  static final GroupRepo _instance = GroupRepo.internal();

  factory GroupRepo() => _instance;

  final ApiClient _apiClient = ApiClient();

  Future<ListResponse<Group>?> fetchGroups(
    String keyword, {
    int page = 1,
  }) async {
    return await _apiClient.groupApi.getGroups(keyword, page);
  }
}
