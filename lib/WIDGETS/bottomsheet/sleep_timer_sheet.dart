import 'package:flutter/material.dart';

import '../buttons/sleep_timer_widget.dart';

void sleepTimerBottomModalSheet(BuildContext context) {
  showModalBottomSheet<void>(
    backgroundColor: Theme.of(context).splashColor,
      isDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color:Theme.of(context).splashColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: const SleepTimerForMoz());
      });
}
