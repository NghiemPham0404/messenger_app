import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/conversation.dart';
import 'sender_model.dart';

part 'conversation_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ConversationModel extends Conversation {
  @JsonKey(name: 'display_name')
  String displayName;

  @JsonKey(name: 'display_avatar')
  String? displayAvatar;

  @JsonKey(name: 'user_id')
  int userId;

  @JsonKey(name: 'group_id')
  int? groupId;

  @JsonKey(name: 'receiver_id')
  int? receiverId;

  @JsonKey(name: 'content')
  String? content;

  @JsonKey(name: 'timestamp')
  String timestamp;

  @JsonKey(name: 'sender')
  final SenderModel sender;

  @JsonKey(name: 'unchecked_count')
  int? uncheckedCount;

  ConversationModel({
    required String id,
    required this.displayName,
    this.displayAvatar,
    required this.userId,
    this.groupId,
    this.receiverId,
    this.content,
    required this.timestamp,
    required this.sender,
    this.uncheckedCount = 0,
  }) : super(
         id: id,
         displayName: displayName,
         displayAvatar: displayAvatar,
         userId: userId,
         groupId: groupId,
         receiverId: receiverId,
         content: content,
         timestamp: timestamp,
         sender: sender,
         uncheckedCount: uncheckedCount,
       );

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationModelToJson(this);
}
