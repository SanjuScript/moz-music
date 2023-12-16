import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:music_player/PROVIDER/device_info_provider.dart';
import 'package:music_player/WIDGETS/main_container_for_settings.dart';
import 'package:music_player/WIDGETS/settings_widget/single_items/single_text.dart';
import 'package:music_player/WIDGETS/settings_widget/single_items/single_version.dart';
import 'package:provider/provider.dart';

class SettingsAboutShowing extends StatefulWidget {
  const SettingsAboutShowing({super.key});

  @override
  State<SettingsAboutShowing> createState() => _SettingsAboutShowingState();
}

class _SettingsAboutShowingState extends State<SettingsAboutShowing> {
  @override
  Widget build(BuildContext context) {
    return SettingsContainer(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        singleTextS(context: context, text: 'About'),
        FutureBuilder<AndroidDeviceInfo>(
          future: Provider.of<DeviceInformationProvider>(context)
              .getAndroidDeviceInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            } else if (snapshot.hasError) {
              print("Error loading data: ${snapshot.error}");
              return Text('');
            } else {
              final AndroidDeviceInfo androidInfo = snapshot.data!;
              return singleTextS(
                size: 43,
                  text: androidInfo.version.release,
                  context: context);
            }
          },
        ),
        SizedBox(height: 30,)
        // singleTexts2(text: " App version : $appVersion", context: context),
      ],
    ));
  }
}
