import 'package:chatting_app/ui/view_models/group_detail_view_model.dart';
import 'package:chatting_app/ui/view_models/group_member_view_model.dart';
import 'package:chatting_app/ui/widgets/group_member/group_member_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupMemberScreen extends StatefulWidget {
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
      builder:
          (context, groupDetailVM, groupMemberVM, child) =>
              CupertinoPageScaffold(
                child: SafeArea(
                  child: Scaffold(
                    appBar: AppBar(
                      title: _getHeader(),
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
                        _groupMemberPage(context, groupDetailVM, groupMemberVM),
                        _sentRequestPage(context, groupDetailVM, groupMemberVM),
                        _pendingAcceptPage(
                          context,
                          groupDetailVM,
                          groupMemberVM,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }

  Widget _groupMemberPage(
    BuildContext context,
    GroupDetailViewModel groupDetailVM,
    GroupMemberViewModel groupMemberVM,
  ) {
    return Column(
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
            children: List.generate(groupMemberVM.groupMembers.length, (index) {
              final isMe =
                  groupMemberVM.userId ==
                  groupMemberVM.groupMembers[index].userId;
              return GroupMemberItem(
                groupMemberVM.groupMembers[index],
                isMe: isMe,
              );
            }),
          ),
        ),
        if (groupMemberVM.memberHasNext)
          TextButton(
            onPressed:
                () => groupMemberVM.getGroupMembersNext(groupDetailVM.group.id),
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
    return Column(
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
            children: List.generate(groupMemberVM.sentRequests.length, (index) {
              return GroupSentRequestItem(groupMemberVM.sentRequests[index]);
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
    return Column(
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
              return GroupWaitingReqestItem(groupMemberVM.groupWaitings[index]);
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

  Widget _getHeader() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [Text("Members management")],
    );
  }
}
