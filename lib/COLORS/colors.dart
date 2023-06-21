import 'package:flutter/material.dart';

final lightThemeMode = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.grey[300],
    primaryColorDark: Colors.deepPurple[400],
    primaryColorLight: const Color.fromARGB(255, 170, 187, 185),
    shadowColor: const Color.fromARGB(255, 158, 158, 158),
    dividerColor: Colors.white,
    cardColor: const Color.fromARGB(255, 27, 25, 25),
    hintColor: Colors.white,
    highlightColor: const Color.fromARGB(255, 179, 178, 178),
    canvasColor: Colors.green,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[300],
    ));

final darkThemeMode = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xff1F1F1F),
    primaryColorDark: Colors.deepPurple[400],
    primaryColorLight: const Color.fromARGB(255, 99, 158, 151),
    shadowColor: const Color.fromARGB(255, 6, 8, 10),
    dividerColor: const Color(0xff363636),
    cardColor: const Color.fromARGB(255, 228, 229, 229),
    hintColor: const Color.fromARGB(255, 46, 53, 53),
    highlightColor: const Color.fromARGB(255, 47, 62, 83),
    
    dialogTheme: const DialogTheme(
      backgroundColor: Color(0xFF1F1F1F),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: TextStyle(
        color: Colors.white,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff1F1F1F),
    ));
