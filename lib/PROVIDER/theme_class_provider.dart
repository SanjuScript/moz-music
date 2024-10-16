import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:music_player/COLORS/colors.dart';
import 'package:music_player/DATABASE/storage.dart';
import 'package:music_player/EXTENSION/capitalizer.dart';

class ThemeProvider extends ChangeNotifier with WidgetsBindingObserver {
  ThemeData _themeData = CustomThemes.lightThemeMode;
  String _themeMode = 'light';

  ThemeData getTheme() => _themeData;

  String getDisplayThemeMode() {
    if (_themeMode == 'system') {
      return 'System Default';
    } else {
      return _themeMode.capitalize();
    }
  }

  ThemeProvider() {
    WidgetsBinding.instance.addObserver(this);

    MozStorageManager.readData('themeMode').then((value) {
      _themeMode = value ?? 'light';
      _setThemeMode(_themeMode);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _setThemeMode(String themeMode) {
    if (themeMode == 'light') {
      _themeData = CustomThemes.lightThemeMode;
    } else if (themeMode == 'dark') {
      _themeData = CustomThemes.darkThemeMode;
    } else if (themeMode == 'system') {
      var brightness = PlatformDispatcher.instance.platformBrightness;
      _themeData = brightness == Brightness.dark
          ? CustomThemes.darkThemeMode
          : CustomThemes.lightThemeMode;
    }

    _themeMode = themeMode;
    notifyListeners();
  }

  void setDarkMode() async {
    _themeData = CustomThemes.darkThemeMode;
    _themeMode = 'dark';
    MozStorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = CustomThemes.lightThemeMode;
    _themeMode = 'light';
    MozStorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }

  void setSystemMode() async {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    _themeData = brightness == Brightness.dark
        ? CustomThemes.darkThemeMode
        : CustomThemes.lightThemeMode;
    _themeMode = 'system';
    MozStorageManager.saveData('themeMode', 'system');
    notifyListeners();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    MozStorageManager.readData('themeMode').then((themeMode) {
      if (themeMode == 'system') {
        var brightness = PlatformDispatcher.instance.platformBrightness;
        _themeData = brightness == Brightness.dark
            ? CustomThemes.darkThemeMode
            : CustomThemes.lightThemeMode;
        notifyListeners();
      }
    });
  }
}
