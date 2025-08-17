import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static final SessionManager instance = SessionManager._();
  SessionManager._();

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_logged_in');
    await prefs.remove('token');
  }
}
