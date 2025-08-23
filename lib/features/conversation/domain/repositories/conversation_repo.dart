import '../entities/conversation.dart';

abstract class ConversationRepository {
  Future<List<Conversation>> getConversationsOfUser(int userId);
  Future<List<Conversation>> refreshConversationsOfUser(int userId);
  Future<void> markConversationChecked(String conversationId);
  Future<void> updateConversation(Conversation conversation);
}
