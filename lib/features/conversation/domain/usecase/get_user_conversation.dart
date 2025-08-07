import 'package:pulse_chat/features/conversation/domain/entities/conversation.dart';
import 'package:pulse_chat/features/conversation/domain/repositories/conversation_repo.dart';

class GetUserConversations {
  final ConversationRepository _conversationRepo;

  GetUserConversations({conversationRepo})
    : _conversationRepo = conversationRepo;

  Future<List<Conversation>> call(int userId) {
    return _conversationRepo.getConversationsOfUser(userId);
  }
}
