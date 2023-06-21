import 'package:flutter/material.dart';
import 'package:music_player/PROVIDER/theme_class_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../COLORS/colors.dart';

class ChangeThemeButtonWidget extends StatefulWidget {
  const ChangeThemeButtonWidget({super.key});

  @override
  State<ChangeThemeButtonWidget> createState() =>
      _ChangeThemeButtonWidgetState();
}

class _ChangeThemeButtonWidgetState extends State<ChangeThemeButtonWidget> {
  var _darkTheme = true;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _loadTheme() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _darkTheme = (themeProvider.gettheme() == lightThemeMode);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    _darkTheme = (themeProvider.gettheme() == lightThemeMode);

    return IconButton(
      icon: _darkTheme
          ? const Icon(
              Icons.dark_mode,
            )
          : const Icon(Icons.light_mode, color: Colors.white),
      onPressed: () {
        setState(() {
          _darkTheme = !_darkTheme;
        });
        onThemeChanged(_darkTheme, themeProvider);
      },
    );
  }
}

void onThemeChanged(bool value, ThemeProvider themeProvider) async {
  value
      ? themeProvider.seTheme(lightThemeMode)
      : themeProvider.seTheme(darkThemeMode);
  var prefs = await SharedPreferences.getInstance();
  prefs.setBool('darkMode', value);
}
