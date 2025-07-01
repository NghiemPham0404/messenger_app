import 'package:chatting_app/data/models/message.dart';
import 'package:chatting_app/ui/widgets/avatar.dart';
import 'package:flutter/material.dart';

// --- Helper Widget for Chat Bubbles ---
class MessageBubble extends StatefulWidget {
  final Message message;
  final bool isMe;

  const MessageBubble({super.key, required this.message, required this.isMe});

  @override
  State<StatefulWidget> createState() {
    return MessageBubbleState();
  }
}

class MessageBubbleState extends State<MessageBubble> {
  late final Message message;
  late final bool isMe;
  bool _sent = true;
  bool _error = true;

  @override
  void initState() {
    super.initState();
    message = widget.message;
    isMe = widget.isMe;
    _sent = !widget.message.id.startsWith("temp");
    _error = widget.message.id.startsWith("error");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          (!isMe && message.groupId != null)
              ? getAvatar(message.sender.avatar)
              : SizedBox.shrink(),
          Flexible(
            child: Container(
              margin: EdgeInsets.fromLTRB(
                (isMe ? 64 : 10),
                10,
                (isMe ? 10 : 64),
                0,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 14.0,
              ),
              decoration: BoxDecoration(
                color:
                    isMe
                        ? theme.primaryColor
                        : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20.0),
                  topRight: const Radius.circular(20.0),
                  bottomLeft:
                      isMe
                          ? const Radius.circular(20.0)
                          : const Radius.circular(0),
                  bottomRight:
                      isMe
                          ? const Radius.circular(0)
                          : const Radius.circular(20.0),
                ),
              ),
              child: Text(
                message.content ?? '',
                style: TextStyle(
                  color:
                      isMe
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),

          // sending circular indicator
          (isMe && !_sent)
              ? SizedBox(
                width: 8,
                height: 8,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              )
              : SizedBox.shrink(),
          // sent unsuccessfully
          (isMe && _error)
              ? SizedBox(
                child: Icon(
                  Icons.block,
                  color: Theme.of(context).colorScheme.error,
                  size: 16,
                ),
              )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
