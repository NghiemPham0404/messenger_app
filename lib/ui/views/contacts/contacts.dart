import 'package:chatting_app/data/models/contact.dart';
import 'package:chatting_app/ui/view_models/contact_view_model.dart';
import 'package:chatting_app/ui/view_models/group_view_model.dart';
import 'package:chatting_app/ui/widgets/contact/contact_item.dart';
import 'package:chatting_app/ui/widgets/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactsTab extends StatelessWidget {
  const ContactsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: const ContactsPage()));
  }
}

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return ContactsPageState();
  }
}

class ContactsPageState extends State<ContactsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late Map<String, List<Contact>> friendListAlphaBetGroup;
  List<String> sortedKeys = [];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ContactViewModel, GroupViewModel>(
      builder:
          (context, contactVM, groupVM, child) => CupertinoPageScaffold(
            child: SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: _getHeader(),
                  bottom: TabBar(
                    indicatorColor: Theme.of(context).primaryColor,
                    labelColor: Theme.of(context).primaryColor,
                    controller: _tabController,
                    tabs: [
                      Tab(text: "Contacts"),
                      Tab(text: "Sent"),
                      Tab(text: "Groups"),
                    ],
                  ),
                ),
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    _contactPage(context, contactVM),
                    _sentRequestPage(context, contactVM),
                    _groupPage(context, groupVM),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Widget _getHeader() {
    return SearchAppBar();
  }

  Map<String, List<Contact>> groupByAlphabet(List<Contact> friends) {
    final Map<String, List<Contact>> grouped = {};

    for (var friend in friends) {
      final firstLetter = friend.otherUser.name[0].toUpperCase();

      if (!grouped.containsKey(firstLetter)) {
        grouped[firstLetter] = [];
      }

      grouped[firstLetter]!.add(friend);
    }

    for (var key in grouped.keys) {
      grouped[key]!.sort(
        (a, b) => a.otherUser.name.compareTo(b.otherUser.name),
      );
    }

    return grouped;
  }

  Widget _contactPage(BuildContext context, ContactViewModel viewModel) {
    return viewModel.isLoading
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                _getPendingList(context, viewModel),
                _getFriendList(context, viewModel),
              ],
            ),
          ),
        );
  }

  Widget _sentRequestPage(BuildContext context, ContactViewModel viewModel) {
    if (viewModel.isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    } else {
      final sentRequestList = viewModel.sentRequestList?.results ?? [];
      return Scaffold(
        body: ListView.builder(
          itemCount: sentRequestList.length,
          itemBuilder:
              (context, index) => SentRequestItem(
                contact: sentRequestList[index],
                cancel: (id) => viewModel.cancelRequest(id),
              ),
        ),
      );
    }
  }

  Widget _groupPage(BuildContext context, GroupViewModel viewModel) {
    if (viewModel.isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    } else {
      final groups = viewModel.groupList?.results ?? [];
      return Scaffold(
        body: ListView.builder(
          itemCount: groups.length,
          itemBuilder: (context, index) => GroupItem(group: groups[index]),
        ),
      );
    }
  }

  Widget _getPendingList(BuildContext context, ContactViewModel viewModel) {
    final pendingList = viewModel.pendingList?.results ?? [];
    return pendingList.length == 0
        ? SizedBox.shrink()
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Pending Requests (${pendingList.length})",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: pendingList.length,
              itemBuilder:
                  (context, index) => PendingRequestItem(
                    key: Key('${pendingList[index].id}'),
                    contact: pendingList[index],
                    accept: (id) => viewModel.acceptRequest(id),
                    dismiss: (id) => viewModel.dismissRequest(id),
                  ),
            ),
            Divider(thickness: 1, color: Theme.of(context).dividerColor),
          ],
        );
  }

  Widget _getFriendList(BuildContext context, ContactViewModel viewModel) {
    final friendList = viewModel.friendList?.results ?? [];
    friendListAlphaBetGroup = groupByAlphabet(friendList);
    generateSortedKey();

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "All (${friendList.length})",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  sortedKeys.length,
                  (i) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(sortedKeys[i]),
                      ),
                      Column(
                        children: List.generate(
                          friendListAlphaBetGroup[sortedKeys[i]]!.length,
                          (index) => FriendItem(
                            contact:
                                friendListAlphaBetGroup[sortedKeys[i]]![index],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void generateSortedKey() {
    sortedKeys = friendListAlphaBetGroup.keys.map((k) => k.toString()).toList();
    sortedKeys.sort((a, b) => a.compareTo(b));
  }
}
