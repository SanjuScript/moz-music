import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/Model/music_model.dart';
import 'package:music_player/WIDGETS/dialogues/playlist_delete_dialogue.dart';
import 'package:music_player/screens/playlist/playList_song_listpage.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../DATABASE/playlistDb.dart';
import '../../DATABASE/recently_played.dart';
import '../../WIDGETS/dialogues/playlist_remove_dialogue.dart';
import '../../Widgets/song_list_maker.dart';
import '../../ANIMATION/scale_animation.dart';
import '../../CONTROLLER/song_controllers.dart';
import '../main_musicPlaying_screen.dart';

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
                      Navigator.push(
                          context,
                          ScaletransitionForAddbutton(PlaylistSongListScreen(
                              playlist: playlist)));
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
                            Navigator.push(
                                context,
                                ScaletransitionForAddbutton(
                                    PlaylistSongListScreen(
                                        playlist: playlist)));
                          } else {
                            showPlaylistDeleteDialogue(
                                context: context,
                                text1:
                                    "Remove all song from ${playlist.name}",
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
                      FutureBuilder<Uint8List?>(
                          future: OnAudioQuery().queryArtwork(
                            playlistsong.first.id,
                            ArtworkType.AUDIO,
                            format: ArtworkFormat.JPEG,
                            size: 250,
                            quality: 100,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.data != null &&
                                snapshot.data!.isNotEmpty) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.09,
                                width:
                                    MediaQuery.of(context).size.height * 0.09,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    clipBehavior: Clip.antiAlias,
                                    child: Image.memory(
                                      snapshot.data!,
                                      gaplessPlayback: true,
                                      repeat: ImageRepeat.repeat,
                                      fit: BoxFit.cover,
                                      filterQuality: FilterQuality.high,
                                      errorBuilder:
                                          (context, exception, stackTrace) {
                                        return const Icon(
                                          Icons.image_not_supported,
                                          size: 50,
                                        );
                                      },
                                    )),
                              );
                            }
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.09,
                              width: MediaQuery.of(context).size.height * 0.09,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(colors: [
                                  Theme.of(context).primaryColorDark,
                                  Theme.of(context).primaryColorLight,
                                ]),
                              ),
                              child: Center(
                                  child: Icon(
                                FontAwesomeIcons.music,
                                size: 15,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              )),
                            );
                          }),
                      Column(
                        children: [
                          Text(
                           playlist.name,
                            style: TextStyle(
                              letterSpacing: 1,
                              fontFamily: "appollo",
                              fontSize: 23,
                              color: Theme.of(context).cardColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Text(
                              "${playlistsong.length} Songs",
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
                                subtitle: playlistsong[index]
                                            .artist
                                            .toString() ==
                                        '<unknown>'
                                    ? 'Unknown Artist' "." +
                                        playlistsong[index]
                                            .fileExtension
                                            .toString()
                                    : "${playlistsong[index].artist}.${playlistsong[index].fileExtension}",
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
                                  RecentlyPlayedDB.addRecentlyPlayed(
                                      playlistsong[index].id);
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
