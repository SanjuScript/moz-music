import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/CONTROLLER/song_controllers.dart';

Widget repeatButton(BuildContext context, LoopMode loopMode, double wt) {
  final icons = [
    Icon(
      FontAwesomeIcons.repeat,
      size: wt * 0.05,
      color: const Color(0xff9CADC0),
    ),
     Icon(
      FontAwesomeIcons.repeat,
      size: wt * 0.05,
      color:  Colors.deepPurple[400],
    ),
    Icon(
      Icons.repeat_one_rounded,
      size: wt * 0.07,
      color:  Colors.deepPurple[400],
    ),
  ];
  const cycleModes = [
    LoopMode.off,
    LoopMode.all,
    LoopMode.one,
  ];
  final index = cycleModes.indexOf(loopMode);
  return IconButton(
    splashRadius: 30,
    icon: icons[index],
    onPressed: () {
      GetSongs.player.setLoopMode(
          cycleModes[(cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
    },
  );
}