import 'dart:async';
import 'dart:convert';

import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:pulse_chat/core/network/api_url_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:pulse_chat/features/conversation/data/model/message_model.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketService({required LocalAuthSource localAuthSource})
    : _localAuthSource = localAuthSource;
  // DEPENDENCY -----------------------------------------------------------------------------
  final LocalAuthSource _localAuthSource;

  // PROPERTIES  -----------------------------------------------------------------------------
  WebSocketChannel? _channel;
  final ApiUrlProvider apiUrlProvider = ApiUrlProvider();
  bool _isConnected = false;

  late int userId;
  late String token;

  final StreamController<MessageModel> _messageStreamController =
      StreamController.broadcast();

  Stream<MessageModel> getMessageStream() => _messageStreamController.stream;

  // METHODS  -----------------------------------------------------------------------------
  void connect() async {
    userId = _localAuthSource.getCachedUser()?.id ?? 0;
    token = await _localAuthSource.getToken() ?? "";

    if (_isConnected) {
      debugPrint("[WS] zombie websocket");
    } else {
      debugPrint("[WS] websocket url: ${apiUrlProvider.baseWebsocket}/$userId");
    }

    final uri = Uri.parse('${apiUrlProvider.baseWebsocket}/$userId');

    _channel = IOWebSocketChannel.connect(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (_channel != null) {
      _isConnected = true;
    }

    _channel?.stream.listen(
      (data) {
        debugPrint('[WS] Received: $data');
        var decodedMessage = jsonDecode(data);
        var message = MessageModel.fromJson(decodedMessage);
        _messageStreamController.add(message);
      },
      onDone: () => debugPrint('[WS] Disconnected'),
      onError: (error) => debugPrint('[WS] Error: $error'),
    );
  }

  void disconnect() {
    if (_channel != null) {
      _channel?.sink.close();
      _channel = null;
      _isConnected = false;
      debugPrint("[WS] disconnect");
    }
  }
}
