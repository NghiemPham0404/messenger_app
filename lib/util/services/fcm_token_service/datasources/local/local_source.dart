import 'dart:convert';

import 'package:chatting_app/util/services/fcm_token_service/models/fcm_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalFCMDatasource {
  void updateFCMToken(FCMTokenModel fcmTokenModel) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("fcm_token");
    await prefs.setString("fcm_token", jsonEncode(fcmTokenModel.toJson()));
  }

  Future<FCMTokenModel?> getFCMToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? tokenModelRaw = prefs.getString("fcm_token");
    return tokenModelRaw == null
        ? null
        : FCMTokenModel.fromJson(jsonDecode(tokenModelRaw));
  }
}
