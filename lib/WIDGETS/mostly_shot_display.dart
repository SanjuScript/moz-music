import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/WIDGETS/audio_for_others.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:palette_generator/palette_generator.dart';
import '../CONTROLLER/song_controllers.dart';
import '../DATABASE/most_played.dart';
import '../DATABASE/recently_played.dart';
import '../HELPER/artist_helper.dart';
import '../SCREENS/main_music_playing_screen.dart.dart';
import 'audio_artwork_definer.dart';

class MostlyShotDisplay extends StatefulWidget {
  const MostlyShotDisplay({super.key});

  @override
  State<MostlyShotDisplay> createState() => _MostlyShotDisplayState();
}

class _MostlyShotDisplayState extends State<MostlyShotDisplay> {
  List<SongModel> _mostlyPlayedSongs = [];

  final int itemsPerview = 3;

 Future<void> _fetchMostlyPlayedSongs() async {
  List<String> mostPlayedSongIds = PlayCountService.getMostPlayedSongIds();
  List<SongModel> songs = await OnAudioQuery().querySongs();

  // Filter and sort songs based on play counts
  List<SongModel> mostlyPlayedSongs = songs.where((song) {
    return mostPlayedSongIds.contains(song.id.toString());
  }).toList();

  // Sort songs by play count in descending order
  mostlyPlayedSongs.sort((a, b) {
    int playCountA = PlayCountService.getPlayCount(a.id.toString());
    int playCountB = PlayCountService.getPlayCount(b.id.toString());
    return playCountB.compareTo(playCountA); // Descending order
  });

  setState(() {
    _mostlyPlayedSongs = mostlyPlayedSongs;
  });
}


  @override
  void initState() {
    _fetchMostlyPlayedSongs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.sizeOf(context).height * 0.30;
    double adjustedHeight = (_mostlyPlayedSongs.length == 1)
        ? ht / 3
        : (_mostlyPlayedSongs.length == 2)
            ? ht / 1.5
            : ht;

    if (_mostlyPlayedSongs.isNotEmpty) {
      return SizedBox(
        height: adjustedHeight,
        child: PageView.builder(
          
          allowImplicitScrolling: false,
          reverse: false,
          controller: PageController(viewportFraction: 1),
          physics: const PageScrollPhysics(),
          itemCount: (_mostlyPlayedSongs.length / itemsPerview).ceil(),
          itemBuilder: (context, pageIndex) {
            int startIndex = pageIndex * itemsPerview;
            int endIndex = (pageIndex + 1) * itemsPerview;
            if (endIndex > _mostlyPlayedSongs.length) {
              endIndex = _mostlyPlayedSongs.length;
            }
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                const begin = Offset(0.0, 1.0);
                const end = Offset(0.0, 0.0);
                var offsetAnimation =
                    Tween(begin: begin, end: end).animate(animation);
                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
              child: SizedBox(
                key: ValueKey<int>(_mostlyPlayedSongs.length),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  itemCount: endIndex - startIndex,
                  itemBuilder: (context, listviewindex) {
                    int crtindex = startIndex + listviewindex;
                    final mostPlayedList = _mostlyPlayedSongs[crtindex];
                    final playCount = PlayCountService.getPlayCount(mostPlayedList.id.toString());

                    return ListTile(
                      contentPadding:
                          const EdgeInsets.only(top: 8, right: 8, left: 8),
                      leading: SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.18,
                        width: MediaQuery.sizeOf(context).width * 0.16,
                        child: AudioArtworkDefinerForOthers(
                          id: mostPlayedList.id,
                          imgRadius: 10,
                          iconSize: 25,
                        ),
                      ),
                      title: Text(
                        mostPlayedList.title.toString(),
                        style: TextStyle(
                            shadows: const [
                              BoxShadow(
                                color: Color.fromARGB(86, 139, 139, 139),
                                blurRadius: 15,
                                offset: Offset(-2, 2),
                              ),
                            ],
                            fontSize: 17,
                            fontFamily: 'rounder',
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).cardColor),
                      ),
                      subtitle: Text(
                        artistHelper(mostPlayedList.artist.toString(), ''),
                        style: TextStyle(
                            shadows: const [
                              BoxShadow(
                                color: Color.fromARGB(34, 107, 107, 107),
                                blurRadius: 15,
                                offset: Offset(-2, 2),
                              ),
                            ],
                            fontSize: 13,
                            fontFamily: 'rounder',
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).cardColor.withOpacity(.4)),
                      ),
                      trailing: Column(
                        children: [
                          Text(
                            playCount.toString(),
                            style: TextStyle(
                                shadows: const [
                                  BoxShadow(
                                    color: Color.fromARGB(86, 139, 139, 139),
                                    blurRadius: 15,
                                    offset: Offset(-2, 2),
                                  ),
                                ],
                                fontSize: 17,
                                fontFamily: 'rounder',
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).cardColor),
                          ),
                          Text(
                            "played",
                            style: TextStyle(
                                shadows: const [
                                  BoxShadow(
                                    color: Color.fromARGB(34, 107, 107, 107),
                                    blurRadius: 15,
                                    offset: Offset(-2, 2),
                                  ),
                                ],
                                fontSize: 13,
                                fontFamily: 'rounder',
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context)
                                    .cardColor
                                    .withOpacity(.4)),
                          ),
                        ],
                      ),
                      onTap: () async {
                        if (MozController.player.playing != true) {
                          // ignore: unnecessary_null_comparison
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NowPlaying(
                                      songModelList: MozController.playingSongs)));
                        }

                        await MozController.player.setAudioSource(
                            await MozController.createSongList(_mostlyPlayedSongs),
                            initialIndex: crtindex);
                        await MozController.player.play();
                      
                        MozController.player.playerStateStream.listen((playerState) {
                          if (playerState.processingState ==
                              ProcessingState.completed) {
                            // Check if the current song is the last song in the playlist
                            if (MozController.player.currentIndex ==
                                _mostlyPlayedSongs.length - 1) {
                              // Rewind the playlist to the starting index
                              MozController.player
                                  .seek(Duration.zero, index: 0);
                            }
                          }
                        });
                      },
                    );
                  },
                ),
              ),
            );
          },
        ),
      );
    } else {
      return const SizedBox.shrink();
    }

    // return ValueListenableBuilder<List<SongModel>>(
    //     valueListenable: MostlyPlayedDB.mostlyPlayedSongNotifier,
    //     builder:
    //         (BuildContext context, List<SongModel> mostplayed, Widget? child) {
    //       double adjustedHeight = (mostplayed.length == 1)
    //           ? ht / 3
    //           : (mostplayed.length == 2)
    //               ? ht / 1.5
    //               : ht;
    //       if (mostplayed.isNotEmpty) {
    //         return
    //       } else {
    //         return const SizedBox.shrink();
    //       }
    //     });
  }
}
