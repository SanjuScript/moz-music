// ignore_for_file: unrelated_type_equality_checks
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:music_player/DATABASE/favorite_db.dart';
import 'package:music_player/PROVIDER/homepage_provider.dart';
import 'package:music_player/WIDGETS/drawer_widget.dart';
import 'package:music_player/SCREENS/search_music_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../ANIMATION/slide_animation.dart';
import '../CONTROLLER/song_controllers.dart';
import '../HELPER/sort_enum.dart';
import '../WIDGETS/buttons/sort_menu_button.dart';
import '../WIDGETS/song_list_maker.dart';
import '../WIDGETS/song_sections.dart';

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
  // List<SongModel> selectedSongs = [];

  @override
  void initState() {
    super.initState();
    final homepageState =
        Provider.of<HomePageSongProvider>(context, listen: false);
    homepageState.checkPermissionsAndQuerySongs(homepageState.defaultSort);
    getSortOption().then((SortOption value) {
      setState(() {
        homepageState.defaultSort = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Make sure to call super.build(context)
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    final homepageState = Provider.of<HomePageSongProvider>(context);
    if (homepageState.permissionGranted) {
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
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Theme.of(context).scaffoldBackgroundColor,
                  systemNavigationBarColor:
                      Theme.of(context).scaffoldBackgroundColor,
                ),
                centerTitle: true,
                shadowColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 1,
                expandedHeight: MediaQuery.of(context).size.height * 0.17,
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
                        fontSize: MediaQuery.of(context).size.width * 0.06,
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
                  PopupMenuButton<String>(
                    
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    icon: Icon(
                      Icons.more_vert_rounded,
                      color: Theme.of(context).cardColor,
                    ),
                    color: Theme.of(context).splashColor,
                    onSelected: (value) {
                      if (value == 'sort') {
                        showModalBottomSheet<void>(
                          backgroundColor: Theme.of(context).splashColor,
                          context: context,
                          builder: (context) {
                            return SortOptionBottomSheet(
                              selectedOption: homepageState.defaultSort,
                              onSelected: (value) {
                                homepageState.toggleValue(value);
                              },
                            );
                          },
                        );
                      } else if (value == 'reset') {
                        homepageState.resetRemovedSongs();
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'sort',
                        child: ListTile(
                          leading: Icon(
                            Icons.sort,
                            color: Theme.of(context).cardColor,
                          ),
                          title: Text(
                            'Sort',
                            style: TextStyle(
                              color: Theme.of(context).cardColor,
                            ),
                          ),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'reset',
                        child: ListTile(
                          leading: Icon(
                            Icons.restart_alt_outlined,
                            color: Theme.of(context).cardColor,
                          ),
                          title: Text(
                            'Reset song ',
                            style: TextStyle(
                              color: Theme.of(context).cardColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                pinned: true,
              ),
            ],
            body: RefreshIndicator(
              color: Colors.white,
              backgroundColor: Colors.deepPurple[400],
              displacement: 80.0,
              onRefresh: homepageState.handleRefresh,
              child: FutureBuilder<List<SongModel>>(
                future: homepageState.songsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        "NO Songs Found",
                        style: TextStyle(
                          fontFamily: 'coolvetica',
                          color: Theme.of(context).cardColor,
                          fontSize: MediaQuery.of(context).size.height * 0.030,
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error occurred: ${snapshot.error}",
                        style: TextStyle(
                          fontFamily: 'coolvetica',
                          color: Theme.of(context).cardColor,
                          fontSize: MediaQuery.of(context).size.height * 0.030,
                        ),
                      ),
                    );
                  } else {
                    startSong = snapshot.data!;
                    GetSongs.songscopy = snapshot.data!;

                    if (!FavoriteDb.isInitialized) {
                      FavoriteDb.intialize(snapshot.data!);
                    }
                    // if (!RecentlyPlayedDB.isInitialized) {
                    //   RecentlyPlayedDB.intialize(snapshot.data!);
                    // }

                    final sortedSongs =
                        sortSongs(snapshot.data!, homepageState.defaultSort);
                    return AnimationLimiter(
                      child: Stack(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics(),
                            ),
                            itemCount: sortedSongs.length,
                            itemBuilder: (context, index) {
                              final song = sortedSongs[index];

                              return AnimationConfiguration.staggeredList(
                                position: index,
                                delay: const Duration(milliseconds: 100),
                                child: SlideAnimation(
                                  duration: const Duration(milliseconds: 2500),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  child: FadeInAnimation(
                                    duration:
                                        const Duration(milliseconds: 2500),
                                    curve: Curves.fastLinearToSlowEaseIn,
                                    child: songDisplay(context, song: song,
                                        remove: () {
                                      homepageState.removeSong(song);
                                      Navigator.pop(context);
                                    }, songs: sortedSongs, index: index),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SongSections()
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      );
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
                    homepageState.checkPermissionsAndQuerySongs(
                        homepageState.defaultSort);
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
