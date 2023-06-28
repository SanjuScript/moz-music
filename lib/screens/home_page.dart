// ignore_for_file: unrelated_type_equality_checks
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:music_player/DATABASE/favorite_db.dart';
import 'package:music_player/WIDGETS/drawer_widget.dart';
import 'package:music_player/WIDGETS/song_sections.dart';
import 'package:music_player/screens/album/album_list.dart';
import 'package:music_player/screens/search_music_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ANIMATION/slide_animation.dart';
import '../CONTROLLER/song_controllers.dart';
import '../HELPER/sort_enum.dart';
import '../WIDGETS/buttons/sort_menu_button.dart';
import '../WIDGETS/indicators.dart';
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


  var scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<SongModel>>? _songsFuture;
  void setSortOption(SortOption sortOption) {
    setState(() {
      defaultSort = sortOption;
    });
    saveSortOption(sortOption);
  }

  void toggleValue(SortOption? value) {
    if (value != null) {
      setState(() {
        defaultSort = value;
      });
      saveSortOption(value);
    }
  }

  bool permissionGranted = false;
  Future<void> _chechPermissions() async {
    final permStatus = Permission.storage.request();
    if (await permStatus.isDenied) {
      Permission.storage.request();
    }
    setState(() {
      permissionGranted = true;
      _songsFuture = querySongs(defaultSort);
    });
  }

  final OnAudioQuery _audioQuery = OnAudioQuery();
  Future<List<SongModel>> querySongs(SortOption sortOption) async {
    final sortType = getSortType(sortOption);
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

  Future<void> _handleRefresh() async {
    // Simulate a delay for fetching new data
    setState(() {
      _songsFuture = querySongs(defaultSort);
    });
  }

  @override
  void initState() {
    super.initState();
    _chechPermissions();
    getSortOption().then((SortOption value) {
      setState(() {
        defaultSort = value;
      });
    });
    defaultSort = SortOption.adate;
    const status = PermissionStatus.granted;
    if (status.isGranted) {
      _songsFuture = querySongs(defaultSort);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Make sure to call super.build(context)
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    if (permissionGranted) {
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
                          shadowColor:
                              Theme.of(context).scaffoldBackgroundColor,
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
                                scale:
                                    MediaQuery.of(context).size.width * 0.003,
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
                                          selectedOption: defaultSort,
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return circleProgress(context);
                        } else if (snapshot.data!.isEmpty) {
                          return songEmpty(context, "NO Songs Found", () {
                            setState(() {
                              _songsFuture = querySongs(defaultSort);
                            });
                          });
                        } else if (snapshot.hasError) {
                          return songEmpty(
                              context, "Error occurred: ${snapshot.error}", () {
                            setState(() {});
                          });
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
                            sortSongs(snapshot.data!, defaultSort);
                        return AnimationLimiter(
                          child: Stack(children: [
                            ListView.builder(
                              padding: EdgeInsets.symmetric(vertical: 30),
                              physics: const BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              itemBuilder: (context, index) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  delay: const Duration(milliseconds: 100),
                                  child: SlideAnimation(
                                    duration:
                                        const Duration(milliseconds: 2500),
                                    curve: Curves.fastLinearToSlowEaseIn,
                                    horizontalOffset: 30,
                                    verticalOffset: 300.0,
                                    child: FlipAnimation(
                                      duration:
                                          const Duration(milliseconds: 3000),
                                      curve: Curves.fastLinearToSlowEaseIn,
                                      flipAxis: FlipAxis.y,
                                      child: songDisplay(
                                        context,
                                        id: sortedSongs[index].id,
                                        title: sortedSongs[index].title,
                                        artist: sortedSongs[index]
                                            .artist
                                            .toString(),
                                        exten: sortedSongs[index].fileExtension,
                                        duration: sortedSongs[index]
                                            .duration
                                            .toString(),
                                        inittialIndex: index,
                                        genre:
                                            sortedSongs[index].genre.toString(),
                                        composer: sortedSongs[index]
                                            .composer
                                            .toString(),
                                        songs: sortedSongs,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: startSong.length,
                            ),
                          SongSections()
                          ]),
                        );
                      },
                    ),
                  ))));
    } else {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Permission Denied !!",
                style: TextStyle(
                  fontFamily: 'coolvetica',
                  color: Theme.of(context).cardColor,
                  fontSize: MediaQuery.of(context).size.height * 0.030,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.grey),
                onPressed: () async {
                  bool opened = await openAppSettings();
                  if (opened) {
                    _chechPermissions();
                  }
                },
                child: Text(
                  "Open Settings",
                  style: TextStyle(
                    fontFamily: 'coolvetica',
                    color: Theme.of(context).cardColor,
                    fontSize: MediaQuery.of(context).size.height * 0.030,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
