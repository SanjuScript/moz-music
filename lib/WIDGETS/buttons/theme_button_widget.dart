import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:music_player/PROVIDER/theme_class_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../COLORS/colors.dart';

class ChangeThemeButtonWidget extends StatefulWidget {
  final bool visiblity;
  const ChangeThemeButtonWidget({super.key, this.visiblity = false});

  @override
  State<ChangeThemeButtonWidget> createState() =>
      _ChangeThemeButtonWidgetState();
}

class _ChangeThemeButtonWidgetState extends State<ChangeThemeButtonWidget> {
  var _darkTheme = true;
  Color dynamicShadowColor =
      const Color.fromARGB(255, 2, 212, 65); // Default dynamic shadow color
  void _loadShadowColor() async {
    final prefs = await SharedPreferences.getInstance();
    final shadowColorValue = prefs.getInt('shadowColorValue');
    if (shadowColorValue != null) {
      setState(() {
        dynamicShadowColor = Color(shadowColorValue);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _loadShadowColor();
  }

  void _loadTheme() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _darkTheme = (themeProvider.gettheme() == lightThemeMode);
    final prefs = await SharedPreferences.getInstance();
    final shadowColorValue = prefs.getInt('shadowColorValue');
    if (shadowColorValue != null) {
      setState(() {
        dynamicShadowColor = Color(shadowColorValue);
      });
    }
  }

  void _saveShadowColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('shadowColorValue', color.value);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    _darkTheme = (themeProvider.gettheme() == lightThemeMode);
    if (!_darkTheme) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: _darkTheme
                  ? const Icon(
                      Icons.dark_mode,
                    )
                  : const Icon(Icons.light_mode, color: Colors.white),
              onPressed: () {
                setState(() {
                  _darkTheme = !_darkTheme;
                });
                onThemeChanged(_darkTheme, themeProvider, dynamicShadowColor);
              },
            ),
            IconButton(
              onPressed: () async {
                final Color pickedColor = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Pick a shadow color'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          hexInputBar: true,
                          labelTextStyle: const TextStyle(
                            color:Colors.white
                          ),
                         
                          pickerColor: dynamicShadowColor,
                          onColorChanged: (Color color) {
                            setState(() {
                              dynamicShadowColor = color;
                            });
                          },
                          // ignore: deprecated_member_use
                          showLabel: true,
                          pickerAreaHeightPercent: 0.8,
                        ),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(dynamicShadowColor);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );

                setState(() {
                  dynamicShadowColor = pickedColor;
                });
                _saveShadowColor(dynamicShadowColor);
                onThemeChanged(_darkTheme, themeProvider, dynamicShadowColor);
              },
              icon: Icon(
                Icons.color_lens,
                color: dynamicShadowColor,
              ),
            )
          ],
        ),
      );
    } else {
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
          onThemeChanged(_darkTheme, themeProvider, dynamicShadowColor);
        },
      );
    }
  }

  void onThemeChanged(
      bool value, ThemeProvider themeProvider, Color dynamicShadowColor) async {
    value
        ? themeProvider.seTheme(lightThemeMode)
        : themeProvider.seTheme(darkThemeMode.copyWith(
            shadowColor: dynamicShadowColor, // Set the dynamic shadow color
          ));
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', value);
  }
}
