import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/DATABASE/most_played.dart';
import 'package:music_player/HELPER/artist_helper.dart';
import 'package:music_player/Model/music_model.dart';
import 'package:music_player/SCREENS/main_music_playing_screen.dart.dart';
import 'package:music_player/WIDGETS/audio_artwork_definer.dart';
import 'package:music_player/WIDGETS/dialogues/playlist_delete_dialogue.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../DATABASE/playlistDb.dart';
import '../../DATABASE/recently_played.dart';
import '../../WIDGETS/dialogues/playlist_remove_dialogue.dart';
import '../../Widgets/song_list_maker.dart';
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
  StreamSubscription<PlayerState>? _playerStateSubscription;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    PlayListDB.getAllPlaylist();
    // log('dtgy');
    super.initState();
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final MusicModel playlist = arguments['playlist'];
    final int folderindex = arguments['folderindex'];
    // PlayListDB.getAllPlaylist();
    return ValueListenableBuilder(
        valueListenable: Hive.box<MusicModel>(
          'playlistDB',
        ).listenable(),
        builder: (BuildContext context, Box<MusicModel> value, Widget? child) {
          playlistsong = listPlaylist(
            value.values.toList()[folderindex].songId,
          );

          if (playlistsong.isEmpty) {
            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor, // S
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'NO SONGS FOUND ',
                    style: TextStyle(
                      letterSpacing: 2,
                      color: Theme.of(context).cardColor,
                      fontFamily: "appollo",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/playlistSongList',
                          arguments: {'playlistt': playlist});
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.playlist_add,
                          color: Theme.of(context).cardColor,
                        ),
                        Text(
                          "Add to playlist",
                          style: TextStyle(color: Theme.of(context).cardColor),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          } else {
            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor, // S

              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      IconButton(
                          splashColor: Colors.transparent,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_rounded,
                            size: 23,
                            color: Theme.of(context).cardColor,
                          )),
                      const Spacer(),
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
                            Navigator.pushNamed(context, '/playlistSongList',
                                arguments: {'playlistt': playlist});
                          } else {
                            showPlaylistDeleteDialogue(
                                context: context,
                                text1: "Remove all song from ${playlist.name}",
                                onPress: () {
                                  playlist.deleteAll();
                                  Navigator.pop(context);
                                });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height * 0.09,
                          width: MediaQuery.of(context).size.height * 0.09,
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: AudioArtworkDefiner(
                            id: playlistsong.first.id,
                            imgRadius: 15,
                          )),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.6,
                            child: Text(
                              playlist.name,
                              style: TextStyle(
                                letterSpacing: 1,
                                fontFamily: "appollo",
                                fontSize: 23,
                                overflow: TextOverflow.ellipsis,
                                color: Theme.of(context).cardColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Text(
                              
                              "${playlistsong.length} Songs",
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                letterSpacing: 1,
                                fontFamily: "appollo",
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.10,
                            child: SongListViewerForSections(
                                isWidget: true,
                                color: Theme.of(context).cardColor,
                                fileSize: '',
                                id: playlistsong[index].id,
                                onLongpress: () {},
                                subtitle: artistHelper(
                                    playlistsong[index].artist.toString(),
                                    playlistsong[index].fileExtension),
                                onTap: () {
                                  if (GetSongs.player.playing != true) {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: ((context) {
                                      return NowPlaying(
                                        songModelList: GetSongs.playingSongs,
                                      );
                                    })));
                                  } else {
                                    print("object");
                                  }

                                  List<SongModel> newlist = [...playlistsong];
                                  GetSongs.player.stop();
                                  GetSongs.player.setAudioSource(
                                      GetSongs.createSongList(newlist),
                                      initialIndex: index);
                                  GetSongs.player.play();
                                  MostlyPlayedDB.incrementPlayCount(
                                      playlistsong[index]);
                                  RecentlyPlayedDB.addRecentlyPlayed(
                                      playlistsong[index]);
                                  // Add a completion listener to the audio player
                                  GetSongs.player.playerStateStream
                                      .listen((playerState) {
                                    if (playerState.processingState ==
                                        ProcessingState.completed) {
                                      // Check if the current song is the last song in the playlist
                                      if (GetSongs.player.currentIndex ==
                                          playlistsong.length - 1) {
                                        // Rewind the playlist to the starting index
                                        GetSongs.player
                                            .seek(Duration.zero, index: 0);
                                      }
                                    }
                                  });
                                },
                                trailingOnTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return DeleteSongDialog(
                                        songTitle: playlistsong[index].title,
                                        onPress: () {
                                          playlist.deleteData(
                                            playlistsong[index].id,
                                          );
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  );
                                },
                                icon: Icons.delete,
                                title: playlistsong[index].title,
                                child: const SizedBox()),
                          ),
                        );
                      }),
                      physics: const BouncingScrollPhysics(),
                      itemCount: playlistsong.length),
                ]),
              ),
            );
          }
        });
  }

  List<SongModel> listPlaylist(
    List<int> data,
  ) {
    List<SongModel> plsongs = [];

    for (int i = 0; i < GetSongs.songscopy.length; i++) {
      // log(GetSongs.songscopy.isEmpty.toString());
      for (int j = 0; j < data.length; j++) {
        if (GetSongs.songscopy[i].id == data[j]) {
          plsongs.add(GetSongs.songscopy[i]);
        }
      }
    }

    // log(plsongs.isEmpty.toString());
    return plsongs;
  }
}
