import 'package:chatting_app/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InfoCard extends StatelessWidget {
  final UserExtended user;

  const InfoCard({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      children: [
        Center(
          child: ClipOval(
            child: Image.network(
              user.avatar!,
              width: 96,
              height: 96,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return SvgPicture.asset(
                  "assets/images/user-svgrepo-com.svg",
                  width: 96,
                  height: 96,
                );
              },
            ),
          ),
        ),
        Text(
          user.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          textAlign: TextAlign.center,
        ),
        user.relationship.contactStatus == 1
            ? Text("Friend", textAlign: TextAlign.center)
            : SizedBox.shrink(),
        _getButtons(context),
      ],
    );
  }

  Widget _getButtons(BuildContext context) {
    final contactStatus = user.relationship.contactStatus;

    switch (contactStatus) {
      case -1:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              _getSendFriendRequestButton(context),
              const SizedBox(width: 10),
              Expanded(child: _getChatButton(context)),
            ],
          ),
        );

      case 0:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              _getAcceptButton(context),
              const SizedBox(width: 10),
              Expanded(child: _getChatButton(context)),
            ],
          ),
        );

      case 1:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              _getDeleteButton(context),
              const SizedBox(width: 10),
              Expanded(child: _getChatButton(context)),
            ],
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _getSendFriendRequestButton(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.person_add),
        label: const Text("Add Friend"),
        iconAlignment: IconAlignment.start,
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _getAcceptButton(BuildContext context) {
    final isRequestSent = user.relationship.isSentRequest;

    return Expanded(
      child: ElevatedButton.icon(
        onPressed: () {},
        label: Text(isRequestSent ? "Dismiss" : "Accept"),
        iconAlignment: IconAlignment.start,
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
          backgroundColor:
              isRequestSent
                  ? Theme.of(context).colorScheme.surfaceContainerHighest
                  : Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _getDeleteButton(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.person_remove),
        label: const Text("Delete Friend"),
        iconAlignment: IconAlignment.start,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _getChatButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(),
      child: const Text("Chat"),
    );
  }
}
