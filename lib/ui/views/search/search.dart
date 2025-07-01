import 'package:chatting_app/ui/view_models/contact_view_model.dart';
import 'package:chatting_app/ui/view_models/search_view_model.dart';
import 'package:chatting_app/ui/widgets/avatar.dart';
import 'package:chatting_app/ui/widgets/search/search_user_item.dart';
import 'package:chatting_app/ui/widgets/search_bar.dart';
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

  late ContactViewModel contactViewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    contactViewModel = Provider.of<ContactViewModel>(context, listen: true);

    return Consumer<SearchViewModel>(
      builder: (context, viewModel, child) {
        return CupertinoPageScaffold(
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: SearchingBar(onTap: (q) => search(q, viewModel)),
              ),
              body: _builderBody(context, viewModel),
            ),
          ),
        );
      },
    );
  }

  Widget _builderBody(BuildContext context, SearchViewModel viewModel) {
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
                    ? getFetchUsers(context, viewModel)
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

  Widget getFetchUsers(BuildContext context, SearchViewModel searchViewModel) {
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
                sendRequest: (userId) => sendRequest(userId, searchViewModel),
                acceptRequest:
                    (contactId) => acceptRequest(contactId, searchViewModel),
                dismissRequest:
                    (contactId) => dismissRequest(contactId, searchViewModel),
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

  Widget getFetchGroups(BuildContext context, SearchViewModel searchViewModel) {
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
              final result = searchViewModel.groups[index];
              return ListTile(
                key: Key(result.id.toString()),
                leading: getAvatar(result.avatar, seed: result.subject),
                title: Text(result.subject ?? "Group"),
              );
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

  Widget errorPage(BuildContext context, SearchViewModel searchViewModel) {
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

  void search(String query, SearchViewModel searchViewModel) {
    if (query.length > 1) {
      searchViewModel.fetchUsers(query);
      searchViewModel.fetchGroups(query);
    }
  }

  void sendRequest(int userId, SearchViewModel searchViewModel) async {
    final contact = await contactViewModel.sendRequest(userId);
    if (contact != null) {
      debugPrint("[contact send success]");
      searchViewModel.sentRequest(contact);
    }
  }

  void acceptRequest(int contactId, SearchViewModel searchViewModel) async {
    final contact = await contactViewModel.acceptRequest(contactId);
    if (contact != null) {
      debugPrint("[contact accepted]");
      searchViewModel.acceptPendingRequest(contactId);
    }
  }

  void dismissRequest(int contactId, SearchViewModel searchViewModel) async {
    if (await contactViewModel.dismissRequest(contactId) != -1) {
      debugPrint("[contact dismiss]");
      searchViewModel.dismissOrDeleteRequest(contactId);
    }
  }
}
