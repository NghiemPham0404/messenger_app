import 'package:pulse_chat/core/responses/list_response.dart';
import 'package:pulse_chat/features/conversation/domain/entities/message.dart';
import 'package:pulse_chat/features/conversation/domain/repositories/chat_repo.dart';

class GetChatHistory {
  final ChatRepository _chatRepository;

  GetChatHistory({required ChatRepository chatRepository})
    : _chatRepository = chatRepository;

  Future<ListResponse<Message>> call({
    required int otherId,
    required int page,
  }) async {
    return _chatRepository.getChatHistory(otherId, page);
  }
}
