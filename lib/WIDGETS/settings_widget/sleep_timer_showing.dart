import 'package:flutter/material.dart';
import 'package:music_player/WIDGETS/bottomsheet/sleep_timer_sheet.dart';
import 'package:music_player/WIDGETS/main_container_for_settings.dart';
import 'package:music_player/WIDGETS/settings_widget/single_items/single_text.dart';
import 'package:provider/provider.dart';

import '../../PROVIDER/sleep_timer_provider.dart';

class SleepTimerShowing extends StatelessWidget {
  const SleepTimerShowing({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsContainer(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        singleTextS(context: context, text: 'Sleep Timer'),
        Consumer<SleepTimeProvider>(
          builder: (context, value, child) {
            if (value.remainingTime > 0) {
              return singleTextS(
                context: context,
                text: value.remainingTime.toString(),
              );
            } else {
              return InkWell(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                  onTap: () {
                    sleepTimerBottomModalSheet(context);
                  },
                  child: singleTextS(context: context, text: 'Set Timer'));
            }
          },
        ),
        SizedBox(
          height: 20,
        )
      ],
    ));
  }
}
