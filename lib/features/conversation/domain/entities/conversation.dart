import './sender.dart';

class Conversation {
  String id;

  String displayName;

  String? displayAvatar;

  int userId;

  int? groupId;

  int? receiverId;

  String? content;

  String timestamp;

  Sender sender;

  int? uncheckedCount = 0;

  Conversation({
    required this.id,
    required this.displayName,
    this.displayAvatar,
    required this.userId,
    this.groupId,
    this.receiverId,
    this.content,
    this.uncheckedCount,
    required this.timestamp,
    required this.sender,
  });
}
