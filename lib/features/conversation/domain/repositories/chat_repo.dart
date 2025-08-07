import 'package:pulse_chat/core/responses/list_response.dart';
import 'package:pulse_chat/core/responses/message_response.dart';
import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:pulse_chat/features/conversation/domain/entities/message.dart';
import 'package:pulse_chat/features/conversation/domain/entities/message_send.dart';
import 'package:pulse_chat/features/conversation/domain/entities/message_update.dart';

abstract class ChatRepository {
  Future<ListResponse<Message>> getChatHistory(int otherId, int page);

  Future<ObjectResponse<Message>> sendMessage(
    int otherId,
    MessageSend messageSend,
  );

  Future<ObjectResponse<Message>> updateMessage(
    String messageId,
    MessageUpdate messageUpdate,
  );

  Future<MessageResponse> deleteMessage(String messageId);
}

abstract class DirectChatRepo implements ChatRepository {
  @override
  Future<ListResponse<Message>> getChatHistory(int otherUserId, int page);

  @override
  Future<ObjectResponse<Message>> sendMessage(
    int otherUserId,
    MessageSend messageSend,
  );
}

abstract class GroupChatRepo implements ChatRepository {
  @override
  Future<ListResponse<Message>> getChatHistory(int groupId, int page);

  @override
  Future<ObjectResponse<Message>> sendMessage(
    int groupId,
    MessageSend messageSend,
  );
}
