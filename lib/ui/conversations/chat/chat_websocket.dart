import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatWebSocket {
  late WebSocketChannel channel;

  final String websocketUrl =  dotenv.env['WEBSOCKET_URL'] ?? 'ws://192.168.1.15:8000/ws';
  

  Future<void> init(int conversationId, int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");
    debugPrint("websocket url + $websocketUrl");
    if (token == null) {
      throw Exception("JWT not found in SharedPreferences.");
    }else{
      debugPrint(token);
    }

    final uri = Uri.parse('$websocketUrl/$conversationId/$userId');

    channel = IOWebSocketChannel.connect(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  void sendMessage(String message) {
    channel.sink.add(message);
  }

  Stream<String> get messageStream => channel.stream.cast<String>();
}