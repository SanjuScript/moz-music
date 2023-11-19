// import 'dart:async';
// import 'package:flutter/material.dart';

// class ColorProvider with ChangeNotifier {
//   List<Color> customColors = const [
//     Color.fromARGB(255, 27, 7, 7),
//     Color.fromARGB(255, 24, 27, 7),
//     Color.fromARGB(255, 13, 27, 7),
//     Color.fromARGB(255, 7, 27, 27),
//     Color.fromARGB(255, 7, 8, 27),
//     Color.fromARGB(255, 19, 7, 27),
//     Color.fromARGB(255, 27, 7, 13),
//     Color.fromARGB(255, 7, 27, 17),
//   ];
//   int _currentColorIndex = 0;
//   Timer? _colorChangeTimer;
//   bool _disposed = false;

//   Color get currentColor => customColors[_currentColorIndex];

//  void startColorChangeTimer() {
//   if (_disposed) return; // Check if disposed before starting the timer

//   _colorChangeTimer = Timer.periodic(Duration(seconds: 30), (timer) {
//     if (_disposed) {
//       timer.cancel(); // Cancel the timer if disposed
//     } else {
//       _currentColorIndex = (_currentColorIndex + 1) % customColors.length;
//       notifyListeners();
//     }
//   });
  
// }


//   @override
//   void dispose() {
//     super.dispose();
//     _disposed = true; // Set the disposed flag
//     _colorChangeTimer?.cancel();
//   }
// }
