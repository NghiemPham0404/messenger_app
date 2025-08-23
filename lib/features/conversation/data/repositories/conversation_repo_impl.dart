import 'package:pulse_chat/features/conversation/data/model/conversation_model.dart';
import 'package:pulse_chat/features/conversation/data/model/sender_model.dart';
import 'package:pulse_chat/features/conversation/domain/entities/conversation.dart';
import 'package:pulse_chat/features/conversation/domain/repositories/conversation_repo.dart';
import '../source/local/local_conversation_source.dart';
import '../source/network/conversation_service.dart';

class ConversationRepoImp implements ConversationRepository {
  LocalConversationSource _localConversationSource;
  ConversationService _conversationService;

  ConversationRepoImp({
    required localConversationSource,
    required conversationService,
  }) : _localConversationSource = localConversationSource,
       _conversationService = conversationService;

  @override
  Future<List<Conversation>> getConversationsOfUser(int userId) async {
    final cachedConversations = await _localConversationSource
        .getUserConversations(userId);
    if (cachedConversations.isNotEmpty) {
      return cachedConversations;
    } else {
      return refreshConversationsOfUser(userId);
    }
  }

  @override
  Future<List<Conversation>> refreshConversationsOfUser(int userId) async {
    return _conversationService.getUserConversations(userId);
  }

  @override
  Future<void> markConversationChecked(String conversationId) async {
    _localConversationSource.markConversationChecked(conversationId);
  }

  @override
  Future<void> updateConversation(Conversation conversation) async {
    final conversationModel = ConversationModel(
      id: conversation.id,
      displayName: conversation.displayName,
      displayAvatar: conversation.displayAvatar,
      userId: conversation.userId,
      groupId: conversation.groupId,
      receiverId: conversation.receiverId,
      content: conversation.content,
      timestamp: conversation.timestamp,
      sender: SenderModel(
        id: conversation.sender.id,
        name: conversation.sender.name,
        avatar: conversation.sender.avatar,
      ),
      uncheckedCount: conversation.uncheckedCount,
    );
    _localConversationSource.updateConversation(conversationModel);
  }
}
