import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pulse_chat/features/conversation/domain/usecase/get_socket_message_stream.dart';
import 'package:pulse_chat/features/conversation/presentation/pages/chat_page/change_notifier/chat_history_notifier.dart';

class ChatSocketNotifier extends ChangeNotifier {
  final GetSocketMessageStream _getSocketMessageStream;
  final ChatHistoryNotifier _chatHistoryNotifier;

  StreamSubscription? streamSubscription;

  ChatSocketNotifier({
    required ChatHistoryNotifier chatHistoryNotifier,
    required GetSocketMessageStream getSocketMessageStream,
  }) : _chatHistoryNotifier = chatHistoryNotifier,
       _getSocketMessageStream = getSocketMessageStream;

  void initialize() {
    streamSubscription?.cancel();
    streamSubscription = _getSocketMessageStream().listen((data) {
      debugPrint("[WS] receive");
      _chatHistoryNotifier.updateNewMessage(data);
    });
  }

  @override
  void dispose() {
    super.dispose();
    streamSubscription?.cancel();
  }
}
