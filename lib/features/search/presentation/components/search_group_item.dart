import 'package:pulse_chat/features/group/domain/entities/group.dart';
import 'package:pulse_chat/features/group/presentation/group_pages/view/group_detail_screen.dart';
import 'package:pulse_chat/shared/avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        builder: (context) => GroupDetailScreen(groupId: group.id),
      ),
    );
  }
}
