import 'package:flutter/material.dart';
import 'package:music_player/COLORS/colors.dart';
import 'package:music_player/PROVIDER/theme_class_provider.dart';
import 'package:music_player/WIDGETS/buttons/theme_button_widget.dart';
import 'package:music_player/WIDGETS/main_container_for_settings.dart';
import 'package:music_player/WIDGETS/settings_widget/single_items/single_text.dart';
import 'package:provider/provider.dart';

class SettingsThememodeChanging extends StatefulWidget {
  const SettingsThememodeChanging({super.key});

  @override
  State<SettingsThememodeChanging> createState() =>
      _SettingsThememodeChangingState();
}

class _SettingsThememodeChangingState extends State<SettingsThememodeChanging> {
  @override
  Widget build(BuildContext context) {
    bool darkMode = Provider.of<ThemeProvider>(context).theme == CustomThemes.darkThemeMode;
    return SettingsContainer(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        singleTextS(context: context, text: "Theme Mode"),
        Text(
          darkMode ? "DarkMode" : "LightMode",
          style: TextStyle(
            letterSpacing: 1,
            fontFamily: "appollo",
            fontSize: 14,
            color: darkMode ? Colors.grey : Theme.of(context).cardColor,
            fontWeight: FontWeight.bold,
          ),
        ),
       const ChangeThemeButtonWidget(
          changeICon: true,
        ),
      ],
    ));
  }
}
