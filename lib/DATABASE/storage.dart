import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class MozStorageManager {
  static Future<void> saveData(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is int) {
      prefs.setInt(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else {
      log("invalid");
    }
  }

  static Future<dynamic> readData(String key) async {
    var prefs = await SharedPreferences.getInstance();
    dynamic obj = prefs.get(key);
    return obj;
  }

  static Future<bool> deleteData(String key) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}
