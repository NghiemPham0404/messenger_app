import 'package:pulse_chat/features/conversation/domain/entities/message.dart';

abstract class SocketRepository {
  Stream<Message> getMessageStream();

  void connectToSoket();

  void disconnectFromSoket();
}
