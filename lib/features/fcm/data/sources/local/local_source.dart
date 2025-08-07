import 'package:shared_preferences/shared_preferences.dart';

class LocalFCMDatasource {
  void updateFCMToken(String token) async {
    deleteFCMToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("fcm_token", token);
  }

  Future<String?> getFCMToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("fcm_token");
    return token;
  }

  void deleteFCMToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("fcm_token");
  }
}
