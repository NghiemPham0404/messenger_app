import 'package:pulse_chat/core/responses/list_response.dart';
import 'package:pulse_chat/features/group/domain/entities/group_member_check.dart';
import 'package:pulse_chat/features/group/domain/repositories/group_member_repository.dart';

class CheckMemberStatus {
  final GroupMemberRepository _groupMemberRepository;

  CheckMemberStatus({required GroupMemberRepository groupMemberRepository})
    : _groupMemberRepository = groupMemberRepository;

  Future<ListResponse<GroupMemberCheck>> call(
    int groupId,
    List<int> userIds,
  ) async {
    return _groupMemberRepository.checkGroupMember(groupId, userIds);
  }
}
