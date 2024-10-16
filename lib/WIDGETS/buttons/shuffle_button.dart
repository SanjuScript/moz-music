import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_player/CONTROLLER/song_controllers.dart';
import 'package:music_player/DATABASE/storage.dart';
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
      final newShuffle = !isEnabled;
      await MozController.player.setShuffleModeEnabled(newShuffle);
      await MozStorageManager.saveData('shuffleMode', newShuffle.toString());
    },
  );
}
