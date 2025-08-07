import 'package:pulse_chat/features/conversation/domain/entities/conversation.dart';
import 'package:pulse_chat/features/media/domain/entity/file_metadata.dart';

import 'sender.dart';

class Message {
  String id;
  int userId;
  String? content;
  String timestamp;

  FileMetadata? file;
  List<String>? images;

  int? receiverId;
  int? groupId;
  Sender sender;

  Message({
    required this.id,
    required this.userId,
    this.content,
    required this.timestamp,
    this.file,
    this.images,
    this.receiverId,
    this.groupId,
    required this.sender,
  });

  Conversation toConversation() {
    final bool isGroup = groupId != null;
    final String conversationId =
        "${isGroup ? 'g' : 'u'}${isGroup ? groupId! : userId}";

    final conversation = Conversation(
      id: conversationId,
      displayName: sender.name,
      displayAvatar: sender.avatar,
      userId: userId,
      groupId: groupId,
      receiverId: receiverId,
      content: content,
      timestamp: timestamp,
      sender: sender,
      uncheckedCount: 1,
    );

    return conversation;
  }
}
