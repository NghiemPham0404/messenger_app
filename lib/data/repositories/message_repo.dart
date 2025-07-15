import 'package:chatting_app/data/models/message.dart';
import 'package:chatting_app/data/network/api_client.dart';
import 'package:chatting_app/data/responses/message_response.dart';
import 'package:flutter/cupertino.dart';

class MessageRepo {
  final ApiClient _apiClient = ApiClient();

  MessageRepo.internal();

  static final MessageRepo _instance = MessageRepo.internal();

  factory MessageRepo() => _instance;

  Future<Message?> sendDirectMesssage(DirectMessageCreate directMessage) async {
    try {
      final response = await _apiClient.messageApi.postDirectMessage(
        directMessage,
      );
      return response.result;
    } catch (e) {
      debugPrint("[Send DirectMessage] error : $e");
      return null;
    }
  }

  Future<Message?> sendGroupMessage(
    GroupMessageCreate groupMessageCreate,
  ) async {
    try {
      final response = await _apiClient.messageApi.postGroupMessage(
        groupMessageCreate.groupId,
        groupMessageCreate,
      );
      return response.result;
    } catch (e) {
      debugPrint("[Send GroupMessage] error : $e");
      return null;
    }
  }

  Future<Message?> updateSentMessage(
    String messageId,
    MessageUpdate updatedMessage,
  ) async {
    final response = await _apiClient.messageApi.putMessage(
      messageId,
      updatedMessage,
    );
    return response.result!;
  }

  Future<MessageResponse> deleteMessage(String messageId) async {
    return _apiClient.messageApi.deleteMessage(messageId);
  }
}
