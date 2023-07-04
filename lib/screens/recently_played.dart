import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/DATABASE/favorite_db.dart';
import 'package:music_player/DATABASE/recently_played.dart';
import 'package:music_player/WIDGETS/bottomsheet/song_info_sheet.dart';
import 'package:music_player/WIDGETS/dialogues/playlist_delete_dialogue.dart';
import 'package:music_player/WIDGETS/dialogues/song_delete_dialogue.dart';
import 'package:music_player/screens/main_music_playing_screen.dart.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../HELPER/get_audio_size_in_mb.dart';
import '../Widgets/appbar.dart';
import '../Widgets/song_list_maker.dart';
import '../CONTROLLER/song_controllers.dart';


class RecentlyPlayed extends StatefulWidget {
  const RecentlyPlayed({super.key});

  @override
  State<RecentlyPlayed> createState() => _RecentlyPlayedState();
}

class _RecentlyPlayedState extends State<RecentlyPlayed>
    with AutomaticKeepAliveClientMixin {
  List<SongModel> recentSong = [];
  @override
  void initState() {
    super.initState();
    RecentlyPlayedDB.getRecentlyPlayedSongs();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    FavoriteDb.favoriteSongs;
    super.build(context);
    return ValueListenableBuilder(
      valueListenable: RecentlyPlayedDB.recentlyplayedSongNotifier,
      builder: (BuildContext context, List<SongModel> value, Widget? child) {
        final temp = value.reversed.toList();
        recentSong = temp.toSet().toList();
        return Scaffold(
            extendBody: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  TopAppBar(
                    icon: Icons.music_note_rounded,
                    isPop: value.isEmpty ? false : true,
                    iconTap: () {},
                    onSelected: (p0) {
                      if (p0 == "ClearAll") {
                        showPlaylistDeleteDialogue(
                            context: context,
                            text1: "Delete All From Recently Played",
                            onPress: () {
                              RecentlyPlayedDB.deleteAll();
                            });
                      }
                    },
                    topString: "Recently",
                    firstString: "Play All",
                    secondString: "${recentSong.length} Songs",
                    widget: value.isEmpty
                        ? Center(
                            heightFactor: 30,
                            child: Text(
                              'No Recently played Yet',
                              style: TextStyle(
                                letterSpacing: 2,
                                fontFamily: "appollo",
                                color: Theme.of(context).cardColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: recentSong.length,
                            itemBuilder: (context, index) {
                              String filePath = recentSong[index].data;
                              File file = File(filePath);
                              double fileSizeInMB = getFileSizeInMB(file);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.10,
                                  child: SongListViewerForSections(
                                    icon: Icons.music_note,
                                    color: Theme.of(context).cardColor,
                                    fileSize:
                                        "${fileSizeInMB.toStringAsFixed(2)} Mb",
                                    onLongpress: () {
                                      bottomDetailsSheet(
                                          context: context,
                                          artist: recentSong[index]
                                                      .artist
                                                      .toString() ==
                                                  '<unknown>'
                                              ? 'Unknown Artist.${recentSong[index].fileExtension.toString()}'
                                              : "${recentSong[index].artist}.${recentSong[index].fileExtension}",
                                          title: recentSong[index].title,
                                          composer: recentSong[index]
                                              .composer
                                              .toString(),
                                          genre: recentSong[index]
                                                      .genre
                                                      .toString() ==
                                                  "null"
                                              ? "NO GENRE"
                                              : recentSong[index]
                                                  .genre
                                                  .toString(),
                                          song: recentSong[index],
                                          filePath: filePath,
                                          file: file,
                                          onTap: (){},
                                          id: recentSong[index].id,
                                          delete: () {
                                            showSongDeleteDialogue(
                                                context, recentSong[index]);
                                          });
                                    },
                                    onTap: () {
                                      // playSongsOnTap(favoriteData, index);
                                      if (GetSongs.player.playing != true) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    NowPlaying(
                                                        songModelList: GetSongs
                                                            .playingSongs)));
                                      } else {
                                        print("object");
                                      }
                                      GetSongs.player.setAudioSource(
                                          GetSongs.createSongList(
                                            recentSong,
                                          ),
                                          initialIndex: index);
                                      GetSongs.player.play();
                                      GetSongs.player.playerStateStream
                                          .listen((playerState) {
                                        if (playerState.processingState ==
                                            ProcessingState.completed) {
                                          // Check if the current song is the last song in the playlist
                                          if (GetSongs.player.currentIndex ==
                                              recentSong.length - 1) {
                                            // Rewind the playlist to the starting index
                                            GetSongs.player
                                                .seek(Duration.zero, index: 0);
                                          }
                                        }
                                      });
                                    },
                                    subtitle: recentSong[index]
                                                .artist
                                                .toString() ==
                                            '<unknown>'
                                        ? 'Unknown Artist.${recentSong[index].fileExtension.toString()}'
                                        : "${recentSong[index].artist}.${recentSong[index].fileExtension}",
                                    id: recentSong[index].id,
                                    trailingOnTap: () {},
                                    title:
                                        recentSong[index].title.toUpperCase(),
                                    child: const SizedBox(),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
