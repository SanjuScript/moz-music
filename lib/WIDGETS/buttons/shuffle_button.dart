import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_player/CONTROLLER/song_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget shuffleButton(BuildContext context, bool isEnabled, double wt) {
  return IconButton(
    splashRadius: 30,
    icon: isEnabled
        ? Icon(
            FontAwesomeIcons.shuffle,
            size: wt * 0.06,
            color: Colors.deepPurple[400],
          )
        : Icon(
            FontAwesomeIcons.shuffle,
            size: wt * 0.06,
            color: const Color(0xff333c67),
          ),
    onPressed: () async {
      final enable = !isEnabled;
      if (enable) {
        await GetSongs.player.shuffle();
      }
      await GetSongs.player.setShuffleModeEnabled(enable);

      // Save shuffle mode state in SharedPreferences
      // await saveShuffleModeState(en);
    },
  );
}

// Function to save shuffle mode state in SharedPreferences
Future<void> saveShuffleModeState(bool enable) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('shuffleModeEnabled', enable);
}