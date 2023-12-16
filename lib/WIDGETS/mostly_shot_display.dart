import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../CONTROLLER/song_controllers.dart';
import '../DATABASE/most_played.dart';
import '../DATABASE/recently_played.dart';
import '../HELPER/artist_helper.dart';
import '../SCREENS/main_music_playing_screen.dart.dart';
import 'audio_artwork_definer.dart';

class MostlyShotDisplay extends StatelessWidget {
  const MostlyShotDisplay({super.key});
  final int itemsPerview = 3;
  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.sizeOf(context).height * 0.30;

    return ValueListenableBuilder<List<SongModel>>(
        valueListenable: MostlyPlayedDB.mostlyPlayedSongNotifier,
        builder:
            (BuildContext context, List<SongModel> mostplayed, Widget? child) {
          double adjustedHeight = (mostplayed.length == 1)
              ? ht / 3
              : (mostplayed.length == 2)
                  ? ht / 1.5
                  : ht;
          if (mostplayed.isNotEmpty) {
            return SizedBox(
              height: adjustedHeight,
              child: PageView.builder(
                allowImplicitScrolling: false,
                reverse: false,
                // controller: PageController(viewportFraction: .9),
                physics: const PageScrollPhysics(),
                itemCount: (mostplayed.length / itemsPerview).ceil(),
                itemBuilder: (context, pageIndex) {
                  int startIndex = pageIndex * itemsPerview;
                  int endIndex = (pageIndex + 1) * itemsPerview;
                  if (endIndex > mostplayed.length) {
                    endIndex = mostplayed.length;
                  }
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
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
                      key: ValueKey<int>(mostplayed.length),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        itemCount: endIndex - startIndex,
                        itemBuilder: (context, listviewindex) {
                          int crtindex = startIndex + listviewindex;
                          final mostPlayedList = mostplayed[crtindex];
                          final playCount =
                              MostlyPlayedDB.getPlayCount(mostPlayedList.id);

                          return ListTile(
                            contentPadding: const EdgeInsets.only(
                                top: 8, right: 8, left: 8),
                            leading: SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.18,
                              width: MediaQuery.sizeOf(context).width * 0.16,
                              child: AudioArtworkDefiner(
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
                              artistHelper(
                                  mostPlayedList.artist.toString(), ''),
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
                            trailing: Column(
                              children: [
                                Text(
                                  playCount.toString(),
                                  style: TextStyle(
                                      shadows: const [
                                        BoxShadow(
                                          color:
                                              Color.fromARGB(86, 139, 139, 139),
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
                                          color:
                                              Color.fromARGB(34, 107, 107, 107),
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
                              if (GetSongs.player.playing != true) {
                                // ignore: unnecessary_null_comparison
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NowPlaying(
                                            songModelList:
                                                GetSongs.playingSongs)));
                              }

                              await GetSongs.player.setAudioSource(
                                  GetSongs.createSongList(mostplayed),
                                  initialIndex: crtindex);
                              await GetSongs.player.play();
                              await RecentlyPlayedDB.addRecentlyPlayed(
                                  mostPlayedList);
                              await MostlyPlayedDB.incrementPlayCount(
                                  mostPlayedList);
                              GetSongs.player.playerStateStream
                                  .listen((playerState) {
                                if (playerState.processingState ==
                                    ProcessingState.completed) {
                                  // Check if the current song is the last song in the playlist
                                  if (GetSongs.player.currentIndex ==
                                      mostplayed.length - 1) {
                                    // Rewind the playlist to the starting index
                                    GetSongs.player
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
        });
  }
}
