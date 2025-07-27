import 'package:chatting_app/data/models/sender.dart';
import 'package:json_annotation/json_annotation.dart';

part 'conversation.g.dart';

@JsonSerializable(explicitToJson: true)
class Conversation {
  String id;

  @JsonKey(name: "display_name")
  String displayName;

  @JsonKey(name: "display_avatar")
  String? displayAvatar;

  @JsonKey(name: "user_id")
  int userId;

  @JsonKey(name: "group_id")
  int? groupId;

  @JsonKey(name: "receiver_id")
  int? receiverId;

  String? content;

  String timestamp;

  @JsonKey(name: "sender")
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

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationToJson(this);
}
