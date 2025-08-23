import 'package:pulse_chat/core/responses/list_response.dart';
import 'package:pulse_chat/core/responses/message_response.dart';
import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/group/domain/entities/group.dart';
import 'package:pulse_chat/features/group/domain/entities/group_create.dart';
import 'package:pulse_chat/features/group/domain/entities/group_update.dart';

abstract class GroupRepository {
  Future<ObjectResponse<Group>> createGroup(GroupCreate groupCreate);

  Future<ObjectResponse<Group>> getGroup(int groupId);

  Future<ListResponse<Group>> listGroup({String query = "", int page = 1});

  Future<ListResponse<Group>> getUserGroups({
    required int status,
    int page = 1,
  });

  Future<ObjectResponse<Group>> updateGroup(
    int groupId,
    GroupUpdate groupUpdate,
  );

  Future<MessageResponse> deleteGroup(int groupId);
}
