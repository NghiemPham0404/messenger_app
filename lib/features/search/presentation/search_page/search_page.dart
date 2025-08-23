import 'package:pulse_chat/features/contact/presentation/contacts_page/change_notifier/contacts_notifier.dart';
import 'package:pulse_chat/features/search/presentation/search_page/change_notifier/search_notifier.dart';
import 'package:pulse_chat/features/search/presentation/components/search_group_item.dart';
import 'package:pulse_chat/features/search/presentation/components/search_user_item.dart';
import 'package:pulse_chat/features/search/presentation/components/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return SearchPageState();
  }
}

class SearchPageState extends State<SearchPage> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer2<SearchNotifier, ContactsNotifier>(
      builder: (context, searchViewModel, contactViewModel, child) {
        return CupertinoPageScaffold(
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: SearchingBar(onTap: (q) => search(q, searchViewModel)),
              ),
              body: _builderBody(context, searchViewModel, contactViewModel),
            ),
          ),
        );
      },
    );
  }

  Widget _builderBody(
    BuildContext context,
    SearchNotifier viewModel,
    ContactsNotifier contactViewModel,
  ) {
    if (viewModel.cachedQuery.isEmpty) {
      return SizedBox.shrink();
    }

    if (viewModel.isLoading &&
        viewModel.users.isEmpty &&
        viewModel.groups.isEmpty) {
      return loadingScreen(context);
    }

    if (viewModel.errorMessage != null) {
      return errorPage(context, viewModel);
    }

    if (viewModel.users.isEmpty && viewModel.groups.isEmpty) {
      return notFoundScreen(context);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                viewModel.users.isNotEmpty
                    ? getFetchUsers(context, viewModel, contactViewModel)
                    : SizedBox.shrink(),
                viewModel.groups.isNotEmpty
                    ? getFetchGroups(context, viewModel)
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getFetchUsers(
    BuildContext context,
    SearchNotifier searchViewModel,
    ContactsNotifier contactViewModel,
  ) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Users (${searchViewModel.usersTotal})"),
          ),
          Column(
            children: List.generate(searchViewModel.users.length, (index) {
              final result = searchViewModel.users[index];
              return SearchUserItem(
                result: result,
                sendRequest:
                    (userId) =>
                        sendRequest(userId, searchViewModel, contactViewModel),
                acceptRequest:
                    (contactId) => acceptRequest(
                      contactId,
                      searchViewModel,
                      contactViewModel,
                    ),
                dismissRequest:
                    (contactId) => dismissRequest(
                      contactId,
                      searchViewModel,
                      contactViewModel,
                    ),
                key: Key('${result.id}'),
              );
            }),
          ),
          searchViewModel.usersMore
              ? TextButton(
                onPressed: () => searchViewModel.fetchUsersNext(),
                child: Text("Load more"),
              )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget getFetchGroups(BuildContext context, SearchNotifier searchViewModel) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Public Group(${searchViewModel.groupsTotal})"),
          ),
          Column(
            children: List.generate(searchViewModel.groups.length, (index) {
              final group = searchViewModel.groups[index];
              return SearchGroupItem(group: group);
            }),
          ),
          searchViewModel.groupsMore
              ? TextButton(
                onPressed: () => searchViewModel.fetchGroupsNext,
                child: Text("Load more"),
              )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget errorPage(BuildContext context, SearchNotifier searchViewModel) {
    return Center(child: Text(searchViewModel.errorMessage!));
  }

  Widget loadingScreen(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  Widget notFoundScreen(BuildContext context) {
    return const Padding(
      padding: EdgeInsetsGeometry.all(8.0),
      child: Expanded(
        child: Card(child: Center(child: Text("No results found"))),
      ),
    );
  }

  void search(String query, SearchNotifier searchViewModel) {
    if (query.length > 1) {
      searchViewModel.fetchUsers(query);
      searchViewModel.fetchGroups(query);
    }
  }

  void sendRequest(
    int userId,
    SearchNotifier searchViewModel,
    ContactsNotifier contactViewModel,
  ) {
    searchViewModel.sentRequest(userId);
  }

  void acceptRequest(
    int contactId,
    SearchNotifier searchViewModel,
    ContactsNotifier contactViewModel,
  ) async {
    final contact = await contactViewModel.acceptRequest(contactId);
    if (contact != null) {
      debugPrint("[contact accepted]");
      searchViewModel.acceptPendingRequest(contactId);
    }
  }

  void dismissRequest(
    int contactId,
    SearchNotifier searchViewModel,
    ContactsNotifier contactViewModel,
  ) async {
    if (await contactViewModel.dismissRequest(contactId) != -1) {
      debugPrint("[contact dismiss]");
      searchViewModel.dismissOrDeleteRequest(contactId);
    }
  }
}
