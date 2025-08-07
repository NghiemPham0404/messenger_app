import 'package:flutter/material.dart';

import '../../domain/entities/conversation.dart';

class ChatHeader extends StatefulWidget {
  final Conversation conversation;

  const ChatHeader({super.key, required this.conversation});

  @override
  State<StatefulWidget> createState() {
    return ChatHeaderState();
  }
}

class ChatHeaderState extends State<ChatHeader> {
  late Conversation _conversation;

  bool isOnline = true;

  @override
  void initState() {
    super.initState();
    _conversation = widget.conversation;
  }

  @override
  Widget build(BuildContext context) {
    final avatarLink =
        _conversation.displayAvatar ??
        "https://api.dicebear.com/9.x/initials/png?seed=${_conversation.displayName}&backgroundType=gradientLinear";

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
          ),
          CircleAvatar(backgroundImage: NetworkImage(avatarLink)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _conversation.displayName,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 16),
                  maxLines: 1,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 5,
                  children: [
                    isOnline
                        ? SizedBox(
                          width: 10,
                          height: 10,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        )
                        : SizedBox.shrink(),
                    Text(
                      "online",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.call),
            iconSize: 24,
            onPressed: () {},
            color: Theme.of(context).primaryColor,
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            iconSize: 24,
            onPressed: () {},
            color: Theme.of(context).primaryColor,
          ),
          IconButton(
            icon: Icon(Icons.info_outline),
            iconSize: 24,
            onPressed: () {},
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
