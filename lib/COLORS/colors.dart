import 'package:flutter/material.dart';

import '../main.dart';

final lightThemeMode = ThemeData(
  useMaterial3: true,
  indicatorColor: Color(0xffE7EAF3),
  scaffoldBackgroundColor: Color(0xffffffff),
  shadowColor: Color.fromARGB(163, 216, 215, 215),
  dividerColor: Colors.white,
  cardColor: const Color(0xff333c67),
  hintColor: const Color(0xff333c67),
  // hoverColor: Colors.white,
  splashColor:  Color.fromARGB(255, 255, 255, 255),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey[300],
  ),
  unselectedWidgetColor: const Color(0xff333c67),
  secondaryHeaderColor: Color(0xffD0D2E7),
  focusColor: Color.fromARGB(255, 225, 213, 244),
  highlightColor: Color.fromARGB(255, 232, 225, 244),
  canvasColor: Color.fromARGB(255, 232, 225, 244),
  primaryColorDark:  Color.fromARGB(160, 94, 53, 177),
  primaryColorLight: Color.fromARGB(114, 179, 157, 219),
);

final darkThemeMode = ThemeData(
  useMaterial3: true,
   primaryColorDark:  Color.fromARGB(159, 28, 15, 56),
    primaryColorLight:  Color.fromARGB(113, 31, 17, 57),
  highlightColor: Color.fromARGB(255, 57, 54, 62),
  canvasColor: Color.fromARGB(255, 59, 55, 64),
  focusColor: Color.fromARGB(255, 47, 45, 50),
  unselectedWidgetColor: Color.fromARGB(255, 166, 166, 166),
  indicatorColor: Color(0xff343434),
  scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
 hintColor:  const Color.fromARGB(255, 228, 229, 229),
 
  shadowColor: Color.fromARGB(0, 0, 0, 0), // Use the dynamic shadow color variable
  dividerColor: Color.fromARGB(41, 202, 202, 202),
  cardColor: const Color.fromARGB(255, 228, 229, 229),
  // hintColor: const Color.fromARGB(255, 46, 53, 53),

  // hoverColor: Colors.black,
  splashColor: const Color.fromARGB(255, 39, 39, 39),
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
  secondaryHeaderColor: Color(0xffbbbbbb),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xff1F1F1F),
  ),
);

    //greem Color.fromARGB(255, 2, 212, 65),
    //blue  Color.fromARGB(255, 2, 75, 212),