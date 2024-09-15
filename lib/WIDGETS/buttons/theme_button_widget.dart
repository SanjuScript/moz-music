import 'package:flutter/material.dart';
import 'package:music_player/PROVIDER/theme_class_provider.dart';
import 'package:provider/provider.dart';
import '../../COLORS/colors.dart';

class ChangeThemeButtonWidget extends StatefulWidget {
  final bool visibility; // Corrected spelling
  final bool changeICon;
  const ChangeThemeButtonWidget({
    Key? key,
    this.visibility = false,
    this.changeICon = false,
  }) : super(key: key);

  @override
  State<ChangeThemeButtonWidget> createState() =>
      _ChangeThemeButtonWidgetState();
}

class _ChangeThemeButtonWidgetState extends State<ChangeThemeButtonWidget> {
  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _loadTheme() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final theme = (themeProvider.getTheme());
  }

  void _toggleTheme(ThemeProvider themeProvider) {
    if (themeProvider.getTheme() == CustomThemes.darkThemeMode) {
      themeProvider.setLightMode();
    } else {
      themeProvider.setDarkMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final darkTheme = (themeProvider.getTheme() == CustomThemes.lightThemeMode);
    if (widget.changeICon) {
      return Switch(
        value: darkTheme,
        onChanged: (value) {
          _toggleTheme(themeProvider);
        },
        // activeColor: Colors.black,
        // activeTrackColor: Colors.grey[300],
        // inactiveThumbColor: Colors.white,
        // inactiveTrackColor: Colors.grey[700],
      );
    } else {
      return IconButton(
        icon: Icon(
          darkTheme ? Icons.dark_mode : Icons.light_mode,
          color: darkTheme ? Colors.black : Colors.white,
        ),
        onPressed: () => _toggleTheme(themeProvider),
      );
    }
  }
}
