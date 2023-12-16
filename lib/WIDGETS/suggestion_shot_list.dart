import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/CONTROLLER/song_controllers.dart';
import 'package:music_player/DATABASE/most_played.dart';
import 'package:music_player/DATABASE/recently_played.dart';
import 'package:music_player/DATABASE/song_suggestion.dart';
import 'package:music_player/WIDGETS/audio_artwork_definer.dart';
import 'package:music_player/screens/main_music_playing_screen.dart.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongSuggestionList extends StatelessWidget {
  const SongSuggestionList({super.key});

  @override
  Widget build(BuildContext context) {
    List<SongModel> suggestedSongs = SongSuggestor.suggestSongs();
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.22,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: suggestedSongs.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index >= 0 && index < suggestedSongs.length) {
            return InkWell(
              overlayColor: const MaterialStatePropertyAll(Colors.transparent),
              onTap: () async {
                if (GetSongs.player.playing != true) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NowPlaying(
                              songModelList: GetSongs.playingSongs)));
                }

                await RecentlyPlayedDB.addRecentlyPlayed(suggestedSongs[index]);
                await MostlyPlayedDB.incrementPlayCount(suggestedSongs[index]);
                if (index >= 0 && index < suggestedSongs.length) {
                  GetSongs.player.setAudioSource(
                    GetSongs.createSongList(
                      suggestedSongs,
                    ),
                    initialIndex: index,
                  );
                }
                GetSongs.player.play();
                GetSongs.player.playerStateStream.listen((playerState) {
                  if (playerState.processingState ==
                      ProcessingState.completed) {
                    // Check if the current song is the last song in the playlist
                    if (GetSongs.player.currentIndex == suggestedSongs.length - 1) {
                      // Rewind the playlist to the starting index
                      GetSongs.player.seek(Duration.zero, index: 0);
                    }
                  }
                });
                GetSongs.songscopy = suggestedSongs;
              },
              child: Column(
                children: [
                  Container(
                      width: MediaQuery.sizeOf(context).width * 0.26,
                      height: MediaQuery.sizeOf(context).height * 0.12,
                      // Adjust the size as needed
                      margin: const EdgeInsets.only(
                          left: 8, right: 8, top: 14, bottom: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: AudioArtworkDefiner(
                        id: suggestedSongs[index].id ?? 23,
                        imgRadius: 15,
                      )),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.05,
                    width: MediaQuery.sizeOf(context).width * 0.25,
                    child: Text(
                      suggestedSongs[index].title.toString(),
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
            return SizedBox();
          }
        },
      ),
    );
  }
}
