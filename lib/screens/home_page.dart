// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:music_player/DATABASE/favorite_db.dart';
import 'package:music_player/WIDGETS/drawer_widget.dart';
import 'package:music_player/screens/search_music_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ANIMATION/slide_animation.dart';
import '../CONTROLLER/song_controllers.dart';
import '../HELPER/sort_enum.dart';
import '../WIDGETS/buttons/sort_menu_button.dart';
import '../WIDGETS/indicators.dart';
import '../WIDGETS/permission.dart';
import '../WIDGETS/song_list_maker.dart';
import 'dart:async';

List<SongModel> startSong = [];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin<HomePage> {
  @override
  bool get wantKeepAlive => true;

  Future<void> saveSortOption(SortOption value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('sortOption', value.index);
  }

  Future<SortOption> getSortOption() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt('sortOption');
    return SortOption.values[index ?? 0];
  }

  SortOption _sortOption = SortOption.adate;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  void setSortOption(SortOption sortOption) {
    setState(() {
      _sortOption = sortOption;
    });
    saveSortOption(sortOption);
  }

  void requestPermission(BuildContext context) async {
    final status = await Permission.manageExternalStorage.status;
    if (status.isDenied) {
      await Permission.manageExternalStorage.request();
    }

    final storageStatus = await Permission.storage.status;
    if (storageStatus.isDenied) {
      await Permission.storage.request();
    }

    setState(() {
      _songsFuture = querySongs(_sortOption);
    });
  }

  void toggleValue(SortOption? value) {
    if (value != null) {
      setState(() {
        _sortOption = value;
      });
      saveSortOption(value);
    }
  }

  final OnAudioQuery _audioQuery = OnAudioQuery();
  Future<List<SongModel>> querySongs(SortOption sortOption) async {
    final sortType = _getSortType(sortOption);
    const status = PermissionStatus.granted;
    if (!status.isGranted) {
      return Future.error('Permission Not Granted');
    }
    final songs = await _audioQuery.querySongs(
      sortType: sortType,
      orderType: OrderType.DESC_OR_GREATER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    // Filter out unwanted songs
    final filteredSongs = songs.where((song) {
      final displayName = song.displayName.toLowerCase();
      return !displayName.contains(".opus") &&
          !displayName.contains("aud") &&
          !displayName.contains("recordings") &&
          !displayName.contains("recording") &&
          !displayName.contains("MIDI") &&
          !displayName.contains("pxl") &&
          !displayName.contains("Record") &&
          !displayName.contains("VID") &&
          !displayName.contains("whatsapp");
    }).toList();
    return filteredSongs;
  }

  SongSortType _getSortType(SortOption sortOption) {
    switch (sortOption) {
      case SortOption.atitle:
        return SongSortType.TITLE;
      case SortOption.aartist:
        return SongSortType.ARTIST;
      case SortOption.aduration:
        return SongSortType.DURATION;
      case SortOption.adate:
        return SongSortType.DATE_ADDED;
      case SortOption.afileSize:
        return SongSortType.SIZE;
      default:
        return SongSortType.DATE_ADDED;
    }
  }

  List<SongModel> sortSongs(List<SongModel> songs, SortOption sortOption) {
    switch (sortOption) {
      case SortOption.atitle:
        songs.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortOption.ztitle:
        songs.sort((a, b) => b.title.compareTo(a.title));
        break;
      case SortOption.aartist:
        songs
            .sort((a, b) => a.artist.toString().compareTo(b.artist.toString()));
        break;
      case SortOption.zartist:
        songs
            .sort((a, b) => b.artist.toString().compareTo(a.artist.toString()));
        break;
      case SortOption.aduration:
        songs.sort((a, b) => a.duration!.compareTo(b.duration!));
        break;
      case SortOption.zduaration:
        songs.sort((a, b) => b.duration!.compareTo(a.duration!));
        break;
      case SortOption.adate:
        songs.sort((a, b) => b.dateAdded!.compareTo(a.dateAdded!));
        break;
      case SortOption.zdate:
        songs.sort((a, b) => a.dateAdded!.compareTo(b.dateAdded!));
        break;
      case SortOption.afileSize:
        songs.sort((a, b) => b.size.compareTo(a.size));
        break;
      case SortOption.zfileSize:
        songs.sort((a, b) => a.size.compareTo(b.size));
        break;
    }
    return songs;
  }

  Future<void> _handleRefresh() async {
    // Simulate a delay for fetching new data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {});
  }

  Future<List<SongModel>>? _songsFuture;
  @override
  void initState() {
    super.initState();
    requestPermission(context);
    getSortOption().then((SortOption value) {
      setState(() {
        _sortOption = value;
      });
    });
    _sortOption = SortOption.adate;
    const status = PermissionStatus.granted;
    if (status.isGranted) {
      _songsFuture = querySongs(_sortOption);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Make sure to call super.build(context)
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return Scaffold(
        key: scaffoldKey,
        drawer: drawerWidget(context: context, scaffoldKey: scaffoldKey),
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
            child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      SliverAppBar(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        systemOverlayStyle: SystemUiOverlayStyle(
                          statusBarColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          systemNavigationBarColor:
                              Theme.of(context).scaffoldBackgroundColor,
                        ),
                        centerTitle: true,
                        shadowColor: Theme.of(context).scaffoldBackgroundColor,
                        elevation: 1,
                        expandedHeight:
                            MediaQuery.of(context).size.height * 0.17,
                        flexibleSpace: FlexibleSpaceBar(
                          title: Padding(
                            padding: EdgeInsets.only(
                              left: 0,
                              top: MediaQuery.of(context).size.height * 0.01,
                              right: MediaQuery.of(context).size.width * 0.07,
                            ),
                            child: Text(
                              "Moz MUSIC",
                              style: TextStyle(
                                fontFamily: 'optica',
                                fontWeight: FontWeight.w500,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.06,
                                color: Theme.of(context).cardColor,
                                letterSpacing: .1,
                              ),
                            ),
                          ),
                        ),
                        leading: InkWell(
                          onTap: () {
                            scaffoldKey.currentState?.openDrawer();
                          },
                          child: Icon(
                            Icons.menu,
                            color: Theme.of(context).cardColor,
                          ),
                        ),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                SearchAnimationNavigation(const SearchPage()),
                              );
                            },
                            icon: Transform.scale(
                              scale: MediaQuery.of(context).size.width * 0.003,
                              child: Icon(
                                Icons.search,
                                color: Theme.of(context).cardColor,
                              ),
                            ),
                            splashColor: Colors.transparent,
                          ),
                          IconButton(
                              onPressed: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (context) {
                                    return SortOptionBottomSheet(
                                        selectedOption: _sortOption,
                                        onSelected: toggleValue);
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.more_vert,
                                color: Theme.of(context).cardColor,
                              ))
                        ],
                        pinned: true,
                      ),
                    ],
                body: RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: Colors.deepPurple[400],
                  displacement: 80.0,
                  onRefresh: _handleRefresh,
                  child: FutureBuilder<List<SongModel>>(
                    future: _songsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return circleProgress(context);
                      } else if (snapshot.data!.isEmpty) {
                        return songEmpty(context, "NO Songs Found", () {
                          setState(() {
                            _songsFuture = querySongs(_sortOption);
                          });
                        });
                      } else if (snapshot.hasError) {
                        return songEmpty(
                            context, "Error occurred: ${snapshot.error}",(){});
                      } else {
                        startSong = snapshot.data!;
                        GetSongs.songscopy = snapshot.data!;

                        if (!FavoriteDb.isInitialized) {
                          FavoriteDb.intialize(snapshot.data!);
                        }
                        // if (!RecentlyPlayedDB.isInitialized) {
                        //   RecentlyPlayedDB.intialize(snapshot.data!);
                        // }
                      }

                      final sortedSongs =
                          sortSongs(snapshot.data!, _sortOption);
                      return AnimationLimiter(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              delay: const Duration(milliseconds: 100),
                              child: SlideAnimation(
                                duration: const Duration(milliseconds: 2500),
                                curve: Curves.fastLinearToSlowEaseIn,
                                horizontalOffset: 30,
                                verticalOffset: 300.0,
                                child: FlipAnimation(
                                  duration: const Duration(milliseconds: 3000),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  flipAxis: FlipAxis.y,
                                  child: songDisplay(
                                    context,
                                    id: sortedSongs[index].id,
                                    title: sortedSongs[index].title,
                                    artist:
                                        sortedSongs[index].artist.toString(),
                                    exten: sortedSongs[index].fileExtension,
                                    duration:
                                        sortedSongs[index].duration.toString(),
                                    inittialIndex: index,
                                    genre: sortedSongs[index].genre.toString(),
                                    composer:
                                        sortedSongs[index].composer.toString(),
                                    songs: sortedSongs,
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: startSong.length,
                        ),
                      );
                    },
                  ),
                ))));
  }
}
