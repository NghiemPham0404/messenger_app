import 'package:pulse_chat/features/group/presentation/group_member_pages/notifier/group_inviting_users_notifier.dart';
import 'package:pulse_chat/features/group/presentation/group_pages/notifier/group_detail_notifier.dart';
import 'package:pulse_chat/features/group/presentation/components/group_member_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupInvitedUsersPage extends StatefulWidget {
  const GroupInvitedUsersPage({super.key});

  @override
  State<StatefulWidget> createState() => GroupInvitedUsersPageState();
}

class GroupInvitedUsersPageState extends State<GroupInvitedUsersPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final GroupDetailNotifier groupDetailVM =
          context.read<GroupDetailNotifier>();
      final GroupInvitingUsersNotifier groupMemberVM =
          context.read<GroupInvitingUsersNotifier>();
      groupMemberVM.getGroupSentRequests(groupDetailVM.group.id, 1);
    });
  }

  @override
  Widget build(Object context) {
    return Consumer2<GroupDetailNotifier, GroupInvitingUsersNotifier>(
      builder: (context, groupDetailVM, groupMemberVM, child) {
        return CupertinoPageScaffold(
          child: SafeArea(
            child: Scaffold(
              body: _buildBody(context, groupDetailVM, groupMemberVM),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    GroupDetailNotifier groupDetailVM,
    GroupInvitingUsersNotifier groupMemberVM,
  ) {
    return groupMemberVM.loadingSentRequest
        ? Center(child: CircularProgressIndicator())
        : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("All sent request"),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: List.generate(groupMemberVM.sentRequests.length, (
                  index,
                ) {
                  final groupMember = groupMemberVM.sentRequests[index];

                  return GroupSentRequestItem(
                    groupMember,
                    () => groupMemberVM.cancelSentRequest(
                      groupMember.groupId,
                      groupMember.id,
                    ),
                  );
                }),
              ),
            ),
            if (groupMemberVM.sentRequestHasNext)
              TextButton(
                onPressed:
                    () => groupMemberVM.getGroupSentRequestsNext(
                      groupDetailVM.group.id,
                    ),
                child: Text("Load more"),
              ),
          ],
        );
  }
}
