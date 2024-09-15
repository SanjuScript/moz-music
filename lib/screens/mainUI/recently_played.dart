import 'package:flutter/material.dart';
import 'package:music_player/DATABASE/favorite_db.dart';
import 'package:music_player/DATABASE/recently_played.dart';
import 'package:music_player/WIDGETS/dialogues/playlist_delete_dialogue.dart';
import 'package:music_player/WIDGETS/song_list_maker.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../Widgets/appbar.dart';

class RecentlyPlayed extends StatefulWidget {
  const RecentlyPlayed({super.key});

  @override
  State<RecentlyPlayed> createState() => _RecentlyPlayedState();
}

class _RecentlyPlayedState extends State<RecentlyPlayed>
    with AutomaticKeepAliveClientMixin {
  // List<SongModel> recentSong = [];
  // @override
  // void initState() {
  //   super.initState();
  //   // RecentDb.initialize();

  // }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    RecentDb.recentSongs;
    super.build(context);
    return ValueListenableBuilder<List<SongModel>>(
      valueListenable: RecentDb.recentSongs,
      builder: (BuildContext context, List<SongModel> value, Widget? child) {
        final recentSong = value.toSet().toList();
        if (recentSong == ConnectionState.waiting) {
          return const Center(child: Text("Loading..."));
        }
        // value.sort((a, b) =>
        //     RecentDb.musicDb.get(b.id)!.compareTo(RecentDb.musicDb.get(a.id)!.toInt()));
        //data loading
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
                              RecentDb.deleteAll();
                              Navigator.pop(context);
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
                              // File file = File(filePath);
                              // String filePath = recentSong[index].data;
                              // double fileSizeInMB = getFileSizeInMB(file);
                              return SongDisplay(
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
