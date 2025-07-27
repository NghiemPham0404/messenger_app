import 'package:chatting_app/data/models/conversation.dart';
import 'package:chatting_app/data/models/message.dart';
import 'package:hive_flutter/adapters.dart';

class ConversationServiceLocal {
  Future<List<Conversation>> getUserConversations(int userId) async {
    final box = await Hive.openBox("conversations");
    return box.values
        .whereType<Map<String, dynamic>>()
        .map((e) => Conversation.fromJson(e))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp)); // descending
  }

  void saveUserConversations(List<Conversation> conversations) async {
    final box = await Hive.openBox("conversations");
    conversations.map((e) => box.put(e.id, e.toJson())).toList();
  }

  void updateConversation(Message message) async {
    final box = await Hive.openBox("conversations");

    final bool isGroup = message.groupId != null;
    final String conversationId =
        "${isGroup ? 'g' : 'u'}${isGroup ? message.groupId! : message.userId}";

    final existing = box.get(conversationId);

    int newUncheckedCount = 1;
    if (existing is Map<String, dynamic>) {
      final old = Conversation.fromJson(existing);
      newUncheckedCount = old.uncheckedCount ?? 0 + 1;
    }

    final conversation = Conversation(
      id: conversationId,
      displayName: message.sender.name,
      displayAvatar: message.sender.avatar,
      userId: message.userId,
      groupId: message.groupId,
      receiverId: message.receiverId,
      content: message.content,
      timestamp: message.timestamp,
      sender: message.sender,
      uncheckedCount: newUncheckedCount,
    );

    await box.put(conversationId, conversation.toJson());
  }

  Future<void> markConversationChecked(String conversationId) async {
    final box = await Hive.openBox("conversations");

    final existing = box.get(conversationId);

    if (existing is Map<String, dynamic>) {
      final old = Conversation.fromJson(existing);

      final updated = Conversation(
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
