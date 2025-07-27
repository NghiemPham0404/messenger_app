// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   debugPrint("[receive fcm] $message");
//   // final data = message.data;
//   // final msg = Message.fromJson(data);

//   LocalNotificationService.showNotification(
//     id: 1,
//     title: 'text',
//     body: 'You got a message!',
//   );

//   // ConversationServiceLocal().updateConversation(msg);
//   // LocalNotificationService.showNotification(
//   //   id: msg.userId,
//   //   title: 'New Message',
//   //   body: msg.content ?? 'You got a message!',
//   // );
// }

import 'dart:convert';

import 'package:chatting_app/data/models/message.dart';
import 'package:chatting_app/data/services/conversation_service_local.dart';
import 'package:chatting_app/util/local_notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Message handleMessage(RemoteMessage message) {
  final rawJson = message.data['message'];
  final Map<String, dynamic> json = jsonDecode(rawJson);

  final msg = Message.fromJson(json);

  ConversationServiceLocal().updateConversation(msg);

  debugPrint("--- Handling a background message: ${message.messageId} ---");
  debugPrint("Data: $msg");

  return msg;
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  await LocalNotificationService.initialize();

  if (message.data['type'] == "chat_message") {
    final msg = handleMessage(message);

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
}
