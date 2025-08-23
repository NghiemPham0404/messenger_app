import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/conversation/domain/entities/message.dart';
import 'package:pulse_chat/features/conversation/domain/entities/message_send.dart';
import 'package:pulse_chat/features/conversation/domain/repositories/chat_repo.dart';

class SendMessage {
  final ChatRepository _chatRepository;

  SendMessage({required ChatRepository chatRepository})
    : _chatRepository = chatRepository;

  Future<ObjectResponse<Message>> call(
    int otherId,
    MessageSend messageSend,
  ) async {
    return _chatRepository.sendMessage(otherId, messageSend);
  }
}
