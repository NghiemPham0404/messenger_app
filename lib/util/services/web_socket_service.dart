import 'dart:async';
import 'dart:convert';

import 'package:chatting_app/data/models/message.dart';
import 'package:chatting_app/data/network/api_url_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final ApiUrlProvider apiUrlProvider = ApiUrlProvider();
  bool _isConnected = false;

  late int userId;
  late String token;

  int? _groupId;

  WebSocketService.internal();

  static final WebSocketService _instance = WebSocketService.internal();

  factory WebSocketService() => _instance;

  final StreamController<Message> _messageStreamController =
      StreamController.broadcast();

  Stream<Message> getMessageStream() => _messageStreamController.stream;

  void connect(int userId, String token) {
    this.userId = userId;
    this.token = token;
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

    _channel?.stream.listen(
      (data) {
        debugPrint('[WS] Received: $data');
        var decodedMessage = jsonDecode(data);
        var message = Message.fromJson(decodedMessage);
        _messageStreamController.add(message);
      },
      onDone: () => debugPrint('[WS] Disconnected'),
      onError: (error) => debugPrint('[WS] Error: $error'),
    );
  }

  void joinGroup(int groupId) {
    _groupId = groupId;
    _send({
      "action": "join_group",
      "payload": {"group_id": groupId},
    });
    debugPrint("[WS] join_group");
  }

  void leaveGroup() {
    if (_groupId != null) {
      _send({
        "action": "leave_group",
        "payload": {"group_id": _groupId},
      });
      _groupId = null;
    }
    debugPrint("[WS] leave_group");
  }

  void _send(Map<String, dynamic> data) {
    final jsonData = json.encode(data);
    _channel?.sink.add(jsonData);
    print('[WS] Sent: $jsonData');
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
