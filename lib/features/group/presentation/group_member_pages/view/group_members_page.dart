import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:pulse_chat/features/group/presentation/group_member_pages/notifier/group_members_notifier.dart';
import 'package:pulse_chat/features/group/presentation/group_member_pages/view/group_invited_users_page.dart';
import 'package:pulse_chat/features/group/presentation/group_member_pages/view/group_request_to_join_users.dart';
import 'package:pulse_chat/features/group/presentation/group_pages/notifier/group_detail_notifier.dart';
import 'package:pulse_chat/features/group/presentation/group_member_pages/view/group_member_adding_screen.dart';
import 'package:pulse_chat/features/group/presentation/components/group_member_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupMembersPage extends StatefulWidget {
  const GroupMembersPage({super.key});

  @override
  State<StatefulWidget> createState() => GroupMembersPageState();
}

class GroupMembersPageState extends State<GroupMembersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late int yourId = -1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final localAuthSource = context.read<LocalAuthSource>();
      final currentUser = localAuthSource.getCachedUser();
      if (currentUser != null) {
        yourId = currentUser.id;
      }
      final GroupDetailNotifier groupDetailVM =
          context.read<GroupDetailNotifier>();
      final GroupMembersNotifier groupMemberVM =
          context.read<GroupMembersNotifier>();
      groupMemberVM.getGroupMembers(groupDetailVM.group.id, 1);
    });
  }

  @override
  Widget build(Object context) {
    return Consumer2<GroupDetailNotifier, GroupMembersNotifier>(
      builder: (context, groupDetailVM, groupMemberVM, child) {
        bool adminOrSubAdmin =
            groupDetailVM.groupMemberStatus.isHost ||
            groupDetailVM.groupMemberStatus.isSubHost;

        return CupertinoPageScaffold(
          child: SafeArea(
            child:
                adminOrSubAdmin
                    ? Scaffold(
                      appBar: AppBar(
                        title: _getHeader(
                          groupDetailVM.group.id,
                          isAdminOrSubAdmin: adminOrSubAdmin,
                        ),
                        bottom: TabBar(
                          indicatorColor: Theme.of(context).primaryColor,
                          labelColor: Theme.of(context).primaryColor,
                          controller: _tabController,
                          tabs: [
                            Tab(text: "All"),
                            Tab(text: "Sent"),
                            Tab(text: "Waiting"),
                          ],
                        ),
                      ),
                      body: TabBarView(
                        controller: _tabController,
                        children: [
                          _groupMemberPage(
                            context,
                            groupDetailVM,
                            groupMemberVM,
                            isAdminOrSubAdmin: adminOrSubAdmin,
                          ),
                          GroupInvitedUsersPage(),
                          GroupRequestToJoinUsersPage(),
                        ],
                      ),
                    )
                    : Scaffold(
                      appBar: AppBar(title: _getHeader(groupDetailVM.group.id)),
                      body: _groupMemberPage(
                        context,
                        groupDetailVM,
                        groupMemberVM,
                      ),
                    ),
          ),
        );
      },
    );
  }

  Widget _groupMemberPage(
    BuildContext context,
    GroupDetailNotifier groupDetailVM,
    GroupMembersNotifier groupMemberVM, {
    bool isAdminOrSubAdmin = false,
  }) {
    return groupMemberVM.loadingMembers
        ? Center(child: CircularProgressIndicator())
        : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("All (${groupDetailVM.group.membersCount ?? 0})"),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: List.generate(groupMemberVM.groupMembers.length, (
                  index,
                ) {
                  final isMe =
                      yourId == groupMemberVM.groupMembers[index].userId;
                  final groupMember = groupMemberVM.groupMembers[index];
                  return GroupMemberItem(
                    groupMember,
                    isAdminOrSubAdmin,
                    isMe: isMe,
                    grantSubHost:
                        isAdminOrSubAdmin
                            ? () => groupMemberVM.grantSubHost(
                              groupMember.groupId,
                              groupMember.id,
                            )
                            : null,
                    deleteMember:
                        isAdminOrSubAdmin
                            ? () => groupMemberVM.deleteGroupMember(
                              groupMember.groupId,
                              groupMember.id,
                            )
                            : null,
                  );
                }),
              ),
            ),
            if (groupMemberVM.memberHasNext)
              TextButton(
                onPressed:
                    () => groupMemberVM.getGroupMembersNext(
                      groupDetailVM.group.id,
                    ),
                child: Text("Load more"),
              ),
          ],
        );
  }

  Widget _getHeader(int groupId, {bool isAdminOrSubAdmin = false}) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        isAdminOrSubAdmin ? Text("Members management") : Text("Members"),
        if (isAdminOrSubAdmin)
          IconButton(
            onPressed: () => _navigateToAddingMemberScreen(groupId),
            icon: Icon(Icons.person_add_alt),
          ),
      ],
    );
  }

  void _navigateToAddingMemberScreen(int groupId) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => GroupMemberAddingScreen(groupId: groupId),
      ),
    );
  }
}
