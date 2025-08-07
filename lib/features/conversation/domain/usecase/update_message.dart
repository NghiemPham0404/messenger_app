import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/conversation/domain/entities/message.dart';
import 'package:pulse_chat/features/conversation/domain/entities/message_update.dart';
import 'package:pulse_chat/features/conversation/domain/repositories/chat_repo.dart';

class UpdateMessage {
  final ChatRepository _chatRepository;

  UpdateMessage({required ChatRepository chatRepository})
    : _chatRepository = chatRepository;

  Future<ObjectResponse<Message>> call(
    String messageId,
    MessageUpdate messageUpdate,
  ) async {
    return _chatRepository.updateMessage(messageId, messageUpdate);
  }
}
