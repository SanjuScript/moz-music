import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

void customToast(String message, BuildContext context) {
  showToast(message.toUpperCase(),
      textStyle: const TextStyle(
          fontSize: 17,
          fontFamily: "beauti",
          fontWeight: FontWeight.w600,
          color: Color.fromARGB(206, 255, 255, 255)),
      animation: StyledToastAnimation.slideFromTop,
      curve: Curves.easeOutCubic,
      position: const StyledToastPosition(align: Alignment.topCenter),
      alignment: Alignment.topCenter,
      reverseCurve: Curves.easeOutCirc,
      duration: const Duration(seconds: 2),
      animDuration: const Duration(milliseconds: 500),
      context: context,
      backgroundColor: Theme.of(context).primaryColorDark,
      borderRadius: BorderRadius.circular(10),
      reverseAnimation: StyledToastAnimation.slideToTop);
}