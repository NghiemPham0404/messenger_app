import 'package:pulse_chat/features/conversation/domain/entities/conversation.dart';
import 'package:pulse_chat/features/conversation/domain/repositories/conversation_repo.dart';

class UpdateConversation {
  final ConversationRepository _conversationRepository;

  UpdateConversation(this._conversationRepository);

  Future<void> call(Conversation conversation) async {
    await _conversationRepository.updateConversation(conversation);
  }
}
