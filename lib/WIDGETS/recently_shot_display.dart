import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../CONTROLLER/song_controllers.dart';
import '../DATABASE/most_played.dart';
import '../DATABASE/recently_played.dart';
import '../SCREENS/main_music_playing_screen.dart.dart';
import 'audio_artwork_definer.dart';

// ignore: must_be_immutable
class RecentlyShotDisplay extends StatelessWidget {
  RecentlyShotDisplay({super.key});

  List<SongModel> recentSong = [];
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: RecentlyPlayedDB.recentlyplayedSongNotifier,
        builder: (BuildContext context, List<SongModel> value, Widget? child) {
          final temp = value.toList();
          recentSong = temp.reversed.toSet().toList();

          if (value.isNotEmpty) {
            return SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.22,
                  child: ListView.builder(
                    physics:const BouncingScrollPhysics(),
                    itemCount: recentSong.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      if (index >= 0 && index < recentSong.length) {
                        return InkWell(
                          overlayColor: const MaterialStatePropertyAll(Colors.transparent),
                          onTap: () async {
                            if (GetSongs.player.playing != true) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NowPlaying(
                                          songModelList:
                                              GetSongs.playingSongs)));
                            }

                            // await RecentlyPlayedDB.addRecentlyPlayed(
                            //     recentSong[index]);
                            await MostlyPlayedDB.incrementPlayCount(
                                recentSong[index]);
                             if (index >= 0 && index < recentSong.length) {
                              GetSongs.player.setAudioSource(
                                GetSongs.createSongList(
                                  recentSong,
                                ),
                                initialIndex: index,
                              );
                            }
                            GetSongs.player.play();
                            GetSongs.player.playerStateStream
                                .listen((playerState) {
                              if (playerState.processingState ==
                                  ProcessingState.completed) {
                                // Check if the current song is the last song in the playlist
                                if (GetSongs.player.currentIndex ==
                                    recentSong.length - 1) {
                                  // Rewind the playlist to the starting index
                                  GetSongs.player.seek(Duration.zero, index: 0);
                                }
                              }
                            });
                            GetSongs.songscopy = recentSong;
                          },
                          child: Column(
                            children: [
                              Container(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.26,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.12,
                                  // Adjust the size as needed
                                  margin: const EdgeInsets.only(
                                      left: 8, right: 8, top: 14, bottom: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: AudioArtworkDefiner(
                                    id: recentSong[index].id,
                                    imgRadius: 15,
                                  )),
                              SizedBox(
                                height:
                                    MediaQuery.sizeOf(context).height * 0.05,
                                width: MediaQuery.sizeOf(context).width * 0.25,
                                child: Text(
                                  recentSong[index].title,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      shadows: const [
                                        BoxShadow(
                                          color: Color.fromARGB(90, 89, 89, 89),
                                          blurRadius: 15,
                                          offset: Offset(-2, 2),
                                        ),
                                      ],
                                      fontSize: 13,
                                      fontFamily: 'rounder',
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context).cardColor),
                                ),
                              )
                            ],
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                );
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}
