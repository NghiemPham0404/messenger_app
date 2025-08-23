import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pulse_chat/features/conversation/domain/usecase/conect_to_socket.dart';
import 'package:pulse_chat/features/conversation/domain/usecase/disconect_from_socket.dart';
import 'package:pulse_chat/features/conversation/domain/usecase/get_socket_message_stream.dart';
import 'package:pulse_chat/features/conversation/presentation/pages/conversation_page/change_notifier/conversation_notifier.dart';

class ConversationSocketNotifier extends ChangeNotifier {
  final GetSocketMessageStream _getSocketConversationStream;
  final ConnectToSocket _conectToSocket;

  final DisconectFromSocket _disconectFromSocket;
  final ConversationNotifier _conversationNotifier;

  StreamSubscription? streamSubscription;

  ConversationSocketNotifier({
    required GetSocketMessageStream getSocketConversationStream,
    required ConversationNotifier conversationNotifier,
    required ConnectToSocket conectToSocket,
    required DisconectFromSocket disconectFromSocket,
  }) : _getSocketConversationStream = getSocketConversationStream,
       _conectToSocket = conectToSocket,
       _disconectFromSocket = disconectFromSocket,
       _conversationNotifier = conversationNotifier;

  void initialize() {
    connectToSocket();
    streamSubscription?.cancel();
    streamSubscription = _getSocketConversationStream().listen((data) {
      debugPrint("[WS] receive conversation");
      final conversation = data.toConversation();
      _conversationNotifier.updateNewcomingConversation(conversation);
      _conversationNotifier.notifyListeners();
    });
  }

  void connectToSocket() async {
    try {
      _conectToSocket();
    } catch (e) {
      debugPrint("[Connect to socket] : $e");
    }
  }

  void disconnectFromSocket() async {
    try {
      _disconectFromSocket();
    } catch (e) {
      debugPrint("[Connect to socket] : $e");
    }
  }

  Stream get messageStream => _getSocketConversationStream();

  @override
  void dispose() {
    super.dispose();
    streamSubscription?.cancel();
  }
}
