import 'dart:convert';

import 'package:chatting_app/data/models/message.dart';
import 'package:chatting_app/data/services/conversation_service_local.dart';
import 'package:chatting_app/util/services/local_notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Message handleMessage(RemoteMessage message) {
  final rawJson = message.data['message'];
  final Map<String, dynamic> json = jsonDecode(rawJson);

  final msg = Message.fromJson(json);

  debugPrint("--- Handling a background message: ${message.messageId} ---");
  debugPrint("Data: $msg");

  return msg;
}

Future<void> showNotification(Message msg) async {
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

    ConversationServiceLocal().updateConversation(msg);

    await showNotification(msg);
  }
}
