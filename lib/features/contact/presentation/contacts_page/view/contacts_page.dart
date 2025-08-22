import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:pulse_chat/features/contact/domain/entities/contact.dart';
import 'package:pulse_chat/features/contact/presentation/contacts_page/change_notifier/contacts_notifier.dart';
import 'package:pulse_chat/features/contact/presentation/sent_requests_page/view/sent_requests_page.dart';
import 'package:pulse_chat/features/conversation/di/chat_provider.dart';
import 'package:pulse_chat/features/conversation/presentation/pages/chat_page/change_notifier/chat_header_notifier.dart';
import 'package:pulse_chat/features/conversation/presentation/pages/chat_page/view/chat_page.dart';
import 'package:pulse_chat/features/group/presentation/group_pages/notifier/user_groups_notifier.dart';
import 'package:pulse_chat/features/contact/presentation/components/contact_item.dart';
import 'package:pulse_chat/features/group/presentation/group_pages/view/user_group_page.dart';
import 'package:pulse_chat/features/search/presentation/components/search_bar.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final contactsNotifier = Provider.of<ContactsNotifier>(
        context,
        listen: false,
      );
      contactsNotifier.getFriendList();
      contactsNotifier.getPendingRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ContactsNotifier, UserGroupsNotifier>(
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
                    SentRequestsPage(),
                    UserGroupsPage(),
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

  Widget _contactPage(BuildContext context, ContactsNotifier viewModel) {
    return viewModel.isLoading
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : RefreshIndicator(
          onRefresh: () async {
            await viewModel.getFriendList();
            await viewModel.getPendingRequests();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              _getPendingList(context, viewModel),
              _getFriendList(context, viewModel),
            ],
          ),
        );
  }

  Widget _getPendingList(BuildContext context, ContactsNotifier viewModel) {
    final pendingList = viewModel.pendingList?.results ?? [];
    return pendingList.isEmpty
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
            Column(
              children: List.generate(
                pendingList.length,
                (index) => PendingRequestItem(
                  key: Key('${pendingList[index].id}'),
                  contact: pendingList[index],
                  accept: (id) => viewModel.acceptRequest(id),
                  dismiss: (id) => viewModel.dismissRequest(id),
                ),
              ),
            ),
            Divider(thickness: 1, color: Theme.of(context).dividerColor),
          ],
        );
  }

  Widget _getFriendList(BuildContext context, ContactsNotifier viewModel) {
    final friendList = viewModel.friendList?.results ?? [];
    friendListAlphaBetGroup = groupByAlphabet(friendList);
    generateSortedKey();

    return Column(
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
        Column(
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
                      onTap:
                          () => _navigateToChatPage(
                            friendListAlphaBetGroup[sortedKeys[i]]![index],
                          ),
                      contact: friendListAlphaBetGroup[sortedKeys[i]]![index],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void generateSortedKey() {
    sortedKeys = friendListAlphaBetGroup.keys.map((k) => k.toString()).toList();
    sortedKeys.sort((a, b) => a.compareTo(b));
  }

  void _navigateToChatPage(Contact contact) {
    final localAuthSource = context.read<LocalAuthSource>();
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        builder:
            (context) => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create:
                      (context) => ChatHeaderNotifier(
                        otherId: contact.otherUser.id,
                        dislayName: contact.otherUser.name,
                        displayAvatar: contact.otherUser.avatar,
                      ),
                ),
                ...getChatDirectProviders(
                  localAuthSource.getCachedUser()!.id,
                  contact.otherUser.id,
                ),
              ],
              child: const ChatPage(),
            ),
      ),
    );
  }
}
