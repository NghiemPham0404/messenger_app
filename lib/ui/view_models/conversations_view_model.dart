import 'dart:async';

import 'package:chatting_app/data/models/conversation.dart';
import 'package:chatting_app/data/models/message.dart';
import 'package:chatting_app/data/repositories/conversation_repo.dart';

class ConversationsViewModel {

  final _conversationRepo = ConversationRepo();

  // Private constructor
  ConversationsViewModel._internal();

  // Singleton instance
  static final ConversationsViewModel _instance = ConversationsViewModel._internal();

  factory ConversationsViewModel(){
    return _instance;
  }

  void requestGetConversationsOfUser(){
    _conversationRepo.requestUserConversations();
  }

  Stream<List<Conversation>> getUserConversations() => _conversationRepo.getUserConversations();

  void requestGetConversationMessages(int conversationId){
    _conversationRepo.requestConversationMessages(conversationId);
  }

  Stream<List<Message>> getConversationMessages() => _conversationRepo.getConversationMessages();

}