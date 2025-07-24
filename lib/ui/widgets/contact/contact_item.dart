import 'package:chatting_app/data/models/contact.dart';
import 'package:chatting_app/ui/widgets/avatar.dart';
import 'package:flutter/material.dart';

class ContactItem extends StatelessWidget {
  final Function? onTap;
  final Contact contact;

  const ContactItem({required this.contact, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final user = contact.otherUser;
    return ListTile(
      minTileHeight: 80,
      leading: SizedBox(
        width: 64,
        height: 64,
        child: getAvatar(user.avatar, seed: user.name),
      ),
      title: Text(user.name, style: TextStyle(fontWeight: FontWeight.bold)),
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
}

class FriendItem extends ContactItem {
  const FriendItem({required super.contact, super.key});

  @override
  Widget getTrailing(BuildContext context) {
    return Row(
      spacing: 24,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(icon: Icon(Icons.call), onPressed: () {}),
        IconButton(icon: Icon(Icons.videocam), onPressed: () {}),
      ],
    );
  }
}

class PendingRequestItem extends ContactItem {
  final Function(int) accept;
  final Function(int) dismiss;

  const PendingRequestItem({
    required super.contact,
    required this.accept,
    required this.dismiss,
    super.key,
  });

  @override
  Widget getSubTitle(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      spacing: 10,
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            onPressed: () => accept(contact.id),
            child: Text("Accept"),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHigh,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () => dismiss(contact.id),
            child: Text("Dismiss"),
          ),
        ),
      ],
    );
  }
}

class SentRequestItem extends ContactItem {
  final Function(int) cancel;

  const SentRequestItem({
    required super.contact,
    required this.cancel,
    super.key,
  });

  @override
  Widget getTrailing(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      onPressed: () => cancel(contact.id),
      child: Text("Cancel"),
    );
  }
}
