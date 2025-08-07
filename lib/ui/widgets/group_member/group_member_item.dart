import 'package:pulse_chat/data/models/group_member.dart';
import 'package:pulse_chat/ui/widgets/avatar.dart';
import 'package:pulse_chat/ui/widgets/group_member/group_member_action.dart';
import 'package:flutter/material.dart';

abstract class GroupMemberBaseItem extends StatelessWidget {
  final GroupMember groupMember;

  const GroupMemberBaseItem(this.groupMember, {super.key});

  @override
  Widget build(BuildContext context) {
    final user = groupMember.member;
    return ListTile(
      onLongPress: () => onLongPress(context),
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

  void onLongPress(BuildContext context) {}
}

class GroupMemberItem extends GroupMemberBaseItem {
  final bool isMe;
  final bool isAdminOrSubAdmin;
  final Function? grantSubHost;
  final Function? deleteMember;
  const GroupMemberItem(
    super.groupMember,
    this.isAdminOrSubAdmin, {
    required this.isMe,
    this.grantSubHost,
    this.deleteMember,
    super.key,
  });

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

  @override
  void onLongPress(BuildContext context) {
    if (!isMe && isAdminOrSubAdmin) {
      showGroupMemberOptions(
        context,
        groupMember,
        grantSubHost: grantSubHost,
        deleteMember: deleteMember,
      );
    }
  }
}

class GroupSentRequestItem extends GroupMemberBaseItem {
  final Function cancelSentRequest;

  const GroupSentRequestItem(
    super.groupMember,
    this.cancelSentRequest, {
    super.key,
  });

  @override
  Widget getTrailing(BuildContext context) {
    return ElevatedButton(
      onPressed: () => cancelSentRequest(),
      child: Text("Cancel"),
    );
  }
}

class GroupWaitingReqestItem extends GroupMemberBaseItem {
  final Function acceptJoiningRequest;
  final Function declineJoiningRequest;

  const GroupWaitingReqestItem(
    super.groupMember,
    this.acceptJoiningRequest,
    this.declineJoiningRequest, {
    super.key,
  });

  @override
  Widget getSubTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      spacing: 5,
      children: [
        ElevatedButton(
          onPressed: () => acceptJoiningRequest(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
          ),
          child: Text("Accept"),
        ),
        ElevatedButton(
          onPressed: () => declineJoiningRequest(),
          child: Text("Decline"),
        ),
      ],
    );
  }
}
