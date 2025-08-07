import 'package:pulse_chat/data/models/user.dart';
import 'package:pulse_chat/ui/widgets/avatar.dart';
import 'package:pulse_chat/ui/widgets/contact_info_card.dart';
import 'package:flutter/material.dart';

class SearchUserItem extends StatelessWidget {
  final UserExtended result;

  final Function(int) sendRequest;
  final Function(int) acceptRequest;
  final Function(int) dismissRequest;

  const SearchUserItem({
    required this.result,
    required this.sendRequest,
    required this.acceptRequest,
    required this.dismissRequest,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key(result.id.toString()),
      leading: getAvatar(result.avatar, seed: result.name),
      title: Text(result.name),
      subtitle:
          result.relationship.contactStatus == 1
              ? Text("friend", style: TextStyle())
              : SizedBox.shrink(),
      trailing: getTrailing(context),
      onLongPress:
          () => showDialog(
            context: context,
            builder: (context) => InfoCard(user: result),
          ),
    );
  }

  Widget getTrailing(BuildContext context) {
    if (result.relationship.contactStatus == -1) {
      return getSendFriendRequestButton(context);
    } else if (result.relationship.contactStatus == 0) {
      return getAcceptButton(context);
    } else {
      return SizedBox.shrink();
    }
  }

  Widget getSendFriendRequestButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => sendFriendRequest(),
      label:
          result.relationship.contactStatus == 1
              ? SizedBox.shrink()
              : Text("add friend"),
      icon: Icon(Icons.person_add),
      style: ElevatedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget getAcceptButton(BuildContext context) {
    if (result.relationship.isSentRequest) {
      return ElevatedButton.icon(
        onPressed: () => dismissFriendRequest(),
        label: Text("request sent"),
        icon: Icon(Icons.how_to_reg),
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onSurface,
        ),
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () => acceptFriendRequest(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
            child: Text("accept"),
          ),
          _getDeleteRequestButton(context),
        ],
      );
    }
  }

  Widget _getDeleteRequestButton(BuildContext context) {
    return IconButton(
      onPressed: () => dismissFriendRequest(),
      icon: Icon(Icons.cancel),
    );
  }

  void sendFriendRequest() {
    sendRequest(result.id);
  }

  void acceptFriendRequest() {
    acceptRequest(result.relationship.contactId);
  }

  void dismissFriendRequest() {
    dismissRequest(result.relationship.contactId);
  }
}
