import 'package:pulse_chat/features/media/data/models/file_metadata_model.dart';
import 'package:pulse_chat/features/conversation/domain/entities/message_send.dart';

class DirectMessageSendModel extends DirectMessageSend {
  @override
  final FileMetadataModel? file;

  DirectMessageSendModel({
    required super.receiverId,

    required super.userId,
    required super.timestamp,
    super.content,
    super.images,
    this.file,
  }) : super(file: file);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {"user_id": userId, "timestamp": timestamp};
    if (content != null) {
      json['content'] = content;
    }
    if (images != null) {
      json['images'] = images;
    }
    if (file != null) {
      json['file'] = file;
    }
    json['receiver_id'] = receiverId;
    return json;
  }
}

class GroupMessageSendModel extends GroupMessageSend {
  @override
  final FileMetadataModel? file;

  GroupMessageSendModel({
    required super.groupId,

    required super.userId,
    required super.timestamp,
    super.content,
    super.images,
    this.file,
  }) : super(file: file);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {"user_id": userId, "timestamp": timestamp};
    if (content != null) {
      json['content'] = content;
    }
    if (images != null) {
      json['images'] = images;
    }
    if (file != null) {
      json['file'] = file;
    }
    json['group_id'] = groupId;
    return json;
  }
}
