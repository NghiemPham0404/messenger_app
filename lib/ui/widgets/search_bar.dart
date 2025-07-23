import 'package:chatting_app/ui/view_models/contact_view_model.dart';
import 'package:chatting_app/ui/view_models/group_view_model.dart';
import 'package:chatting_app/ui/view_models/search_view_model.dart';
import 'package:chatting_app/ui/views/search/search.dart';
import 'package:chatting_app/ui/views/group/group_create_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchAppBar extends StatelessWidget {
  const SearchAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(CupertinoIcons.search, color: Theme.of(context).primaryColor),
          SizedBox(width: 8),
          Expanded(
            child: CupertinoTextField(
              readOnly: true,
              placeholder: 'chat, person, groups...',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              onTap: () => _navigateToSearchView(context),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(
              CupertinoIcons.qrcode_viewfinder,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              // Handle QR scan
            },
          ),
          SizedBox(width: 8),
          PopupMenuButton<String>(
            onSelected: (value) => _onMenuSeleted(context, value),
            icon: Icon(
              CupertinoIcons.add_circled,
              color: Theme.of(context).primaryColor,
            ),
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'group_create',
                    child: Text('Add group'),
                  ),
                  PopupMenuItem(value: 'group_join', child: Text('Join group')),
                ],
          ),
        ],
      ),
    );
  }

  void _navigateToSearchView(BuildContext context) {
    final contactViewModel = Provider.of<ContactViewModel>(
      context,
      listen: false,
    );
    debugPrint("[Search APPBAR] Navigate to SEARCH");
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => SearchViewModel()),
                ChangeNotifierProvider.value(value: contactViewModel),
              ],
              child: const SearchPage(),
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(
          milliseconds: 300,
        ), // Customize as needed
      ),
    );
  }

  void _onMenuSeleted(BuildContext context, String value) {
    switch (value) {
      case "group_create":
        _navigateToGroupCreateView(context);
        break;
      case "group_join":
        break;
      default:
        break;
    }
  }

  void _navigateToGroupCreateView(BuildContext context) {
    final contactViewModel = Provider.of<ContactViewModel>(
      context,
      listen: false,
    );

    final groupViewModel = Provider.of<GroupViewModel>(context, listen: false);

    debugPrint("[Search APPBAR] Navigate to GROUP CREATE SCREEN");
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => SearchViewModel()),
                ChangeNotifierProvider.value(value: contactViewModel),
                ChangeNotifierProvider.value(value: groupViewModel),
              ],
              child: const GroupCreateScreen(),
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}

class SearchingBar extends StatefulWidget {
  final Function(String) onTap;

  const SearchingBar({required this.onTap, super.key});

  @override
  State<StatefulWidget> createState() {
    return SearchingBarState();
  }
}

class SearchingBarState extends State<SearchingBar> {
  late final Function(String) _onTap;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _onTap = widget.onTap;
    Future.delayed(Duration.zero, () {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: CupertinoTextField(
              focusNode: _focusNode,
              maxLines: 1,
              placeholder: "search...",
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              prefix: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              onChanged: (value) => _onTap(value),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(
              CupertinoIcons.qrcode_viewfinder,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              // Handle QR scan
            },
          ),
        ],
      ),
    );
  }
}
