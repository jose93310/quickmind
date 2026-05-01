import 'package:shared_preferences/shared_preferences.dart';

class SessionStorage {
  static const _keyLoggedIn = 'logged_in';
  static const _keyUserId = 'user_id';
  static const _keyIsGuest = 'is_guest';

  static Future<void> saveSession({
    required String userId,
    required bool isGuest,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, true);
    await prefs.setString(_keyUserId, userId);
    await prefs.setBool(_keyIsGuest, isGuest);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLoggedIn);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyIsGuest);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  static Future<bool> isGuest() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsGuest) ?? false;
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
