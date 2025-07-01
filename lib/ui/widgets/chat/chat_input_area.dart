import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatInputArea extends StatefulWidget {
  final Function(String? message, String? file, List<String>? images)
  sendMessage;
  final TextEditingController messageContentController;

  const ChatInputArea({
    required this.sendMessage,
    required this.messageContentController,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return MessageInputAreaState();
  }
}

class MessageInputAreaState extends State<ChatInputArea> {
  late final Function(String? message, String? file, List<String>? images)
  sendMessage;
  late final TextEditingController _messageContentController;

  bool isSendingText = false;

  @override
  void initState() {
    super.initState();
    sendMessage = widget.sendMessage;
    _messageContentController = widget.messageContentController;
    _messageContentController.addListener(() {
      if (_messageContentController.text.isNotEmpty) {
        setState(() {
          isSendingText = true;
        });
      } else {
        setState(() {
          isSendingText = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
      ),
      child: Row(
        children: [
          (!isSendingText)
              ? IconButton(
                icon: Icon(Icons.image, color: Theme.of(context).primaryColor),
                onPressed: () {},
              )
              : SizedBox.shrink(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoTextField(
                textCapitalization: TextCapitalization.sentences,
                placeholder: "Aa",
                controller: _messageContentController,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                placeholderStyle: TextStyle(color: Colors.grey),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).colorScheme.surfaceContainer,
                ),
                suffix: IconButton(
                  icon: Icon(
                    Icons.emoji_emotions,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          getSendButton(),
        ],
      ),
    );
  }

  Widget getSendButton() {
    return isSendingText
        ? IconButton(
          icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
          onPressed:
              () => sendMessage(_messageContentController.text, null, null),
        )
        : IconButton(
          icon: Icon(Icons.thumb_up, color: Theme.of(context).primaryColor),
          onPressed: () => sendMessage("👍", null, null),
        );
  }
}
