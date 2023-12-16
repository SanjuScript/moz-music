import 'package:flutter/material.dart';

Widget singleTextS(
    {required BuildContext context, double size = 23, required String text}) {
  return Text(
    text,
    style: TextStyle(
        shadows: const [
          BoxShadow(
            color: Color.fromARGB(90, 63, 63, 63),
            blurRadius: 15,
            offset: Offset(-2, 2),
          ),
        ],
        fontSize: size,
        fontFamily: 'rounder',
        letterSpacing: 1,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).cardColor),
  );
}

Widget singleTexts2(
    {required String text,
    required BuildContext context,
    double spacing = 1,
    double size = 14,
    bool isdark = false}) {
  return Text(
    text,
    style: TextStyle(
      letterSpacing: spacing,
      fontFamily: "appollo",
      fontSize: size,
      color: isdark ? Colors.grey : Theme.of(context).cardColor,
      fontWeight: FontWeight.bold,
    ),
  );
}
