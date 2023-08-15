import 'dart:async';
import 'package:flutter/material.dart';

class ColorProvider with ChangeNotifier {
  List<Color> customColors = [
    Color.fromARGB(255, 27, 7, 7),
    Color.fromARGB(255, 24, 27, 7),
    Color.fromARGB(255, 13, 27, 7),
    Color.fromARGB(255, 7, 27, 27),
    Color.fromARGB(255, 7, 8, 27),
    Color.fromARGB(255, 19, 7, 27),
    Color.fromARGB(255, 27, 7, 13),
    Color.fromARGB(255, 7, 27, 17),
    // Add more colors here
  ];
  int _currentColorIndex = 0;
  Timer? _colorChangeTimer;

  Color get currentColor => customColors[_currentColorIndex];

  void startColorChangeTimer() {
    _colorChangeTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      _currentColorIndex = (_currentColorIndex + 1) % customColors.length;
      notifyListeners();
      _colorChangeTimer?.cancel();
      startColorChangeTimer();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _colorChangeTimer?.cancel();
  }
}
