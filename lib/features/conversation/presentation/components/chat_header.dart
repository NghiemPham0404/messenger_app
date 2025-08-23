import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_chat/features/conversation/presentation/pages/chat_page/change_notifier/chat_header_notifier.dart';

class ChatHeader extends StatefulWidget {
  const ChatHeader({super.key});

  @override
  State<StatefulWidget> createState() {
    return ChatHeaderState();
  }
}

class ChatHeaderState extends State<ChatHeader> {
  bool isOnline = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatHeaderNotifier>(
      builder:
          (context, value, child) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    value.displayAvatar ??
                        "https://api.dicebear.com/9.x/initials/png?seed=${value.dislayName}&backgroundType=gradientLinear",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value.dislayName,
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
          ),
    );
  }
}
