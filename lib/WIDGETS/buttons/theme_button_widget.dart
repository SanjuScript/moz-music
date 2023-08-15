import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:music_player/PROVIDER/theme_class_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../COLORS/colors.dart';

class ChangeThemeButtonWidget extends StatefulWidget {
  final bool visibility; // Corrected spelling
  const ChangeThemeButtonWidget({Key? key, this.visibility = false}) : super(key: key);

  @override
  State<ChangeThemeButtonWidget> createState() => _ChangeThemeButtonWidgetState();
}

class _ChangeThemeButtonWidgetState extends State<ChangeThemeButtonWidget> {
  late bool _darkTheme;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _loadTheme() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _darkTheme = (themeProvider.gettheme() == lightThemeMode);
  }

  void _toggleTheme(ThemeProvider themeProvider) {
    setState(() {
      _darkTheme = !_darkTheme;
    });
    onThemeChanged(_darkTheme, themeProvider);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    _darkTheme = (themeProvider.gettheme() == lightThemeMode);

    return IconButton(
      icon: Icon(
        _darkTheme ? Icons.dark_mode : Icons.light_mode,
        color: _darkTheme ? Colors.black : Colors.white,
      ),
      onPressed: () => _toggleTheme(themeProvider),
    );
  }

  void onThemeChanged(bool value, ThemeProvider themeProvider) async {
    value ? themeProvider.setTheme(lightThemeMode) : themeProvider.setTheme(darkThemeMode);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', value);
  }
}