import 'dart:async';
import 'package:chatting_app/data/models/conversation.dart';
import 'package:chatting_app/data/models/message.dart';
import 'package:chatting_app/data/network/api_client.dart';
import 'package:chatting_app/data/responses/list_response.dart';
import 'package:chatting_app/data/services/conversation_service_local.dart';

class ConversationRepo {
  final ApiClient _apiClient = ApiClient();

  factory ConversationRepo() => _instance;

  ConversationRepo.internal();

  static final ConversationRepo _instance = ConversationRepo.internal();

  Future<List<Conversation>> requestUserConversations(int userId) async {
    var conversations = await ConversationServiceLocal().getUserConversations(
      userId,
    );
    if (conversations.isEmpty) {
      conversations = await _apiClient.conversationApi.getUserConversations(
        userId,
      );
      ConversationServiceLocal().saveUserConversations(conversations);
    }
    return conversations;
  }

  Future<ListResponse<Message>> requestDirectConversation({
    required int userId,
    required int otherUserId,
    int page = 1,
  }) async {
    {
      return _apiClient.conversationApi.getDirectMessages(
        userId,
        otherUserId,
        page,
      );
    }
  }

  Future<ListResponse<Message>> requestGroupConversation({
    required int groupId,
    int page = 1,
  }) async {
    return _apiClient.conversationApi.getGroupMessages(groupId, page);
  }
}
