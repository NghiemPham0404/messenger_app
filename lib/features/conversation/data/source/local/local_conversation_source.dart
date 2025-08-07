import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pulse_chat/features/conversation/data/model/conversation_model.dart';

class LocalConversationSource {
  Future<List<ConversationModel>> getUserConversations(int userId) async {
    final box = await Hive.openBox("conversations");
    return box.values
        .whereType<Map<String, dynamic>>()
        .map((e) => ConversationModel.fromJson(e))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp)); // descending
  }

  void saveUserConversations(List<ConversationModel> conversations) async {
    final box = await Hive.openBox("conversations");
    conversations.map((e) => box.put(e.id, e.toJson())).toList();
  }

  void updateConversation(ConversationModel conversation) async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    final box = await Hive.openBox("conversations");

    final existing = box.get(conversation.id);

    int newUncheckedCount = 1;
    if (existing is Map<String, dynamic>) {
      final old = ConversationModel.fromJson(existing);
      newUncheckedCount = old.uncheckedCount ?? 0 + 1;
    }

    conversation.uncheckedCount = newUncheckedCount;

    await box.put(conversation.id, conversation.toJson());
  }

  Future<void> markConversationChecked(String conversationId) async {
    final box = await Hive.openBox("conversations");

    final existing = box.get(conversationId);

    if (existing is Map<String, dynamic>) {
      final old = ConversationModel.fromJson(existing);

      final updated = ConversationModel(
        id: old.id,
        displayName: old.displayName,
        displayAvatar: old.displayAvatar,
        userId: old.userId,
        groupId: old.groupId,
        receiverId: old.receiverId,
        content: old.content,
        timestamp: old.timestamp,
        sender: old.sender,
        uncheckedCount: 0,
      );

      await box.put(conversationId, updated.toJson());
    }
  }
}
