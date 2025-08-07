import 'package:json_annotation/json_annotation.dart';
import 'package:pulse_chat/features/conversation/data/model/conversation_model.dart';
import 'package:pulse_chat/features/media/data/models/file_metadata_model.dart';
import 'sender_model.dart';
import '../../domain/entities/message.dart';

part 'message_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MessageModel extends Message {
  String id;

  @JsonKey(name: "user_id")
  int userId;
  String? content;
  String timestamp;

  @JsonKey(name: "file")
  @override
  final FileMetadataModel? file;

  List<String>? images;

  @JsonKey(name: "receiver_id")
  int? receiverId;

  @JsonKey(name: "group_id")
  int? groupId;

  @override
  @JsonKey(name: 'sender')
  final SenderModel sender;

  MessageModel({
    required this.id,
    required this.userId,
    this.content,
    required this.timestamp,
    this.file,
    this.images,
    this.receiverId,
    this.groupId,
    required this.sender,
  }) : super(
         id: id,
         userId: userId,
         content: content,
         timestamp: timestamp,
         file: file,
         images: images,
         receiverId: receiverId,
         groupId: groupId,
         sender: sender,
       );

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  ConversationModel toConversationModel() {
    final bool isGroup = groupId != null;
    final String conversationId =
        "${isGroup ? 'g' : 'u'}${isGroup ? groupId! : userId}";

    final conversation = ConversationModel(
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
