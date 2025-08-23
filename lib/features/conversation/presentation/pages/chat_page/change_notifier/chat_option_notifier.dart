import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pulse_chat/features/conversation/domain/entities/message_update.dart';
import 'package:pulse_chat/features/conversation/domain/usecase/delete_message.dart';
import 'package:pulse_chat/features/conversation/domain/usecase/update_message.dart';
import 'package:pulse_chat/features/conversation/presentation/pages/chat_page/change_notifier/chat_history_notifier.dart';

class ChatOptionNotifier extends ChangeNotifier {
  final ChatHistoryNotifier _chatHistoryNotifier;
  final UpdateMessage _updateMessage;
  final DeleteMessage _deleteMessage;

  ChatOptionNotifier({
    required ChatHistoryNotifier chatHistoryNotifier,
    required UpdateMessage updateMessage,
    required DeleteMessage deleteMessage,
  }) : _chatHistoryNotifier = chatHistoryNotifier,
       _updateMessage = updateMessage,
       _deleteMessage = deleteMessage;

  void editSentMessage({
    required String messageId,
    required String updateTextContent,
  }) async {
    try {
      final updatedMessage = MessageUpdate(content: updateTextContent);
      final res = await _updateMessage(messageId, updatedMessage);

      final index = _chatHistoryNotifier.messages.indexWhere(
        (message) => message.id == messageId,
      );
      if (index != -1) {
        _chatHistoryNotifier.messages[index].content = res.result.content!;
      }
    } on DioException catch (e) {
      debugPrint("[Update Message] detail : ${e.response!.data["detail"]}");
      _chatHistoryNotifier.setError("can't update message");
    } catch (e) {
      debugPrint("[Update Message] detail : $e");
    } finally {
      _chatHistoryNotifier.notifyListeners();
    }
  }

  void deleteMessage(String messageId) async {
    debugPrint("[Delete Message] id = $messageId");
    try {
      await _deleteMessage(messageId);
      _chatHistoryNotifier.messages.removeWhere(
        (element) => element.id == messageId,
      );
    } on DioException catch (e) {
      debugPrint("[Delete Message] detail : ${e.response!.data["detail"]}");
      _chatHistoryNotifier.setError(e.response!.data["detail"]);
    } catch (e) {
      debugPrint("[Delete Message] detail : $e");
    } finally {
      _chatHistoryNotifier.notifyListeners();
    }
  }
}
