import 'dart:io';

import 'package:provider/provider.dart';
import 'package:pulse_chat/features/conversation/presentation/pages/chat_page/change_notifier/chat_download.dart';
import 'package:pulse_chat/ui/widgets/avatar.dart';
import 'package:pulse_chat/features/conversation/presentation/components/file_item.dart';
import 'package:pulse_chat/ui/widgets/image_viewer.dart';
import 'package:pulse_chat/core/util/format_readable_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/message.dart';

// --- Helper Widget for Chat Bubbles ---
class MessageBubble extends StatefulWidget {
  final int index;
  final Message message;
  final bool isMe;
  final VoidCallback onLongPress;

  const MessageBubble({
    super.key,
    required this.message,
    required this.index,
    required this.isMe,
    required this.onLongPress,
  });

  @override
  State<StatefulWidget> createState() {
    return MessageBubbleState();
  }
}

class MessageBubbleState extends State<MessageBubble> {
  late final int index;
  late final Message message;
  late final bool isMe;
  late final VoidCallback onLongPress;

  bool _sent = true;
  bool _error = true;
  bool _showSentTime = false;

  @override
  void initState() {
    super.initState();
    index = widget.index;
    message = widget.message;
    isMe = widget.isMe;
    onLongPress = widget.onLongPress;

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
                if (_showSentTime) _getSentTime(),
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
    return GestureDetector(
      onTap: () => _changeShowSentTime(),
      onLongPress: isMe ? () => onLongPress() : null,
      child: Container(
        margin: EdgeInsets.fromLTRB(
          (isMe ? 100 : 10),
          10,
          (isMe ? 10 : 100),
          0,
        ),
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
            color:
                isMe ? Colors.white : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _displayImage() {
    if (message.images!.length > 1) {
      return GestureDetector(
        onTap: () => navigateToImageViewer(),
        child: _getImagesFrames(),
      );
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
      child: Consumer<ChatDownloadNotifier>(
        builder:
            (context, value, child) =>
                FileItem(message.file!, () => value.downloadFile(index)),
      ),
    );
  }

  void _changeShowSentTime() {
    setState(() {
      _showSentTime = !_showSentTime;
    });
  }

  Widget _getSentTime() {
    return SizedBox(
      width: double.infinity,
      child: Text(
        formatReadableDateChat(message.timestamp),
        style: TextStyle(fontSize: 10),
        textAlign: TextAlign.center,
      ),
    );
  }

  void navigateToImageViewer() {
    if (message.images == null) return;
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => ImageViewer(message.images ?? []),
      ),
    );
  }
}
