import 'package:chatting_app/data/models/group.dart';
import 'package:chatting_app/ui/view_models/group_detail_view_model.dart';
import 'package:chatting_app/ui/views/group/group_detail_screen.dart';
import 'package:chatting_app/ui/widgets/avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchGroupItem extends StatelessWidget {
  final Group group;

  const SearchGroupItem({required this.group, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => navigateToDetailScreen(context, group),
      key: Key(group.id.toString()),
      leading: getAvatar(group.avatar, seed: group.subject),
      title: Text(group.subject),
    );
  }

  void navigateToDetailScreen(BuildContext context, Group group) {
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        builder:
            (context) => ChangeNotifierProvider(
              create: (_) => GroupDetailViewModel.fromId(group.id),
              child: GroupDetailScreen(),
            ),
      ),
    );
  }
}
