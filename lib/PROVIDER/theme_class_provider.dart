import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;
  ThemeProvider(this._themeData);
  gettheme() => _themeData;
  seTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }
}
