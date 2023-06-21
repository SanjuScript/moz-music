import 'package:flutter/material.dart';

import '../buttons/sleep_timer_widget.dart';

void sleepTimerBottomModalSheet(BuildContext context) {
  showModalBottomSheet<void>(
    backgroundColor: Colors.transparent,
      isDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: SleepTimerForMoz());
      });
}
