import 'dart:convert';

import 'package:pulse_chat/features/notification/local_notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pulse_chat/features/conversation/data/model/message_model.dart';
import 'package:pulse_chat/features/conversation/data/source/local/local_conversation_source.dart';

MessageModel handleMessage(RemoteMessage message) {
  final rawJson = message.data['message'];
  final Map<String, dynamic> json = jsonDecode(rawJson);

  final msg = MessageModel.fromJson(json);

  debugPrint("--- Handling a background message: ${message.messageId} ---");
  debugPrint("Data: $msg");

  return msg;
}

Future<void> showNotification(MessageModel msg) async {
  await LocalNotificationService.showNotification(
    id: DateTime.now().millisecondsSinceEpoch.toSigned(31),
    title: msg.sender.name,
    body:
        msg.content ??
        ((msg.file != null)
            ? "${msg.sender.name} have sent attachments"
            : "${msg.sender.name} have sent photos"),
  );
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("[FCM receive] receive FCM successful");
  await Firebase.initializeApp();

  await LocalNotificationService.initialize();

  if (message.data['type'] == "chat_message") {
    final msg = handleMessage(message);

    LocalConversationSource().updateConversation(msg.toConversationModel());

    await showNotification(msg);
  }
}

Future<void> firebaseMessagingForegroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.data['type'] == "chat_message") {
    final msg = handleMessage(message);

    LocalConversationSource().updateConversation(msg.toConversationModel());
  }
}
