import 'package:pulse_chat/data/models/group_member.dart';
import 'package:flutter/material.dart';

void showGroupMemberOptions(
  BuildContext context,
  GroupMember groupMember, {
  Function? grantSubHost,
  Function? deleteMember,
}) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Wrap(
        children: [
          if (grantSubHost != null)
            ListTile(
              leading: Icon(Icons.key, color: Colors.grey),
              title: Text('Promoting to sub host'),
              onTap: () {
                Navigator.pop(context);
                grantSubHost();
              },
            ),
          if (deleteMember != null)
            ListTile(
              leading: Icon(
                Icons.remove_circle_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                'Remove from group',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onTap: () {
                Navigator.pop(context);
                deleteMember();
              },
            ),
        ],
      );
    },
  );
}
