import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player/DATABASE/most_played.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../DATABASE/recently_played.dart';
import '../HELPER/get_audio_size_in_mb.dart';
import '../WIDGETS/appbar.dart';

import 'package:flutter/material.dart';

import '../WIDGETS/dialogues/playlist_delete_dialogue.dart';
// ignore: unused_import
import '../WIDGETS/dialogues/song_delete_dialogue.dart';
import '../WIDGETS/song_list_maker.dart';

class MostlyPlayed extends StatefulWidget {
  const MostlyPlayed({super.key});

  @override
  State<MostlyPlayed> createState() => _MostlyPlayedState();
}

class _MostlyPlayedState extends State<MostlyPlayed>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    MostlyPlayedDB.getMostlyPlayedSongs();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    // FavoriteDb.favoriteSongs;
    super.build(context);
    return ValueListenableBuilder(
      valueListenable: MostlyPlayedDB.mostlyPlayedSongNotifier,
      builder: (BuildContext context, List<SongModel> value, Widget? child) {
        // final temp = value.reversed.toList();
        // recentSong = temp.toSet().toList();

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
                            text1: "Delete All From Mostly Played",
                            onPress: () {
                              MostlyPlayedDB.deleteAll();
                              Navigator.pop(context);
                            });
                      }
                    },
                    topString: "Mostly",
                    firstString: "Play All",
                    secondString: "${value.length} Songs",
                    widget: value.isEmpty
                        ? Center(
                            heightFactor: 30,
                            child: Text(
                              'No Mostly played Yet',
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
                            itemCount: value.length,
                            itemBuilder: (context, index) {
                              String filePath = value[index].data;
                              File file = File(filePath);
                              double fileSizeInMB = getFileSizeInMB(file);
                               final playCount = MostlyPlayedDB.getPlayCount(
                                      value[index].id);
                              return songDisplay(context,
                                  song: value[index],
                                  songs: value,
                                  isTrailingChange: 
                                  true,
                                  trailing:  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          playCount.toString(),
                                          style: TextStyle(
                                              shadows: const [
                                                BoxShadow(
                                                  color: Color.fromARGB(
                                                      86, 139, 139, 139),
                                                  blurRadius: 15,
                                                  offset: Offset(-2, 2),
                                                ),
                                              ],
                                              fontSize: 17,
                                              fontFamily: 'rounder',
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  Theme.of(context).cardColor),
                                        ),
                                        Text(
                                          "played",
                                          style: TextStyle(
                                              shadows: const [
                                                BoxShadow(
                                                  color: Color.fromARGB(
                                                      34, 107, 107, 107),
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
