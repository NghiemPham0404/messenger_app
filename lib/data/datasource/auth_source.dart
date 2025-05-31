
import 'dart:convert';

import 'package:chatting_app/data/models/account.dart';
import 'package:chatting_app/data/response/auth_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String apiUrl = dotenv.env['API_URL'] ?? 'http://192.168.1.15:8000';

class AuthSource {
  Future<AuthResponse?> login(String email, String password) async{
    late AuthResponse authResponse;
    String url = "$apiUrl/auth/token";
    final uri = Uri.parse(url);
    final headers =  {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode(
      {
      'email': email,
      'password': password,
      }
    );
    final response = await http.post(
      uri, 
      headers: headers,
      body: body
    );
    if(response.statusCode==202){
      final bodyContent = utf8.decode(response.bodyBytes);
      debugPrint('login success : $bodyContent');
      authResponse = AuthResponse.fromJson(jsonDecode(bodyContent));
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("access_token", authResponse.accessToken);
      await prefs.setString("refresh_token", authResponse.refreshToken);
      return authResponse;
    }else{
      final bodyContent = utf8.decode(response.bodyBytes);
      debugPrint('login fail : $bodyContent');
      return null;
    }
  }

  Future<UserOut?> getCurrentUser() async{
    String url = "$apiUrl/auth/info";
    final uri = Uri.parse(url);
    final prefs = await SharedPreferences.getInstance();
    final headers =  {
      'Content-Type': 'application/json',
      'Authorization':'Bearer ${prefs.getString("access_token")}'
    };
    final response = await http.get(uri, headers: headers);
    final bodyContent = utf8.decode(response.bodyBytes);
    if(response.statusCode == 200){
      final user = UserOut.fromJson(jsonDecode(bodyContent));
      debugPrint("Current user: ${user.id}");
      return user;
    }else{
      debugPrint('fail get current user : $bodyContent');
      return null;
    }
  }
}