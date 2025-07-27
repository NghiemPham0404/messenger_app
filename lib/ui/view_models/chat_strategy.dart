import 'package:chatting_app/data/models/file_metadata.dart';
import 'package:chatting_app/data/models/message.dart';
import 'package:chatting_app/data/repositories/conversation_repo.dart';
import 'package:chatting_app/data/repositories/message_repo.dart';
import 'package:chatting_app/data/responses/list_response.dart';

abstract class ChatStrategy {
  Future<ListResponse<Message>> requestMessages({int page});

  Future<Message?> sendMessage({
    required int userId,
    required String timeStamp,
    String? messageContent,
    FileMetadata? file,
    List<String>? images,
  });
}

class DirectChatStrategy implements ChatStrategy {
  final int userId;
  final int receiverId;
  final ConversationRepo conversationRepo;
  final MessageRepo messageRepo;

  DirectChatStrategy({
    required this.userId,
    required this.receiverId,
    required this.conversationRepo,
    required this.messageRepo,
  });

  @override
  Future<ListResponse<Message>> requestMessages({int page = 1}) async {
    return conversationRepo.requestDirectConversation(
      userId: userId,
      otherUserId: receiverId,
      page: page,
    );
  }

  @override
  Future<Message?> sendMessage({
    required int userId,
    required String timeStamp,
    String? messageContent,
    FileMetadata? file,
    List<String>? images,
  }) async {
    return await messageRepo.sendDirectMesssage(
      DirectMessageCreate(
        receiverId: receiverId,
        userId: userId,
        timestamp: timeStamp,
        content: messageContent,
        file: file,
        images: images,
      ),
    );
  }
}

class GroupChatStrategy implements ChatStrategy {
  final int userId;
  final int groupId;
  final ConversationRepo conversationRepo;
  final MessageRepo messageRepo;

  GroupChatStrategy({
    required this.userId,
    required this.groupId,
    required this.conversationRepo,
    required this.messageRepo,
  });

  @override
  Future<ListResponse<Message>> requestMessages({int page = 1}) async {
    return conversationRepo.requestGroupConversation(groupId: groupId, page: 1);
  }

  @override
  Future<Message?> sendMessage({
    required int userId,
    required String timeStamp,
    String? messageContent,
    FileMetadata? file,
    List<String>? images,
  }) async {
    return await messageRepo.sendGroupMessage(
      GroupMessageCreate(
        groupId: groupId,
        userId: userId,
        timestamp: timeStamp,
        content: messageContent,
        file: file,
        images: images,
      ),
    );
  }
}
