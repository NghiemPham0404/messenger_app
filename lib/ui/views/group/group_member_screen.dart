import 'package:chatting_app/ui/view_models/contact_view_model.dart';
import 'package:chatting_app/ui/view_models/group_detail_view_model.dart';
import 'package:chatting_app/ui/view_models/group_member_view_model.dart';
import 'package:chatting_app/ui/views/group/group_member_adding_screen.dart';
import 'package:chatting_app/ui/widgets/group_member/group_member_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupMemberScreen extends StatefulWidget {
  const GroupMemberScreen({super.key});

  @override
  State<StatefulWidget> createState() => GroupMemberScreenState();
}

class GroupMemberScreenState extends State<GroupMemberScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(Object context) {
    return Consumer2<GroupDetailViewModel, GroupMemberViewModel>(
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
                          _sentRequestPage(
                            context,
                            groupDetailVM,
                            groupMemberVM,
                          ),
                          _pendingAcceptPage(
                            context,
                            groupDetailVM,
                            groupMemberVM,
                          ),
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
    GroupDetailViewModel groupDetailVM,
    GroupMemberViewModel groupMemberVM, {
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
                      groupMemberVM.userId ==
                      groupMemberVM.groupMembers[index].userId;
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

  Widget _sentRequestPage(
    BuildContext context,
    GroupDetailViewModel groupDetailVM,
    GroupMemberViewModel groupMemberVM,
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

  Widget _pendingAcceptPage(
    BuildContext context,
    GroupDetailViewModel groupDetailVM,
    GroupMemberViewModel groupMemberVM,
  ) {
    return groupMemberVM.loadingWaitingRequest
        ? Center(child: CircularProgressIndicator())
        : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("All pending accept requests"),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: List.generate(groupMemberVM.groupWaitings.length, (
                  index,
                ) {
                  final groupMember = groupMemberVM.groupWaitings[index];
                  return GroupWaitingReqestItem(
                    groupMember,
                    () => groupMemberVM.acceptRequest(
                      groupMember.groupId,
                      groupMember.id,
                    ),
                    () => groupMemberVM.declineRequest(
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
    final groupMemberVM = Provider.of<GroupMemberViewModel>(
      context,
      listen: false,
    );
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder:
            (context) => MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => ContactViewModel()),
                ChangeNotifierProvider.value(value: groupMemberVM),
              ],
              child: GroupMemberAddingScreen(groupId: groupId),
            ),
      ),
    );
  }
}
