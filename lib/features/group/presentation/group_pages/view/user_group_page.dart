import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_chat/features/group/presentation/components/group_item.dart';
import 'package:pulse_chat/features/group/presentation/group_pages/notifier/user_groups_notifier.dart';

class UserGroupsPage extends StatefulWidget {
  const UserGroupsPage({super.key});

  @override
  State<StatefulWidget> createState() => UserGroupsPageState();
}

class UserGroupsPageState extends State<UserGroupsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userGroupVM = Provider.of<UserGroupsNotifier>(
        context,
        listen: false,
      );
      userGroupVM.getUserGroups(1);
      userGroupVM.getUserJoiningGroupInvites(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserGroupsNotifier>(
      builder:
          (context, userGroupVM, child) => _groupPage(context, userGroupVM),
    );
  }

  Widget _groupPage(BuildContext context, UserGroupsNotifier viewModel) {
    return Scaffold(
      body:
          viewModel.isLoading
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: () async {
                  // Reload both sections
                  viewModel.getUserGroups(1);
                  viewModel.getUserJoiningGroupInvites(1);
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    if (viewModel.joiningInvites.isNotEmpty)
                      _getJoinInvites(viewModel),
                    if (viewModel.userGroups.isNotEmpty)
                      _getJoinedGroup(viewModel),
                  ],
                ),
              ),
    );
  }

  Widget _getJoinedGroup(UserGroupsNotifier viewModel) {
    final groups = viewModel.userGroups;
    final totalGroups = viewModel.totalUserGroup;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "All ($totalGroups)",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Column(
          children: List.generate(
            groups.length,
            (index) => GroupItem(group: groups[index]),
          ),
        ),
        if (viewModel.userGroupHasNext)
          ListTile(
            title: Text("load more"),
            onTap: () => viewModel.getUserGroupNext(),
          ),
      ],
    );
  }

  Widget _getJoinInvites(UserGroupsNotifier viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "All Invites (${viewModel.totalInvites})",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Column(
          children: List.generate(viewModel.joiningInvites.length, (index) {
            final group = viewModel.joiningInvites[index];
            final memberStatus = viewModel.memberStatusMap[group.id];
            return GroupJoinningInviteItem(
              group: group,
              acceptInvite:
                  () => viewModel.acceptRequest(
                    group.id,
                    memberStatus!.groupMemberId!,
                  ),
            );
          }),
        ),
        if (viewModel.joiningInviteHasNext)
          ListTile(
            title: Text("load more"),
            onTap: () => viewModel.getUserJoinningGroupInvitesNext(),
          ),
        Divider(thickness: 1, color: Theme.of(context).dividerColor),
      ],
    );
  }
}
