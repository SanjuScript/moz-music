import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/DATABASE/favorite_db.dart';
import 'package:music_player/DATABASE/playlistDb.dart';
import 'package:music_player/HELPER/artist_helper.dart';
import 'package:music_player/HELPER/scroll_behaviour.dart';
import 'package:music_player/HELPER/sort_enum.dart';
import 'package:music_player/HELPER/strings.dart';
import 'package:music_player/WIDGETS/audio_artwork_definer.dart';
import 'package:music_player/screens/artists/artists_page.dart';
import 'package:music_player/screens/favoritepage/favorite_button.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../ANIMATION/fade_animation.dart';
import '../CONTROLLER/song_controllers.dart';
import '../DATABASE/most_played.dart';
import '../DATABASE/recently_played.dart';
import '../PROVIDER/album_provider.dart';
import '../PROVIDER/artist_provider.dart';
import '../PROVIDER/homepage_provider.dart';
import 'album/album_list.dart';
import 'main_music_playing_screen.dart.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {super.key,
      required this.favorite,
      required this.playlist,
      required this.recently,
      required this.mostly,
      required this.songs});
  final void Function() favorite;
  final void Function() songs;
  final void Function() recently;
  final void Function() mostly;
  final void Function() playlist;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  List<SongModel> recentSong = [];
  void _navigate({required BuildContext context, required Widget child}) {
    Navigator.push(context, ThisIsFadeRoute(route: child));
  }

  Widget _audioDataLabelWIthListenable(
      {required ValueListenable<List<SongModel>> valueListenable}) {
    return ValueListenableBuilder<List<SongModel>>(
        valueListenable: valueListenable,
        builder: (context, value, child) {
          return Text(
            value.length.toString(),
            style: const TextStyle(
                shadows: [
                  BoxShadow(
                    color: Color.fromARGB(90, 63, 63, 63),
                    blurRadius: 15,
                    offset: Offset(-2, 2),
                  ),
                ],
                fontSize: 40,
                fontFamily: 'coolvetica',
                fontWeight: FontWeight.bold,
                color: Colors.white),
          );
        });
  }

  Widget _audioDataWithoutListenable({required String audioData}) {
    return Text(
      audioData,
      style: const TextStyle(
          shadows: [
            BoxShadow(
              color: Color.fromARGB(90, 63, 63, 63),
              blurRadius: 15,
              offset: Offset(-2, 2),
            ),
          ],
          fontSize: 40,
          fontFamily: 'coolvetica',
          fontWeight: FontWeight.bold,
          color: Colors.white),
    );
  }

  Widget getItemByIndex(int index, List<String> audioData) {
    if (index == 0) {
      return _audioDataWithoutListenable(audioData: audioData[index]);
    } else if (index == 1) {
      return _audioDataWithoutListenable(audioData: audioData[index]);
    } else if (index == 2) {
      return _audioDataWithoutListenable(audioData: audioData[index]);
    } else if (index == 3) {
      return _audioDataLabelWIthListenable(
          valueListenable: FavoriteDb.favoriteSongs);
    } else {
      return _audioDataWithoutListenable(audioData: audioData[index]);
    }
  }

  void _playlist() {
    widget.playlist();
  }

  void _favorite() {
    widget.favorite();
  }

  void _songs() {
    widget.songs();
  }

  void _recenlty() {
    widget.recently();
  }

  void _mostly() {
    widget.mostly();
  }

  @override
  void initState() {
    super.initState();
    MostlyPlayedDB.getMostlyPlayedSongs();
    RecentlyPlayedDB.getRecentlyPlayedSongs();
    // MostPlayedDB.getMostPlayedSongs();
    // Provider.of<HomePageSongProvider>(context).fetchRecentSongs();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   Provider.of<HomePageSongProvider>(context).fetchRecentSongs();
  // }

  final ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final allSongsData = Provider.of<HomePageSongProvider>(context);
    final albumData = Provider.of<AlbumProvider>(context);
    final artistData = Provider.of<ArtistProvider>(context);
    final favoriteData = FavoriteDb.favoriteSongsLength;
    final playlistData = PlayListDB.playListDb.length;
    List<String> audioData = [
      allSongsData.songs.length.toString(),
      albumData.totalAlbums.toString(),
      artistData.totalArtists.toString(),
      favoriteData.toString(),
      playlistData.toString()
    ];
    List<void Function()> navigationController = [
      _songs,
      () {
        _navigate(context: context, child: const AlbumList());
      },
      () {
        _navigate(context: context, child: const ArtistList());
      },
      _favorite,
      _playlist,
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Home",
          style: TextStyle(
              shadows: const [
                BoxShadow(
                  color: Color.fromARGB(90, 63, 63, 63),
                  blurRadius: 15,
                  offset: Offset(-2, 2),
                ),
              ],
              fontSize: 25,
              fontFamily: 'rounder',
              letterSpacing: 1,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).cardColor),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            decelerationRate: ScrollDecelerationRate.normal),
        controller: _controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.11,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: audioData.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InkWell(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: navigationController[index],
                    child: Container(
                      width: MediaQuery.sizeOf(context).width *
                          0.28, // Adjust the size as needed
                      margin: const EdgeInsets.only(
                          left: 8, right: 8, top: 8, bottom: 12),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              // Colors.deepPurple[300],
                              // Colors.deepPurple[500],
                              Colors.deepPurple[300],
                              Colors.deepPurple[500],
                            ].cast(),
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context).primaryColorDark,
                                offset: Offset(-8, 8),
                                blurRadius: 7,
                                spreadRadius: -5),
                            BoxShadow(
                                color: Theme.of(context).primaryColorLight,
                                offset: Offset(7, -7),
                                blurRadius: 7,
                                spreadRadius: -5),
                          ]),
                      child: FittedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            getItemByIndex(index, audioData),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                audioSectionNames[index].toUpperCase(),
                                style: const TextStyle(
                                    shadows: [
                                      BoxShadow(
                                        color: Color.fromARGB(90, 63, 63, 63),
                                        blurRadius: 15,
                                        offset: Offset(-2, 2),
                                      ),
                                    ],
                                    fontSize: 15,
                                    fontFamily: 'coolvetica',
                                    letterSpacing: 1,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            ValueListenableBuilder(
                valueListenable: RecentlyPlayedDB.recentlyplayedSongNotifier,
                builder: (BuildContext context, List<SongModel> value,
                    Widget? child) {
                  return value.length > 12
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: InkWell(
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                            onTap: _recenlty,
                            child: Text(
                              "Recently played",
                              style: TextStyle(
                                  shadows: const [
                                    BoxShadow(
                                      color: Color.fromARGB(90, 63, 63, 63),
                                      blurRadius: 15,
                                      offset: Offset(-2, 2),
                                    ),
                                  ],
                                  fontSize: 25,
                                  fontFamily: 'rounder',
                                  letterSpacing: .5,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).cardColor),
                            ),
                          ),
                        )
                      : SizedBox.shrink();
                }),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.22,
              child: ValueListenableBuilder(
                  valueListenable: RecentlyPlayedDB.recentlyplayedSongNotifier,
                  builder: (BuildContext context, List<SongModel> value,
                      Widget? child) {
                    final temp = value.reversed.toList();
                    recentSong = temp.toSet().toList();

                    return value.length > 12
                        ? ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: recentSong.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              if (index < 12) {
                                return InkWell(
                                  onTap: () async {
                                    if (GetSongs.player.playing != true) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => NowPlaying(
                                                  songModelList:
                                                      GetSongs.playingSongs)));
                                    }

                                    await RecentlyPlayedDB.addRecentlyPlayed(
                                        recentSong[index]);
                                    await MostlyPlayedDB.incrementPlayCount(
                                        recentSong[index]);
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
                                    GetSongs.songscopy = recentSong;
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.26,
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.12,
                                          // Adjust the size as needed
                                          margin: const EdgeInsets.only(
                                              left: 8,
                                              right: 8,
                                              top: 14,
                                              bottom: 12),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              boxShadow: []),
                                          child: AudioArtworkDefiner(
                                            id: recentSong[index].id,
                                            imgRadius: 15,
                                          )),
                                      SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.05,
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.25,
                                        child: Text(
                                          recentSong[index].title,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              shadows: const [
                                                BoxShadow(
                                                  color: Color.fromARGB(
                                                      90, 89, 89, 89),
                                                  blurRadius: 15,
                                                  offset: Offset(-2, 2),
                                                ),
                                              ],
                                              fontSize: 13,
                                              fontFamily: 'rounder',
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  Theme.of(context).cardColor),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          )
                        : SizedBox.shrink();
                  }),
            ),
            ValueListenableBuilder(
                valueListenable: MostlyPlayedDB.mostlyPlayedSongNotifier,
                builder: (BuildContext context, List<SongModel> mostplayed,
                    Widget? child) {
                  return mostplayed.length > 8
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: InkWell(
                            onTap: _mostly,
                             overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                            child: Text(
                              "Mostly Played",
                              style: TextStyle(
                                  shadows: const [
                                    BoxShadow(
                                      color: Color.fromARGB(90, 63, 63, 63),
                                      blurRadius: 15,
                                      offset: Offset(-2, 2),
                                    ),
                                  ],
                                  fontSize: 25,
                                  fontFamily: 'rounder',
                                  letterSpacing: .5,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).cardColor),
                            ),
                          ),
                        )
                      : SizedBox.shrink();
                }),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.30,
              child: ValueListenableBuilder<List<SongModel>>(
                  valueListenable: MostlyPlayedDB.mostlyPlayedSongNotifier,
                  builder: (BuildContext context, List<SongModel> mostplayed,
                      Widget? child) {
                    return mostplayed.length > 8
                        ? PageView.builder(
                            physics: PageScrollPhysics(),
                            itemCount: 3,

                            // scrollBehavior: MozScrollBehaviour(),
                            itemBuilder: (context, pageIndex) {
                              return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                itemCount: mostplayed.length < 3
                                    ? mostplayed.length
                                    : 3,
                                itemBuilder: (context, listviewindex) {
                                  List<SongModel> items;
                                  if (pageIndex == 0) {
                                    items = mostplayed.sublist(0, 3);
                                  } else if (pageIndex == 1) {
                                    items = mostplayed.sublist(3, 6);
                                  } else {
                                    items = mostplayed.sublist(6, 9);
                                  }
                                  final playCount = MostlyPlayedDB.getPlayCount(
                                      items[listviewindex].id);

                                  return ListTile(
                                    contentPadding: EdgeInsets.only(
                                        top: 8, right: 8, left: 8),
                                    leading: SizedBox(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.18,
                                      width: MediaQuery.sizeOf(context).width *
                                          0.16,
                                      child: AudioArtworkDefiner(
                                        id: items[listviewindex].id,
                                        imgRadius: 10,
                                        iconSize: 25,
                                      ),
                                    ),
                                    title: Text(
                                      items[listviewindex].title,
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
                                          color: Theme.of(context).cardColor),
                                    ),
                                    subtitle: Text(
                                      artistHelper(
                                          items[listviewindex]
                                              .artist
                                              .toString(),
                                          ''),
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
                                    trailing: Column(
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
                                    onTap: () async {
                                      if (GetSongs.player.playing != true) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    NowPlaying(
                                                        songModelList: GetSongs
                                                            .playingSongs)));
                                      }

                                      await RecentlyPlayedDB.addRecentlyPlayed(
                                          items[listviewindex]);
                                      await MostlyPlayedDB.incrementPlayCount(
                                          items[listviewindex]);
                                      GetSongs.player.setAudioSource(
                                          GetSongs.createSongList(
                                            items,
                                          ),
                                          initialIndex: listviewindex);
                                      GetSongs.player.play();
                                      GetSongs.player.playerStateStream
                                          .listen((playerState) {
                                        if (playerState.processingState ==
                                            ProcessingState.completed) {
                                          // Check if the current song is the last song in the playlist
                                          if (GetSongs.player.currentIndex ==
                                              items.length - 1) {
                                            // Rewind the playlist to the starting index
                                            GetSongs.player
                                                .seek(Duration.zero, index: 0);
                                          }
                                        }
                                      });
                                    },
                                  );
                                },
                              );
                            },
                          )
                        : SizedBox.shrink();
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Text(
                "Last Added",
                style: TextStyle(
                    shadows: const [
                      BoxShadow(
                        color: Color.fromARGB(90, 63, 63, 63),
                        blurRadius: 15,
                        offset: Offset(-2, 2),
                      ),
                    ],
                    fontSize: 25,
                    fontFamily: 'rounder',
                    letterSpacing: .5,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).cardColor),
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.22,
              child: Consumer<HomePageSongProvider>(
                  builder: (context, lastAddedSong, child) {
                final currentSongDate =
                    sortSongs(lastAddedSong.songs, SortOption.adate)
                        .sublist(0, 10);

                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: currentSongDate.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if (index < 10) {
                      return InkWell(
                        onTap: () async {
                          if (GetSongs.player.playing != true) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NowPlaying(
                                        songModelList: GetSongs.playingSongs)));
                          }

                          await RecentlyPlayedDB.addRecentlyPlayed(
                              currentSongDate[index]);
                          await MostlyPlayedDB.incrementPlayCount(
                              currentSongDate[index]);
                          GetSongs.player.setAudioSource(
                              GetSongs.createSongList(
                                currentSongDate,
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
                                GetSongs.player.seek(Duration.zero, index: 0);
                              }
                            }
                          });
                          // GetSongs.songscopy = currentSongDate;
                        },
                        child: Column(
                          children: [
                            Container(
                                width: MediaQuery.sizeOf(context).width * 0.26,
                                height:
                                    MediaQuery.sizeOf(context).height * 0.12,
                                // Adjust the size as needed
                                margin: const EdgeInsets.only(
                                    left: 8, right: 8, top: 14, bottom: 12),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: []),
                                child: AudioArtworkDefiner(
                                  id: currentSongDate[index].id,
                                  imgRadius: 15,
                                )),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.05,
                              width: MediaQuery.sizeOf(context).width * 0.25,
                              child: Text(
                                currentSongDate[index].title,
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
                      return const SizedBox.shrink();
                    }
                  },
                );
              }),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.18,
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
