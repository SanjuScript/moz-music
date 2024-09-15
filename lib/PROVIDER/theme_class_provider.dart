import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:music_player/COLORS/colors.dart';
import 'package:music_player/DATABASE/storage.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = CustomThemes.lightThemeMode;
  ThemeData getTheme() => _themeData;

  ThemeProvider() {
    ThemeStorageManager.readData('themeMode').then((value) {
      log(
        "Value read from storage : ${value.toString()}",
      );
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        _themeData = CustomThemes.lightThemeMode;
      } else {
        log("Dark Mode setted");
        _themeData = CustomThemes.darkThemeMode;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = CustomThemes.darkThemeMode;
    ThemeStorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }
  
  void setLightMode() async {
    _themeData = CustomThemes.lightThemeMode;
    ThemeStorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }
  
  
}
