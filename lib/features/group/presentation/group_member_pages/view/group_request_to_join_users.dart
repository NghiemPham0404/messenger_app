import 'package:pulse_chat/features/group/presentation/group_member_pages/notifier/group_request_to_join_users.dart';
import 'package:pulse_chat/features/group/presentation/group_pages/notifier/group_detail_notifier.dart';
import 'package:pulse_chat/features/group/presentation/components/group_member_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupRequestToJoinUsersPage extends StatefulWidget {
  const GroupRequestToJoinUsersPage({super.key});

  @override
  State<StatefulWidget> createState() => GroupRequestToJoinUsersPageState();
}

class GroupRequestToJoinUsersPageState
    extends State<GroupRequestToJoinUsersPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final GroupRequestToJoinUsersNotifier groupMemberVM =
          context.read<GroupRequestToJoinUsersNotifier>();
      final GroupDetailNotifier groupDetailVM =
          context.read<GroupDetailNotifier>();
      final groupId = groupDetailVM.group.id;
      groupMemberVM.getGroupWaitingRequests(groupId, 1);
    });
  }

  @override
  Widget build(Object context) {
    return Consumer2<GroupDetailNotifier, GroupRequestToJoinUsersNotifier>(
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
    GroupRequestToJoinUsersNotifier groupMemberVM,
  ) {
    return groupMemberVM.loadingWaitingRequest
        ? Center(child: CircularProgressIndicator())
        : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(padding: const EdgeInsets.all(8.0), child: Text("All ")),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: List.generate(groupMemberVM.groupWaitings.length, (
                  index,
                ) {
                  final groupMember = groupMemberVM.groupWaitings[index];

                  return GroupSentRequestItem(
                    groupMember,
                    () => groupMemberVM.declineRequest(
                      groupMember.groupId,
                      groupMember.id,
                    ),
                  );
                }),
              ),
            ),
            if (groupMemberVM.waitingRequestHasNext)
              TextButton(
                onPressed:
                    () => groupMemberVM.getGroupWaitingRequestsNext(
                      groupDetailVM.group.id,
                    ),
                child: Text("Load more"),
              ),
          ],
        );
  }
}
