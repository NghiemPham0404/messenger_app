import 'package:pulse_chat/core/responses/message_response.dart';
import 'package:pulse_chat/features/conversation/domain/repositories/chat_repo.dart';

class DeleteMessage {
  final ChatRepository _chatRepository;

  DeleteMessage({required ChatRepository chatRepository})
    : _chatRepository = chatRepository;

  Future<MessageResponse> call(String messageId) async {
    return _chatRepository.deleteMessage(messageId);
  }
}
