
import 'package:chatting_app/data/datasource/message_source.dart';
import 'package:chatting_app/data/models/message.dart';

class MessageRepo {

  MessageRepo.internal();

  static final MessageSource messageSource = MessageSource();

  static final MessageRepo _instance =  MessageRepo.internal();

  factory MessageRepo() => _instance;

  Future<Message?> createMesssage(int userId, int conversationId, String content) async {
    return messageSource.postMessage(userId, conversationId, content);
  }

  Future<Message?> updateMesssage(int messageId, String content) async {
    return messageSource.putMessage(messageId, content);
  }

  Future<Message?> deleteMesssage(int messageId) async {
    return messageSource.deleteMessage(messageId);
  }
}