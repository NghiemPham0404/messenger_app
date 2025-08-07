import 'package:pulse_chat/features/conversation/data/source/websocket/web_socket_service.dart';
import 'package:pulse_chat/features/conversation/domain/entities/message.dart';
import 'package:pulse_chat/features/conversation/domain/repositories/socket_repo.dart';

class WebsocketRepoImpl implements SocketRepository {
  final WebSocketService _webSocketService;

  WebsocketRepoImpl({required WebSocketService webSocketService})
    : _webSocketService = webSocketService;

  @override
  void connectToSoket() {
    _webSocketService.connect();
  }

  @override
  void disconnectFromSoket() {
    _webSocketService.disconnect();
  }

  @override
  Stream<Message> getMessageStream() {
    return _webSocketService.getMessageStream();
  }
}
