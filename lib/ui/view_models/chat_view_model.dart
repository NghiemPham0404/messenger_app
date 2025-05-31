import 'package:chatting_app/data/repositories/message_repo.dart';

class ChatViewModel {
  static final MessageRepo messageRepo = MessageRepo();

  ChatViewModel.internal();

  static final ChatViewModel _instance = ChatViewModel.internal();

  factory ChatViewModel() => _instance;

  void sendMessage(int userId, int conversationId, String messageContent){
    messageRepo.createMesssage(userId, conversationId, messageContent);
  }

  void editMessage(int messageId, String messageContent){
    messageRepo.updateMesssage(messageId, messageContent);
  }

  void deleteMessage(int messageId){
    messageRepo.deleteMesssage(messageId);
  }
}