import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:pulse_chat/core/network/api_client.dart';
import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:pulse_chat/features/group/data/repositories/group_repository_impl.dart';
import 'package:pulse_chat/features/group/data/source/network/group_service.dart';
import 'package:pulse_chat/features/group/domain/repositories/group_repository.dart';
import 'package:pulse_chat/features/group/domain/usecase/group/create_group.dart';
import 'package:pulse_chat/features/group/domain/usecase/group/delete_group.dart';
import 'package:pulse_chat/features/group/domain/usecase/group/get_group.dart';
import 'package:pulse_chat/features/group/domain/usecase/group/get_user_joined_groups.dart';
import 'package:pulse_chat/features/group/domain/usecase/group/get_user_invite_groups.dart';
import 'package:pulse_chat/features/group/domain/usecase/group/get_user_request_groups.dart';
import 'package:pulse_chat/features/group/domain/usecase/group/search_groups.dart';
import 'package:pulse_chat/features/group/domain/usecase/group/update_group.dart';
import 'package:pulse_chat/features/group/domain/usecase/group_member/accept_member.dart';
import 'package:pulse_chat/features/group/domain/usecase/group_member/check_member.dart';
import 'package:pulse_chat/features/group/domain/usecase/group_member/create_member.dart';
import 'package:pulse_chat/features/group/domain/usecase/group_member/delete_member.dart';
import 'package:pulse_chat/features/group/presentation/group_pages/notifier/group_create_notifier.dart';
import 'package:pulse_chat/features/group/presentation/group_pages/notifier/group_detail_notifier.dart';
import 'package:pulse_chat/features/group/presentation/group_pages/notifier/user_groups_notifier.dart';
import 'package:pulse_chat/features/media/domain/usecase/upload_image_file.dart';

List<SingleChildWidget> groupProviders = [
  // Service and Sources -----------------------------------------------------------------------
  Provider<GroupService>(
    create: (context) => context.read<ApiClient>().groupApi,
  ),

  // Repositories --------------------------------------------------------------------------------
  Provider<GroupRepository>(
    create:
        (context) => GroupRepositoryImpl(
          groupApiService: context.read<GroupService>(),
          localAuthSource: context.read<LocalAuthSource>(),
        ),
  ),

  // Usecase -------------------------------------------------------------------------------------
  Provider<CreateGroup>(
    create:
        (context) =>
            CreateGroup(groupRepository: context.read<GroupRepository>()),
  ),
  Provider<UpdateGroup>(
    create:
        (context) =>
            UpdateGroup(groupRepository: context.read<GroupRepository>()),
  ),
  Provider<DeleteGroup>(
    create:
        (context) =>
            DeleteGroup(groupRepository: context.read<GroupRepository>()),
  ),
  Provider<GetGroup>(
    create:
        (context) => GetGroup(groupRepository: context.read<GroupRepository>()),
  ),
  Provider<SearchGroups>(
    create:
        (context) =>
            SearchGroups(groupRepository: context.read<GroupRepository>()),
  ),
  Provider<GetUserJoinedGroups>(
    create:
        (context) => GetUserJoinedGroups(
          groupRepository: context.read<GroupRepository>(),
        ),
  ),
  Provider<GetUserInviteGroup>(
    create:
        (context) => GetUserInviteGroup(
          groupRepository: context.read<GroupRepository>(),
        ),
  ),
  Provider<ListUserRequestGroup>(
    create:
        (context) => ListUserRequestGroup(
          groupRepository: context.read<GroupRepository>(),
        ),
  ),

  // NOTIFIERS-----------------------------------------------------------------------------------
  ChangeNotifierProvider<GroupCreateNotifier>(
    create:
        (context) => GroupCreateNotifier(
          localAuthSource: context.read<LocalAuthSource>(),
          createGroup: context.read<CreateGroup>(),
          postImageToServer: context.read<UploadImageFile>(),
          createGroupMember: context.read<InviteMember>(),
          addGroupHostMember: context.read<AddGroupHostMember>(),
        ),
  ),
  ChangeNotifierProvider<GroupDetailNotifier>(
    create:
        (context) => GroupDetailNotifier(
          localAuthSource: context.read<LocalAuthSource>(),
          getGroup: context.read<GetGroup>(),
          checkMemberStatus: context.read<CheckMemberStatus>(),
          uploadImageFile: context.read<UploadImageFile>(),
          updateGroup: context.read<UpdateGroup>(),
          deleteGroup: context.read<DeleteGroup>(),
          requestToJoinGroup: context.read<RequestToJoinGroup>(),
          deleteMember: context.read<DeleteMember>(),
        ),
  ),
  ChangeNotifierProvider<UserGroupsNotifier>(
    create:
        (context) => UserGroupsNotifier(
          localAuthSource: context.read<LocalAuthSource>(),
          getUserJoinedGroups: context.read<GetUserJoinedGroups>(),
          getUserInviteGroup: context.read<GetUserInviteGroup>(),
          checkMemberStatus: context.read<CheckMemberStatus>(),
          acceptMember: context.read<AcceptMember>(),
        ),
  ),
];
