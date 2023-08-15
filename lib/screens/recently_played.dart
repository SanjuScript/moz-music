import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/DATABASE/favorite_db.dart';
import 'package:music_player/DATABASE/most_played.dart';
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
                              return songDisplay(context,
                                  song: recentSong[index],
                                  songs: recentSong,
                                  index: index);
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
