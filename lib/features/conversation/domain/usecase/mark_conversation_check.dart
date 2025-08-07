import 'package:pulse_chat/features/conversation/domain/repositories/conversation_repo.dart';

class MarkConversationChecked {
  final ConversationRepository _conversationRepository;

  MarkConversationChecked(this._conversationRepository);

  Future<void> call(String conversationId) async {
    await _conversationRepository.markConversationChecked(conversationId);
  }
}
