import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/domain/entities/user.dart';

class LocalAuthSource {
  User? _currentUser;

  void cachedUser(User user) async {
    _currentUser = user;
  }

  User? getCachedUser() {
    return _currentUser;
  }

  // Save token
  void saveToken(String accessToken, String? refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("access_token", accessToken);
    if (refreshToken != null) {
      await prefs.setString("refresh_token", refreshToken);
    }
  }

  // Get token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token");
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("refresh_token");
  }

  // Clear token
  void clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("access_token");
    prefs.remove("refresh_token");
  }

  void logOut() {
    clearToken();
    _currentUser = null;
  }
}
