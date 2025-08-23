import 'package:flutter/widgets.dart';

class ChatHeaderNotifier extends ChangeNotifier {
  int otherId;
  String dislayName;
  String? displayAvatar;

  ChatHeaderNotifier({
    required this.otherId,
    required this.dislayName,
    this.displayAvatar,
  });
}
