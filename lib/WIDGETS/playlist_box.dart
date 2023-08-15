import 'package:flutter/material.dart';
import 'package:music_player/WIDGETS/song_list_maker.dart';

class PlaylistCreationBox extends StatelessWidget {
  final Widget artwork;
  final String songCount;
  final String text;
  final bool isArtworkAvailable;
  const PlaylistCreationBox(
      {super.key,
      required this.artwork,
      required this.text,
      this.isArtworkAvailable = false,
      required this.songCount});

  @override
  Widget build(BuildContext context) {
    return SongListViewer(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      borderradius: const BorderRadius.all(Radius.circular(10)),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.18,
              //  width: MediaQuery.sizeOf(context).width * 0.23,
              child: artwork,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              songCount,
              style: TextStyle(
                  fontFamily: 'coolvetica',
                  letterSpacing: 1,
                  fontSize: 11,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).cardColor),
            ),
          ),
          _showText(text,
              context: context,
              fontWeight:
                  isArtworkAvailable ? FontWeight.w500 : FontWeight.w400)
        ],
      ),
    );
  }
}

Widget _showText(String text,
    {required FontWeight fontWeight, required BuildContext context}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Text(
      text,
      style: TextStyle(
          fontFamily: 'coolvetica',
          fontSize: MediaQuery.of(context).size.height * 0.020,
          letterSpacing: 1.5,
          overflow: TextOverflow.ellipsis,
          fontWeight: fontWeight,
          color: Theme.of(context).cardColor),
    ),
  );
}
