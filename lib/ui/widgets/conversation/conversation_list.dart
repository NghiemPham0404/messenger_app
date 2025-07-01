import 'package:chatting_app/data/models/conversation.dart';
import 'package:chatting_app/util/format_readable_date.dart';
import 'package:flutter/material.dart';

class ConversationList extends StatelessWidget {
  final List<Conversation> conversations;
  final int currentUserId;
  final Function(int) onTap;

  const ConversationList(
    this.conversations,
    this.currentUserId,
    this.onTap, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: conversations.length,
      itemBuilder:
          (context, index) => ConversationListTile(
            conversations[index],
            () => onTap(index),
            currentUserId,
          ),
    );
  }
}

class ConversationListTile extends StatelessWidget {
  final int currentUserId;
  final Conversation _conversation;
  final Function onTap;

  const ConversationListTile(
    this._conversation,
    this.onTap,
    this.currentUserId, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(10),
      leading: _getAvatar(),
      title: _getTitle(),
      subtitle: _getSubTitle(),
      trailing: _getTrailing(),
      onTap: () => onTap(),
    );
  }

  Widget _getAvatar() {
    final avatarLink =
        _conversation.displayAvatar ??
        "https://api.dicebear.com/9.x/initials/png?seed=${_conversation.displayName}&backgroundType=gradientLinear";

    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Image.network(
        avatarLink,
        errorBuilder: (context, error, stackTrace) {
          return CircleAvatar(child: _getTitle());
        },
      ),
    );
  }

  Widget _getTitle() {
    return Text(_conversation.displayName);
  }

  String _getLastMessage() {
    StringBuffer stringBuffer = StringBuffer();
    if (_conversation.sender.id == currentUserId) {
      stringBuffer.write("You: ");
    } else if (_conversation.receiverId == currentUserId) {
      stringBuffer.write("${_conversation.sender.name}: ");
    }
    stringBuffer.write(_conversation.content);
    return stringBuffer.toString();
  }

  Widget _getSubTitle() {
    return Text(_getLastMessage());
  }

  Widget? _getTrailing() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(formatReadableDate(_conversation.timestamp)),
        SizedBox(
          width: 10,
          height: 10,
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 253, 75, 75),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ],
    );
  }
}
