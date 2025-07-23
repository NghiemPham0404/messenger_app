import 'package:chatting_app/data/models/group_member.dart';
import 'package:chatting_app/ui/widgets/avatar.dart';
import 'package:flutter/material.dart';

abstract class GroupMemberBaseItem extends StatelessWidget {
  final GroupMember groupMember;

  const GroupMemberBaseItem(this.groupMember, {super.key});

  @override
  Widget build(BuildContext context) {
    final user = groupMember.member;
    return ListTile(
      onLongPress: () => onLongPress,
      minTileHeight: 80,
      leading: SizedBox(
        width: 64,
        height: 64,
        child: getAvatar(user!.avatar, seed: user.name),
      ),
      title: Text(
        user.name ?? "Unknow",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: getTrailing(context),
      subtitle: getSubTitle(context),
    );
  }

  Widget getTrailing(BuildContext context) {
    return SizedBox.shrink();
  }

  Widget getSubTitle(BuildContext context) {
    return SizedBox.shrink();
  }

  void onLongPress() {}
}

class GroupMemberItem extends GroupMemberBaseItem {
  final bool isMe;
  const GroupMemberItem(super.groupMember, {required this.isMe, super.key});

  @override
  Widget getSubTitle(BuildContext context) {
    if (groupMember.isHost) {
      return Row(
        spacing: 5,
        children: [Icon(Icons.key, color: Colors.amber), Text("Admin")],
      );
    } else if (groupMember.isSubHost) {
      return Row(
        spacing: 5,
        children: [
          Icon(Icons.key, color: Theme.of(context).colorScheme.onSurface),
          Text("Sub admin"),
        ],
      );
    } else {
      return Text("");
    }
  }
}

class GroupSentRequestItem extends GroupMemberBaseItem {
  const GroupSentRequestItem(super.groupMember, {super.key});

  @override
  Widget getTrailing(BuildContext context) {
    return ElevatedButton(onPressed: () {}, child: Text("Cancel"));
  }
}

class GroupWaitingReqestItem extends GroupMemberBaseItem {
  const GroupWaitingReqestItem(super.groupMember, {super.key});

  @override
  Widget getSubTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      spacing: 5,
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
          ),
          child: Text("Accept"),
        ),
        ElevatedButton(onPressed: () {}, child: Text("Decline")),
      ],
    );
  }
}
