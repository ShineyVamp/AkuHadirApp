import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyToken = 'auth_token';
  static const String _keyUser = 'user_data';
  static const String _keyTheme = 'is_dark_mode';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> saveToken(String token) async {
    await _prefs?.setString(_keyToken, token);
  }

  static String? getToken() {
    return _prefs?.getString(_keyToken);
  }

  static Future<void> clearToken() async {
    await _prefs?.remove(_keyToken);
  }

  static Future<void> saveUserData(String jsonString) async {
    await _prefs?.setString(_keyUser, jsonString);
  }

  static String? getUserData() {
    return _prefs?.getString(_keyUser);
  }

  static Future<void> clearUserData() async {
    await _prefs?.remove(_keyUser);
  }

  static Future<void> setIsDarkMode(bool isDark) async {
    await _prefs?.setBool(_keyTheme, isDark);
  }

  static bool getIsDarkMode() {
    return _prefs?.getBool(_keyTheme) ?? false;
  }

  static Future<void> saveTodayAttendance(String date, String jsonString) async {
    await _prefs?.setString('today_attendance_$date', jsonString);
  }

  static String? getTodayAttendance(String date) {
    return _prefs?.getString('today_attendance_$date');
  }

  static Future<void> clearTodayAttendance(String date) async {
    await _prefs?.remove('today_attendance_$date');
  }

  static Future<void> saveHistory(String monthKey, String jsonString) async {
    await _prefs?.setString('history_$monthKey', jsonString);
  }

  static String? getHistory(String monthKey) {
    return _prefs?.getString('history_$monthKey');
  }

  static Future<void> clearAll() async {
    await _prefs?.remove(_keyToken);
    await _prefs?.remove(_keyUser);
  }
}
