import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:pulse_chat/core/responses/list_response.dart';
import 'package:pulse_chat/core/responses/message_response.dart';
import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/group/data/model/group_create_model.dart';
import 'package:pulse_chat/features/group/data/model/group_update_model.dart';
import 'package:pulse_chat/features/group/data/source/network/group_service.dart';
import 'package:pulse_chat/features/group/domain/entities/group.dart';
import 'package:pulse_chat/features/group/domain/entities/group_create.dart';
import 'package:pulse_chat/features/group/domain/entities/group_update.dart';
import 'package:pulse_chat/features/group/domain/repositories/group_repository.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupService _groupApiService;
  final LocalAuthSource _localAuthSource;

  GroupRepositoryImpl({
    required GroupService groupApiService,
    required LocalAuthSource localAuthSource,
  }) : _groupApiService = groupApiService,
       _localAuthSource = localAuthSource;

  @override
  Future<ObjectResponse<Group>> createGroup(GroupCreate groupCreate) async {
    final groupCreateModel = GroupCreateModel(
      subject: groupCreate.subject,
      avatar: groupCreate.avatar,
    );
    return _groupApiService.createGroup(groupCreateModel);
  }

  @override
  Future<MessageResponse> deleteGroup(int groupId) {
    return _groupApiService.deleteGroup(groupId);
  }

  @override
  Future<ObjectResponse<Group>> getGroup(int groupId) {
    return _groupApiService.getGroup(groupId);
  }

  @override
  Future<ListResponse<Group>> getUserGroups({
    required int status,
    int page = 1,
  }) {
    final currentUser = _localAuthSource.getCachedUser();
    if (currentUser != null) {
      return _groupApiService.fetchUserGroup(currentUser.id, status, page);
    } else {
      throw {"detail": "Authentication"};
    }
  }

  @override
  Future<ListResponse<Group>> listGroup({String query = "", int page = 1}) {
    return _groupApiService.getGroups(query, page);
  }

  @override
  Future<ObjectResponse<Group>> updateGroup(
    int groupId,
    GroupUpdate groupUpdate,
  ) {
    GroupUpdateModel groupUpdateModel = GroupUpdateModel(
      subject: groupUpdate.subject,
      avatar: groupUpdate.avatar,
      isPublic: groupUpdate.isPublic,
      isMemberMute: groupUpdate.isMemberMute,
    );
    return _groupApiService.updateGroup(groupId, groupUpdateModel);
  }
}
