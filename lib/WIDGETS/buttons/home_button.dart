import 'package:flutter/material.dart';
import 'package:music_player/PROVIDER/now_playing_provider.dart';
import 'package:provider/provider.dart';

Widget homeButton(BuildContext context,double wt) {
  return IconButton(
    splashRadius: 30,
      onPressed: () {
        Navigator.pop(context);
        context.read<NowPlayingProvider>().willPopHere();
      },
      icon: Icon(
        Icons.home_rounded,
        color: const Color(0xff333c67),
        size: wt * 0.07,
      ));
}
