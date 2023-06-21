import 'dart:async';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_player/PROVIDER/miniplayer_provider.dart';
import 'package:music_player/WIDGETS/nuemorphic_button.dart';
import 'package:music_player/Widgets/audio_artwork_definer.dart';
import 'package:music_player/screens/main_musicPlaying_screen.dart';
import 'package:provider/provider.dart';
import '../DATABASE/recently_played.dart';
import '../ANIMATION/up_animation.dart';
import '../CONTROLLER/song_controllers.dart';
// ignore: depend_on_referenced_packages
import 'package:rxdart/rxdart.dart';
import '../HELPER/duration.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  Stream<DurationState> get _durationStateStream =>
      Rx.combineLatest2<Duration, Duration?, DurationState>(
          GetSongs.player.positionStream,
          GetSongs.player.durationStream,
          (position, duration) => DurationState(
              position: position, total: duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<MiniplayerProvider>(context, listen: false).checkMounted();
    });
    final miniProvider =
        Provider.of<MiniplayerProvider>(context, listen: false);
    final ht = MediaQuery.of(context).size.height;
    final wt = MediaQuery.of(context).size.width;
    return Consumer<MiniplayerProvider>(
      builder: (context, value, child) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.deepPurple[400],
              borderRadius: BorderRadius.circular(20)),
          height: 100,
          child: Column(
            children: [
              StreamBuilder<DurationState>(
                stream: _durationStateStream,
                builder: (context, snapshot) {
                  final durationState = snapshot.data;
                  final progress = durationState?.position ?? Duration.zero;
                  final total = durationState?.total ?? Duration.zero;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: ProgressBar(
                      barHeight: ht * 0.003,
                      barCapShape: BarCapShape.round,
                      progressBarColor: const Color.fromARGB(255, 120, 78, 156),
                      bufferedBarColor: const Color.fromARGB(255, 120, 78, 156),
                      thumbGlowColor: Colors.transparent,
                      thumbColor: const Color.fromARGB(255, 120, 78, 156),
                      thumbRadius: ht * 0.001,
                      thumbGlowRadius: wt * 0.03,
                      baseBarColor: Colors.transparent,
                      progress: progress,
                      total: total,
                      timeLabelLocation: TimeLabelLocation.none,
                      onSeek: (duration) {
                        GetSongs.player.seek(duration);
                      },
                    ),
                  );
                },
              ),
              ListTile(
                tileColor: Theme.of(context).scaffoldBackgroundColor,
                onTap: () {
                  Navigator.push(
                      context,
                      Uptransition(NowPlaying(
                        songModelList: GetSongs.playingSongs,
                      )));
                },
                textColor: Theme.of(context).cardColor,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CircleAvatar(
                    child: Transform.scale(
                      scale: MediaQuery.of(context).size.width * 0.0040,
                      child: Nuemorphic(
                        borderRadius: BorderRadius.circular(100),
                        shadowVisibility: false,
                        child: AudioArtworkDefiner(
                          id: GetSongs
                              .playingSongs[GetSongs.player.currentIndex!].id,
                        ),
                      ),
                    ),
                  ),
                ),
                title: Text(
                  GetSongs.playingSongs[GetSongs.player.currentIndex!].title
                      .toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'appollo',
                    letterSpacing: .2,
                    color: const Color.fromARGB(255, 228, 229, 229),
                    fontWeight: FontWeight.bold,
                    fontSize: wt * 0.035,
                  ),
                ),
                subtitle: Text(
                  "${GetSongs.playingSongs[GetSongs.player.currentIndex!].artist.toString() == '<unknown>' ? 'No Artist' : GetSongs.playingSongs[GetSongs.player.currentIndex!].artist.toString()} .${GetSongs.playingSongs[GetSongs.player.currentIndex!].fileExtension.toString()}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: const Color.fromARGB(255, 228, 229, 229),
                      fontSize: wt * 0.028,
                      overflow: TextOverflow.ellipsis),
                ),
                trailing: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.33,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          RecentlyPlayedDB.addRecentlyPlayed(GetSongs
                              .playingSongs[GetSongs.player.currentIndex!].id);
                          miniProvider.previousButton(context);
                        },
                        child: Icon(
                          Icons.skip_previous_sharp,
                          color: const Color.fromARGB(255, 228, 229, 229),
                          size: wt * 0.09,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          miniProvider.playPauseButton(context);
                        },
                        child: StreamBuilder<bool>(
                          stream: GetSongs.player.playingStream,
                          builder: (context, snapshot) {
                            bool? playingStage = snapshot.data;
                            if (playingStage != null && playingStage) {
                              return Icon(
                                Icons.pause_circle,
                                color: const Color.fromARGB(255, 228, 229, 229),
                                size: wt * 0.10,
                              );
                            } else {
                              return Icon(
                                Icons.play_circle_fill_rounded,
                                color: const Color.fromARGB(255, 228, 229, 229),
                                size: wt * 0.10,
                              );
                            }
                          },
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            RecentlyPlayedDB.addRecentlyPlayed(GetSongs
                                .playingSongs[GetSongs.player.currentIndex!]
                                .id);
                            miniProvider.nextButton(context);
                          },
                          child: Icon(
                            Icons.skip_next_sharp,
                            color: const Color.fromARGB(255, 228, 229, 229),
                            size: wt * 0.09,
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
