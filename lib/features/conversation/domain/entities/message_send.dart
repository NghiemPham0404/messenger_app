import 'package:pulse_chat/features/media/domain/entity/file_metadata.dart';

class MessageSend {
  int userId;
  String timestamp;

  String? content;
  List<String>? images;
  FileMetadata? file;

  MessageSend({
    required this.userId,
    required this.timestamp,
    this.content,
    this.images,
    this.file,
  });
}

class DirectMessageSend extends MessageSend {
  int receiverId;

  DirectMessageSend({
    required this.receiverId,

    required super.userId,
    required super.timestamp,
    super.content,
    super.images,
    super.file,
  });
}

class GroupMessageSend extends MessageSend {
  int groupId;

  GroupMessageSend({
    required this.groupId,

    required super.userId,
    required super.timestamp,
    super.content,
    super.images,
    super.file,
  });
}
