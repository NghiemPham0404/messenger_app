import 'dart:async';
import 'package:chatting_app/data/models/conversation.dart';
import 'package:chatting_app/data/models/message.dart';
import 'package:chatting_app/data/network/api_client.dart';
import 'package:flutter/material.dart';

class ConversationRepo {
  final ApiClient _apiClient = ApiClient();

  factory ConversationRepo() => _instance;

  ConversationRepo.internal();

  static final ConversationRepo _instance = ConversationRepo.internal();

  final StreamController<List<Conversation>> _conversationsStream =
      StreamController.broadcast();
  final StreamController<List<Message>> _conversationMessagesStream =
      StreamController.broadcast();

  Stream<List<Conversation>> get userConversation =>
      _conversationsStream.stream;

  Stream<List<Message>> get conversationMessage =>
      _conversationMessagesStream.stream.asBroadcastStream();

  List<Message> _cachedMessages = [];
  int _currentPage = 0;

  void requestUserConversations(int userId) async {
    if (!_conversationsStream.isClosed) {
      try {
        final conversations = await _apiClient.conversationApi
            .getUserConversations(userId);
        _conversationsStream.add(conversations);
      } catch (e) {
        debugPrint("[Conversations] error: $e");
      }
    }
  }

  void requestDirectConversation({
    required int userId,
    required int otherUserId,
    int page = 1,
  }) async {
    if (!_conversationMessagesStream.isClosed) {
      try {
        final data = await _apiClient.conversationApi.getDirectMessages(
          userId,
          otherUserId,
          page,
        );
        _conversationMessagesStream.add(data.results!);
        _cachedMessages = data.results!;
        _currentPage = 1;
      } catch (e) {
        debugPrint("[Conversations] error: $e");
      }
    }
  }

  void requestOlderDirectConversation({
    required int userId,
    required int otherUserId,
  }) async {
    if (!_conversationMessagesStream.isClosed) {
      try {
        await _apiClient.conversationApi
            .getDirectMessages(userId, otherUserId, _currentPage + 1)
            .then((data) {
              _cachedMessages.addAll(data.results!);
              _conversationMessagesStream.add(_cachedMessages);
              _currentPage++;
            });
      } catch (e) {
        debugPrint("[Conversations] error: $e");
      }
    }
  }

  void requestGroupConversation({required int groupId, int page = 1}) async {
    if (!_conversationMessagesStream.isClosed) {
      try {
        final data = await _apiClient.conversationApi.getGroupMessages(
          groupId,
          page,
        );
        _conversationMessagesStream.add(data.results!);
        _cachedMessages = data.results!;
        _currentPage = 1;
      } catch (e) {
        debugPrint("[Conversations] error: $e");
      }
    }
  }

  void requestOlderGroupConversation(int groupId) async {
    if (!_conversationMessagesStream.isClosed) {
      try {
        final data = await _apiClient.conversationApi.getGroupMessages(
          groupId,
          _currentPage = _currentPage + 1,
        );
        _cachedMessages.addAll(data.results!);
        _conversationMessagesStream.add(_cachedMessages);
        _currentPage++;
      } catch (e) {
        debugPrint("[Conversations] error: $e");
      }
    }
  }

  void addMessage(Message message) {
    if (!_conversationMessagesStream.isClosed) {
      _cachedMessages = [message, ..._cachedMessages];
      _conversationMessagesStream.add(_cachedMessages);
    }
  }
}
