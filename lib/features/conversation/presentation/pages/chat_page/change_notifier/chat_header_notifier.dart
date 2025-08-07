import 'package:flutter/widgets.dart';
import 'package:pulse_chat/features/conversation/domain/entities/conversation.dart';

class ChatHeaderNotifier extends ChangeNotifier {
  final Conversation conversation;

  ChatHeaderNotifier({required this.conversation});
}
