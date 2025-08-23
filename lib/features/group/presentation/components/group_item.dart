import 'package:pulse_chat/features/group/domain/entities/group.dart';
import 'package:pulse_chat/features/group/presentation/group_pages/view/group_detail_screen.dart';
import 'package:pulse_chat/shared/avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupItem extends StatelessWidget {
  final Function? onTap;
  final Group group;

  const GroupItem({required this.group, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minTileHeight: 80,
      leading: SizedBox(
        width: 64,
        height: 64,
        child: getAvatar(group.avatar, seed: group.subject),
      ),
      title: Text(group.subject, style: TextStyle(fontWeight: FontWeight.bold)),
      trailing: getTrailing(context),
      subtitle: getSubTitle(context),
      onTap: () => tapOnItem(context),
    );
  }

  void tapOnItem(BuildContext context) {
    _navigateToDetailScreen(context, group);
  }

  void _navigateToDetailScreen(BuildContext context, Group group) {
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        builder: (context) => GroupDetailScreen(groupId: group.id),
      ),
    );
  }

  Widget getTrailing(BuildContext context) {
    return SizedBox.shrink();
  }

  Widget getSubTitle(BuildContext context) {
    return SizedBox.shrink();
  }
}

class GroupJoinningInviteItem extends GroupItem {
  final Function acceptInvite;

  const GroupJoinningInviteItem({
    required super.group,
    required this.acceptInvite,
    super.key,
  });

  @override
  Widget getTrailing(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      onPressed: () => acceptInvite(),
      child: Text("accept"),
    );
  }
}
