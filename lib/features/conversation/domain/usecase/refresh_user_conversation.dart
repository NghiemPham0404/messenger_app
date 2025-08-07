import 'package:pulse_chat/features/conversation/domain/entities/conversation.dart';
import 'package:pulse_chat/features/conversation/domain/repositories/conversation_repo.dart';

class RefreshUserConversations {
  final ConversationRepository _conversationRepo;

  RefreshUserConversations({conversationRepo})
    : _conversationRepo = conversationRepo;

  Future<List<Conversation>> call(int userId) {
    return _conversationRepo.refreshConversationsOfUser(userId);
  }
}
