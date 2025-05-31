import 'dart:async';

import 'package:chatting_app/data/datasource/conversation_source.dart';
import 'package:chatting_app/data/models/conversation.dart';
import 'package:chatting_app/data/models/message.dart';

class ConversationRepo{
  final _conversationSource = ConversationSource();
  final StreamController<List<Conversation>> _conversationsStream = StreamController.broadcast();
  final StreamController<List<Message>> _conversationMessagesStream = StreamController.broadcast();

  ConversationRepo.internal();

  static final ConversationRepo _instance = ConversationRepo.internal();

  factory ConversationRepo() => _instance;

  Future<void> requestUserConversations() async{
    if (!_conversationsStream.isClosed){
      final data = await _conversationSource.getUserConversations();
      _conversationsStream.add(data);
    }
  }

  Stream<List<Conversation>> getUserConversations(){
    return _conversationsStream.stream;
  }

  Future<void> requestConversationMessages(int conversationId) async{
    if(!_conversationMessagesStream.isClosed){
       final data = await _conversationSource.getConversationMessages(conversationId);
      _conversationMessagesStream.add([]);
      _conversationMessagesStream.add(data);
    }
  }

  Stream<List<Message>> getConversationMessages(){
    return _conversationMessagesStream.stream;
  }
}