import 'dart:ui';
import 'package:flutter/material.dart';
import '../buttons/sleep_timer_widget.dart';

void sleepTimerBottomModalSheet(BuildContext context) {
  showModalBottomSheet<void>(
    backgroundColor: Colors.transparent,
    isDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).splashColor.withOpacity(0.8),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: const SleepTimerForMoz(),
          ),
        ),
      );
    },
  );
}
