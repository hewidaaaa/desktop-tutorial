import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static const String timersKey = 'savedTimers';

  // Save a new timer
  static Future<void> saveTimer(Map<String, dynamic> timer) async {
    final prefs = await SharedPreferences.getInstance();
    final timers = await getSavedTimers(); // Get existing timers
    timers.add(timer);
    final encoded = jsonEncode(timers);
    await prefs.setString(timersKey, encoded);
  }

  // Load all saved timers
  static Future<List<Map<String, dynamic>>> getSavedTimers() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(timersKey);
    if (data != null) {
      final List<dynamic> decoded = jsonDecode(data);
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      return [];
    }
  }

  // Clear all (optional for testing)
  static Future<void> clearTimers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(timersKey);
  }
}
