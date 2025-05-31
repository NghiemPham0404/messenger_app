import 'dart:convert';
import 'package:chatting_app/data/models/conversation.dart';
import 'package:chatting_app/data/models/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

String apiUrl = dotenv.env['API_URL'] ?? 'http://192.168.1.15:8000';

class ConversationSource {

  ConversationSource._internal();

  static final ConversationSource _instance = ConversationSource._internal();

  factory ConversationSource(){
    return _instance;
  }

  
  Future<List<Conversation>> getUserConversations() async {
    Map<String, String> headers = {};
    await getAuthHeader().then((data){headers =data;});

    final uri = Uri.parse("$apiUrl/users/conversations");
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final bodyContent = utf8.decode(response.bodyBytes);
      debugPrint(bodyContent);

      final List<dynamic> data = jsonDecode(bodyContent);
      return data.map((e) => Conversation.fromJson(e)).toList();
    } else {
      debugPrint("Failed to fetch conversations: ${response.statusCode}");
      return [];
    }
  }

  Future<List<Message>> getConversationMessages(int conversationId) async{
    Map<String, String> headers = {};
    await getAuthHeader().then((data){headers =data;});

    final uri = Uri.parse("$apiUrl/conversations/$conversationId/messages");
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final bodyContent = utf8.decode(response.bodyBytes);
      debugPrint(bodyContent);

      final List<dynamic> data = jsonDecode(bodyContent);
      return data.map((message) => Message.fromJson(message)).toList();
    } else {
      debugPrint("Failed to fetch conversations: ${response.statusCode}");
      return [];
    }
  }

  Future<Map<String, String>> getAuthHeader() async{
    final prefs = await SharedPreferences.getInstance();
    final headers = <String, String>{};
    headers["Authorization"] = "Bearer ${prefs.getString("access_token")}";
    return headers;
  }
}