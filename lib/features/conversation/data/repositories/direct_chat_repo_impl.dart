import 'package:flutter/material.dart';
import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:pulse_chat/core/responses/list_response.dart';
import 'package:pulse_chat/core/responses/message_response.dart';
import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/conversation/data/model/message_update_model.dart';
import 'package:pulse_chat/features/conversation/domain/entities/message_update.dart';
import 'package:pulse_chat/features/media/data/models/file_metadata_model.dart';
import 'package:pulse_chat/features/conversation/data/model/message_model.dart';
import 'package:pulse_chat/features/conversation/data/model/message_send_model.dart';
import 'package:pulse_chat/features/conversation/data/source/network/chat_service.dart';
import 'package:pulse_chat/features/conversation/data/source/network/conversation_service.dart';
import 'package:pulse_chat/features/conversation/domain/entities/message.dart';
import 'package:pulse_chat/features/conversation/domain/entities/message_send.dart';
import 'package:pulse_chat/features/conversation/domain/repositories/chat_repo.dart';

class DirectChatRepoImpl extends DirectChatRepo {
  final ConversationService _conversationService;
  final ChatService _chatService;

  final LocalAuthSource _localAuthSource;

  DirectChatRepoImpl({conversationService, chatService, localAuthSource})
    : _conversationService = conversationService,
      _chatService = chatService,
      _localAuthSource = localAuthSource;

  @override
  Future<ListResponse<Message>> getChatHistory(
    int otherUserId,
    int page,
  ) async {
    final currentUser = _localAuthSource.getCachedUser();
    if (currentUser != null) {
      final res = await _conversationService.getDirectMessages(
        currentUser.id,
        otherUserId,
        page,
      );
      debugPrint("Response: ${res.toString()}");
      return res;
    } else {
      throw {"detail": "Unauthenticated"};
    }
  }

  @override
  Future<ObjectResponse<MessageModel>> sendMessage(
    int otherUserId,
    MessageSend messageSend,
  ) async {
    final currentUser = _localAuthSource.getCachedUser();
    var file;
    if (messageSend.file != null) {
      file = FileMetadataModel(
        url: messageSend.file!.url,
        name: messageSend.file!.name,
        format: messageSend.file!.format,
        size: messageSend.file!.size,
      );
    }
    if (currentUser != null) {
      final directMessageSend = DirectMessageSendModel(
        receiverId: otherUserId,
        userId: currentUser.id,
        timestamp: messageSend.timestamp,

        content: messageSend.content,
        images: messageSend.images,
        file: file,
      );
      return _chatService.postDirectMessage(directMessageSend);
    } else {
      throw {"detail": "Unauthenticated"};
    }
  }

  @override
  Future<MessageResponse> deleteMessage(String messageId) async {
    return _chatService.deleteMessage(messageId);
  }

  @override
  Future<ObjectResponse<Message>> updateMessage(
    String messageId,
    MessageUpdate messageUpdate,
  ) {
    final messageUpdateModel = MessageUpdateModel(
      content: messageUpdate.content,
    );
    return _chatService.putMessage(messageId, messageUpdateModel);
  }
}
