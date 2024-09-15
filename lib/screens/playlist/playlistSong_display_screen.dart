import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_player/COLORS/colors.dart';
import 'package:music_player/DATABASE/playlistDb.dart';
import 'package:music_player/Model/music_model.dart';
import 'package:music_player/WIDGETS/audio_for_others.dart';
import 'package:music_player/WIDGETS/dialogues/playlist_delete_dialogue.dart';
import 'package:music_player/WIDGETS/song_list_maker.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../CONTROLLER/song_controllers.dart';

class PlaylistSongDisplayScreen extends StatefulWidget {
  const PlaylistSongDisplayScreen({
    super.key,
  });

  @override
  State<PlaylistSongDisplayScreen> createState() =>
      _PlaylistSongDisplayScreenState();
}

class _PlaylistSongDisplayScreenState extends State<PlaylistSongDisplayScreen>
    with AutomaticKeepAliveClientMixin {
  late List<SongModel> playlistsong;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final MusicModel playlist = arguments['playlist'];
    // Fetch the playlist data here
    playlistsong = listPlaylist(playlist);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final MusicModel playlist = arguments['playlist'];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: MediaQuery.of(context).size.height * 0.25,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              titlePadding: EdgeInsets.only(left: 90, bottom: 10),
              title: Text(
                playlist.name,
                style: TextStyle(
                  fontFamily: "appollo",
                  fontSize: 20,
                  color: Theme.of(context).cardColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.30,
                    width: MediaQuery.of(context).size.width,
                    child: AudioArtworkDefinerForOthers(
                      id: playlistsong.isNotEmpty ? playlistsong.first.id : 0,
                      size: 500,
                      imgRadius: 0,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.30,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [.2, .9],
                        colors: [
                          Colors.transparent,
                          Theme.of(context)
                              .scaffoldBackgroundColor, // Shading effect
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom:
                        20, // Adjust this value to position the text higher or lower
                    left: 20,
                    child: Text(
                      "${playlist.songId.length} songs ",
                      style: TextStyle(
                        letterSpacing: 1,
                        fontFamily: "appollo",
                        fontSize: 15,
                        color: Theme.of(context).cardColor.withOpacity(
                            .5), // Ensure this is visible on the shading
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context)
                                .scaffoldBackgroundColor
                                .withOpacity(.9),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            splashColor: Colors.transparent,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              size: 23,
                              color: Theme.of(context).cardColor,
                            ),
                          ),
                          Spacer(),
                          PopupMenuButton<String>(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            tooltip: "Clear All",
                            color: Theme.of(context).scaffoldBackgroundColor,
                            icon: Icon(
                              Icons.more_vert,
                              color: Theme.of(context).cardColor,
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem<String>(
                                value: 'addsong',
                                child: Text(
                                  "Add Song",
                                  style: TextStyle(
                                    letterSpacing: 1,
                                    fontFamily: "appollo",
                                    fontSize: 15,
                                    color: Theme.of(context).cardColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'clearall',
                                child: Text(
                                  "Clear All",
                                  style: TextStyle(
                                    letterSpacing: 1,
                                    fontFamily: "appollo",
                                    fontSize: 15,
                                    color: Theme.of(context).cardColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == "addsong") {
                                Navigator.pushNamed(
                                    context, '/playlistSongList',
                                    arguments: {'playlistt': playlist});
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => NewMozUI()));
                              } else {
                                showPlaylistDeleteDialogue(
                                    context: context,
                                    text1:
                                        "Remove all songs from ${playlist.name}",
                                    onPress: () {
                                      playlist.deleteAll();
                                      Navigator.pop(context);
                                    });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.10,
                    child: SongDisplay(
                      song: playlistsong[index],
                      index: index,
                      remove: () {
                        setState(() {
                          playlist.deleteData(playlistsong[index].id);
                          playlistsong.removeAt(index);
                        });
                      },
                      isTrailingChange: true,
                      trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              playlist.deleteData(playlistsong[index].id);
                              playlistsong.removeAt(index);
                            });
                          },
                          icon: const Icon(Icons.delete_forever)),
                      songs: playlistsong,
                    ),
                  ),
                );
              },
              childCount: playlistsong.length,
            ),
          ),
        ],
      ),
    );
  }

  List<SongModel> listPlaylist(MusicModel playlist) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    List<SongModel> plsongs = [];
    final int folderindex = arguments['folderindex'];
    List<int> data =
        Hive.box<MusicModel>('playlistDB').values.toList()[folderindex].songId;
    for (int i = 0; i < MozController.songscopy.length; i++) {
      for (int j = 0; j < data.length; j++) {
        if (MozController.songscopy[i].id == data[j]) {
          // log("${MozController.songscopy[i].id.toString()}\n");
          // log("Count : ${data.length}");
          plsongs.add(MozController.songscopy[i]);
        }
      }
    }
    return plsongs;
  }
}

