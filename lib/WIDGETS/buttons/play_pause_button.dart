import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_player/PROVIDER/now_playing_provider.dart';
import 'package:provider/provider.dart';

Widget playPauseButton(BuildContext context, bool isPlaying, double wt) {
  return InkWell(
    onTap: () async {
      context.read<NowPlayingProvider>().playPauseButtonHere();
    },
    child: ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: [
            Color.fromARGB(255, 148, 101, 228),
            Color.fromARGB(255, 112, 64, 194),
          ],
          tileMode: TileMode.clamp,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcATop,
      child: Icon(
        isPlaying ? FontAwesomeIcons.pause : FontAwesomeIcons.play,
        size: isPlaying ? wt * 0.15 : wt * 0.13,
        shadows: const [
          BoxShadow(
            color: Color.fromARGB(80, 170, 140, 221),
            offset: Offset(2, 2),
            spreadRadius: 5,
            blurRadius: 13,
          ),
          BoxShadow(
            color: Color.fromARGB(92, 202, 202, 202),
            blurRadius: 13,
            spreadRadius: 5,
            offset: Offset(-2, -2),
          ),
        ],
        color: const Color(0xff9CADC0),
      ),
    ),
  );
}
