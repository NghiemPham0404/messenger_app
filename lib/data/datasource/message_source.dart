import 'dart:convert';
import 'package:chatting_app/data/models/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

String apiUrl = dotenv.env['API_URL'] ?? 'http://192.168.1.15:8000';

class MessageSource {
  
  MessageSource._internal();

  static final MessageSource _instance = MessageSource._internal();

   factory  MessageSource() => _instance;

  // TODO : Send a message of a user to a conversation
  Future<Message?> postMessage(int userId, int conversationId, String content) async{
    // api endpoint
    String url = "$apiUrl/messages/";
    Uri uri = Uri.parse(url);
    // body (message create)
    var body = jsonEncode(
      {"user_id":userId, 
      "conversation_id":conversationId, 
      "content":content}
    );
    // headers with jwt auth
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final prefs = await SharedPreferences.getInstance();
    headers["Authorization"] = 'Bearer ${prefs.getString("access_token")}';

    // response handler
    final response = await http.post(uri, headers: headers, body:  body);
    if(response.statusCode == 200){
      final bodyContent = utf8.decode(response.bodyBytes);
      debugPrint("message create :  $bodyContent");
      final messageResponse = Message.fromJson(jsonDecode(bodyContent));
      return messageResponse;
    }else{
      debugPrint("Post message failed: ${response.statusCode} - ${response.body}");
      return null;
    }
  }

  Future<Message?> putMessage(int messageId, String content) async{
    String url = "$apiUrl/messages/$messageId";
    Uri uri = Uri.parse(url);
    // body (message create)
    var body = jsonEncode(
      {"content":content}
    );
    // headers with jwt auth
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final prefs = await SharedPreferences.getInstance();
    headers["Authorization"] = 'Bearer ${prefs.getString("access_token")}';

    // response handler
    final response = await http.put(uri, headers: headers, body:  body);
    if(response.statusCode == 200){
      final bodyContent = utf8.decode(response.bodyBytes);
      debugPrint("message update :  $bodyContent");
      final messageResponse = Message.fromJson(jsonDecode(bodyContent));
      return messageResponse;
    }else{
      debugPrint("Update message failed: ${response.statusCode} - ${response.body}");
      return null;
    }
  }

  Future<Message?> deleteMessage(int messageId) async{
    String url = "$apiUrl/messages/$messageId";
    Uri uri = Uri.parse(url);
    // body (message create)
    // headers with jwt auth
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final prefs = await SharedPreferences.getInstance();
    headers["Authorization"] = 'Bearer ${prefs.getString("access_token")}';

    // response handler
    final response = await http.delete(uri, headers: headers);
    if(response.statusCode == 200){
      final bodyContent = utf8.decode(response.bodyBytes);
      debugPrint("message update :  $bodyContent");
      final messageResponse = Message.fromJson(jsonDecode(bodyContent));
      return messageResponse;
    }else{
      debugPrint("Update message failed: ${response.statusCode} - ${response.body}");
      return null;
    }
  }

}