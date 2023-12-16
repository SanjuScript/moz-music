// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/DATABASE/favorite_db.dart';
import 'package:music_player/SCREENS/main_music_playing_screen.dart.dart';
import 'package:music_player/Widgets/song_list_maker.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../HELPER/get_audio_size_in_mb.dart';
import '../../WIDGETS/dialogues/playlist_delete_dialogue.dart';
import '../../Widgets/appbar.dart';
import '../../CONTROLLER/song_controllers.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with AutomaticKeepAliveClientMixin {
      
  void playSongsOnTap(List<SongModel> favoriteData, int index) {
    List<SongModel> favoriteList = [...favoriteData];

    if (GetSongs.player.playing != true) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: ((context) {
          return NowPlaying(songModelList: favoriteList);
        })),
      );
    }
    GetSongs.player.setAudioSource(GetSongs.createSongList(favoriteList),
        initialIndex: index);
    GetSongs.player.play();
    GetSongs.player.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        // Check if the current song is the last song in the playlist
        if (GetSongs.player.currentIndex == favoriteData.length - 1) {
          // Rewind the playlist to the starting index
          GetSongs.player.seek(Duration.zero, index: 0);
        }
      }
    });
  }

  final ScrollController _scrollController = ScrollController();
  Widget detailsMaker(
      BuildContext context, String upperText, String subText, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      minVerticalPadding: 5,
      title: Text(
        upperText,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: MediaQuery.of(context).size.width * 0.050,
          color: Theme.of(context).cardColor,
        ),
      ),
      subtitle: Text(
        subText,
        style: const TextStyle(
          color: Color.fromARGB(255, 49, 141, 69),
        ),
      ),
      iconColor: const Color(0xff97B0EA),
      tileColor: Colors.transparent,
    );
  }

  void _deleteAllFavorites() {
    // Delete all songs from favorites
    FavoriteDb.deleteAll();
    FavoriteDb.favoriteSongs.notifyListeners();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ValueListenableBuilder<List<SongModel>>(
      valueListenable: FavoriteDb.favoriteSongs,
      builder:
          (BuildContext context, List<SongModel> favoriteData, Widget? child) {
        return Scaffold(
            extendBody: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: TopAppBar(
                isPop: favoriteData.isEmpty ? false : true,
                onSelected: (p0) {
                  if (p0 == "ClearAll") {
                    showPlaylistDeleteDialogue(
                        context: context,
                        text1: "Clear All From Liked",
                        onPress: () {
                          _deleteAllFavorites();
                        });
                  }
                },
                firstString: "Play All",
                secondString: "${favoriteData.length} Songs",
                topString: "Liked",
                widget: favoriteData.isEmpty
                    ? Center(
                        heightFactor: 30,
                        child: Text(
                          'NO FAVORITES YET',
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
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          SongModel song = favoriteData[index];
                          // String filePath = song.data;
                          // File file = File(filePath);
                          // double fileSizeInMB = getFileSizeInMB(file);
                          return songDisplay(context,
                              song: song, songs: favoriteData, index: index);
                        },
                        itemCount: favoriteData.length,
                      ),
                icon: Icons.favorite_rounded,
                iconTap: () {},
              ),
            ));
      },
    );
  }
}
