import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:pulse_chat/core/network/api_client.dart';
import 'package:pulse_chat/features/contact/domain/usecase/get_contacts_list.dart';
import 'package:pulse_chat/features/group/data/repositories/group_member_repository_impl.dart';
import 'package:pulse_chat/features/group/data/source/network/group_member_service.dart';
import 'package:pulse_chat/features/group/domain/repositories/group_member_repository.dart';
import 'package:pulse_chat/features/group/domain/usecase/group_member/accept_member.dart';
import 'package:pulse_chat/features/group/domain/usecase/group_member/check_member.dart';
import 'package:pulse_chat/features/group/domain/usecase/group_member/create_member.dart';
import 'package:pulse_chat/features/group/domain/usecase/group_member/delete_member.dart';
import 'package:pulse_chat/features/group/domain/usecase/group_member/get_group_members.dart';
import 'package:pulse_chat/features/group/domain/usecase/group_member/update_member.dart';
import 'package:pulse_chat/features/group/presentation/group_member_pages/notifier/group_inviting_users_notifier.dart';
import 'package:pulse_chat/features/group/presentation/group_member_pages/notifier/group_members_notifier.dart';
import 'package:pulse_chat/features/group/presentation/group_member_pages/notifier/group_request_to_join_users.dart';

List<SingleChildWidget> groupMemberProviders = [
  //SERVICE AND SOURCE--------------------------------------------------------------------------
  Provider<GroupMemberService>(
    create: (context) => context.read<ApiClient>().groupMemberApi,
  ),
  //REPOSITORIES--------------------------------------------------------------------------
  Provider<GroupMemberRepository>(
    create:
        (context) => GroupMemberRepositoryImpl(
          groupMemberService: context.read<GroupMemberService>(),
        ),
  ),

  //USECASE--------------------------------------------------------------------------
  Provider<InviteMember>(
    create:
        (context) => InviteMember(
          groupMemberRepository: context.read<GroupMemberRepository>(),
        ),
  ),
  Provider<AddGroupHostMember>(
    create:
        (context) => AddGroupHostMember(
          groupMemberRepository: context.read<GroupMemberRepository>(),
        ),
  ),
  Provider<RequestToJoinGroup>(
    create:
        (context) => RequestToJoinGroup(
          groupMemberRepository: context.read<GroupMemberRepository>(),
        ),
  ),
  Provider<AcceptMember>(
    create:
        (context) => AcceptMember(
          groupMemberRepository: context.read<GroupMemberRepository>(),
        ),
  ),
  Provider<CheckMemberStatus>(
    create:
        (context) => CheckMemberStatus(
          groupMemberRepository: context.read<GroupMemberRepository>(),
        ),
  ),
  Provider<UpdateMember>(
    create:
        (context) => UpdateMember(
          groupMemberRepository: context.read<GroupMemberRepository>(),
        ),
  ),
  Provider<GetGroupMembers>(
    create: (context) => GetGroupMembers(context.read<GroupMemberRepository>()),
  ),
  Provider<GetGroupInvitedUsers>(
    create:
        (context) =>
            GetGroupInvitedUsers(context.read<GroupMemberRepository>()),
  ),
  Provider<GetGroupRequestToJoinUsers>(
    create:
        (context) =>
            GetGroupRequestToJoinUsers(context.read<GroupMemberRepository>()),
  ),
  Provider<DeleteMember>(
    create:
        (context) => DeleteMember(
          groupMemberRepository: context.read<GroupMemberRepository>(),
        ),
  ),

  // Notifiers -----------------------------------------------------------------------------------
  ChangeNotifierProvider<GroupMembersNotifier>(
    create:
        (context) => GroupMembersNotifier(
          getGroupMembers: context.read<GetGroupMembers>(),
          updateMember: context.read<UpdateMember>(),
          deleteMember: context.read<DeleteMember>(),
        ),
  ),
  ChangeNotifierProvider<GroupRequestToJoinUsersNotifier>(
    create:
        (context) => GroupRequestToJoinUsersNotifier(
          getRequestToJoinUsers: context.read<GetGroupRequestToJoinUsers>(),
          acceptMember: context.read<AcceptMember>(),
          deleteMember: context.read<DeleteMember>(),
        ),
  ),
  ChangeNotifierProvider<GroupInvitingUsersNotifier>(
    create:
        (context) => GroupInvitingUsersNotifier(
          getGroupInvitedUsers: context.read<GetGroupInvitedUsers>(),
          deleteMember: context.read<DeleteMember>(),
          getUsereContacts: context.read<GetUserContacts>(),
          inviteMember: context.read<InviteMember>(),
          checkMemberStatus: context.read<CheckMemberStatus>(),
        ),
  ),
];
