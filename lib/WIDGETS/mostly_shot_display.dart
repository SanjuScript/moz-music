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

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<SongModel>>(
        valueListenable: MostlyPlayedDB.mostlyPlayedSongNotifier,
        builder:
            (BuildContext context, List<SongModel> mostplayed, Widget? child) {
          return mostplayed.length > 8
              ? SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.30,
                  child: PageView.builder(
                    physics: const PageScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, pageIndex) {
                      List<SongModel> items;
                      if (pageIndex == 0) {
                        items = mostplayed.sublist(0, 3);
                      } else if (pageIndex == 1) {
                        items = mostplayed.sublist(3, 6);
                      } else {
                        items = mostplayed.sublist(6, 9);
                      }

                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        itemCount: items.length,
                        itemBuilder: (context, listviewindex) {
                          final playCount = MostlyPlayedDB.getPlayCount(
                              items[listviewindex].id);

                          return ListTile(
                            contentPadding:
                                const EdgeInsets.only(top: 8, right: 8, left: 8),
                            leading: SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.18,
                              width: MediaQuery.sizeOf(context).width * 0.16,
                              child: AudioArtworkDefiner(
                                id: items[listviewindex].id,
                                imgRadius: 10,
                                iconSize: 25,
                              ),
                            ),
                            title: Text(
                              items[listviewindex].title,
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
                                  items[listviewindex].artist.toString(), ''),
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NowPlaying(
                                            songModelList:
                                                GetSongs.playingSongs)));
                              }

                              await RecentlyPlayedDB.addRecentlyPlayed(
                                  items[listviewindex]);
                              await MostlyPlayedDB.incrementPlayCount(
                                  items[listviewindex]);
                              GetSongs.player.setAudioSource(
                                  GetSongs.createSongList(
                                    items,
                                  ),
                                  initialIndex: listviewindex);
                              GetSongs.player.play();
                              GetSongs.player.playerStateStream
                                  .listen((playerState) {
                                if (playerState.processingState ==
                                    ProcessingState.completed) {
                                  // Check if the current song is the last song in the playlist
                                  if (GetSongs.player.currentIndex ==
                                      items.length - 1) {
                                    // Rewind the playlist to the starting index
                                    GetSongs.player
                                        .seek(Duration.zero, index: 0);
                                  }
                                }
                              });
                            },
                          );
                        },
                      );
                    },
                  ),
                )
              : const SizedBox.shrink();
        });
  }
}
