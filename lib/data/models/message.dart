import 'package:chatting_app/data/models/file_metadata.dart';
import 'package:chatting_app/data/models/sender.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  String id;

  @JsonKey(name: "user_id")
  int userId;
  String? content;
  String timestamp;

  FileMetadata? file;
  List<String>? images;

  @JsonKey(name: "receiver_id")
  int? receiverId;

  @JsonKey(name: "group_id")
  int? groupId;

  @JsonKey(name: "sender")
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

  factory Message.fromJson(Map<String, dynamic> map) => _$MessageFromJson(map);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

class MessageCreateBase {
  int userId;
  String timestamp;

  String? content;
  List<String>? images;
  FileMetadata? file;

  MessageCreateBase({
    required this.userId,
    required this.timestamp,
    this.content,
    this.images,
    this.file,
  });

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

    return json;
  }
}

class DirectMessageCreate extends MessageCreateBase {
  int receiverId;

  DirectMessageCreate({
    required this.receiverId,

    required super.userId,
    required super.timestamp,
    super.content,
    super.images,
    super.file,
  });

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json['receiver_id'] = receiverId;
    return json;
  }
}

class GroupMessageCreate extends MessageCreateBase {
  int groupId;

  GroupMessageCreate({
    required this.groupId,

    required super.userId,
    required super.timestamp,
    super.content,
    super.images,
    super.file,
  });

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json['group_id'] = groupId;
    return json;
  }
}

@JsonSerializable()
class MessageUpdate {
  String content;

  MessageUpdate({required this.content});

  factory MessageUpdate.fromJson(Map<String, dynamic> json) =>
      _$MessageUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$MessageUpdateToJson(this);
}
