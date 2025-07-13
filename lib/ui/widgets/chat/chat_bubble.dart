import 'dart:io';

import 'package:chatting_app/data/models/message.dart';
import 'package:chatting_app/ui/widgets/avatar.dart';
import 'package:chatting_app/ui/widgets/chat/file_icon.dart';
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
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe && message.groupId != null)
            getAvatar(message.sender.avatar),
          Flexible(
            fit: FlexFit.loose,
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (message.content != null) getMessageContentBubble(context),
                if (message.images != null && message.images!.isNotEmpty)
                  _displayImage(),
                if (message.file != null) _displayFile(context),
              ],
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

  Widget getMessageContentBubble(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.fromLTRB((isMe ? 100 : 10), 10, (isMe ? 10 : 100), 0),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
      decoration: BoxDecoration(
        gradient:
            isMe
                ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [theme.primaryColor, theme.primaryColorDark],
                )
                : LinearGradient(
                  colors: [
                    theme.colorScheme.surfaceContainerHighest,
                    theme.colorScheme.surfaceContainerHigh,
                  ],
                ),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20.0),
          topRight: const Radius.circular(20.0),
          bottomLeft:
              isMe ? const Radius.circular(20.0) : const Radius.circular(0),
          bottomRight:
              isMe ? const Radius.circular(0) : const Radius.circular(20.0),
        ),
      ),
      child: Text(
        message.content ?? '',
        style: TextStyle(
          color: isMe ? Colors.white : Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _displayImage() {
    if (message.images!.length > 1) {
      return _getImagesFrames();
    } else {
      return _getSingleImage();
    }
  }

  Widget _getImagesFrames() {
    int count = message.images?.length ?? 0;
    int crossAxisCount = 2;
    if (count >= 3) crossAxisCount = 3;

    return Container(
      margin: EdgeInsets.fromLTRB((isMe ? 100 : 10), 10, (isMe ? 10 : 100), 0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        itemCount: count,
        itemBuilder: (context, index) {
          return AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child:
                  message.images![index].contains("http")
                      ? Image.network(message.images![index], fit: BoxFit.cover)
                      : Image.file(
                        File(message.images![index]),
                        fit: BoxFit.cover,
                      ),
            ),
          );
        },
      ),
    );
  }

  Widget _getSingleImage() {
    return Container(
      margin: EdgeInsets.fromLTRB((isMe ? 100 : 10), 10, (isMe ? 10 : 100), 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child:
            message.images![0].contains("http")
                ? Image.network(message.images![0])
                : Image.file(File(message.images![0])),
      ),
    );
  }

  Widget _displayFile(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB((isMe ? 100 : 10), 10, (isMe ? 10 : 100), 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          spacing: 10,
          children: [
            getFileIconAsset(
              message.file!.format,
              fileName: message.file!.name,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.file!.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    spacing: 10,
                    children: [
                      Text(message.file!.format, maxLines: 1),
                      Text(formatBytes(message.file!.size), maxLines: 1),
                    ],
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      Icon(Icons.info_outline, size: 16),
                      Text("download for offline", maxLines: 1),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatBytes(int bytes) {
    if (bytes >= 1024 * 1024) {
      double mb = bytes / (1024 * 1024);
      return "${mb.toStringAsFixed(2)} MB";
    } else if (bytes >= 1024) {
      double kb = bytes / 1024;
      return "${kb.toStringAsFixed(2)} KB";
    } else {
      return "$bytes B";
    }
  }
}
