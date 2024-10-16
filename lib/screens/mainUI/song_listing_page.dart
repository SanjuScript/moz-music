// ignore_for_file: unrelated_type_equality_checks
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:music_player/DATABASE/favorite_db.dart';
import 'package:music_player/PROVIDER/homepage_provider.dart';
import 'package:music_player/PROVIDER/remove_song_provider.dart';
import 'package:music_player/WIDGETS/custom_slider.dart';
import 'package:music_player/WIDGETS/drawer_widget.dart';
import 'package:music_player/SCREENS/search_music_screen.dart';
import 'package:music_player/screens/favoritepage/favorite_button.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../ANIMATION/slide_animation.dart';
import '../../CONTROLLER/song_controllers.dart';
import '../../DATABASE/recently_played.dart';
import '../../HELPER/sort_enum.dart';
import '../../WIDGETS/buttons/sort_menu_button.dart';
import '../../WIDGETS/song_list_maker.dart';

List<SongModel> startSong = [];

class SongListingPage extends StatefulWidget {
  const SongListingPage({Key? key}) : super(key: key);

  @override
  State<SongListingPage> createState() => _SongListingPageState();
}

class _SongListingPageState extends State<SongListingPage>
    with
        AutomaticKeepAliveClientMixin,
        TickerProviderStateMixin<SongListingPage> {
  @override
  bool get wantKeepAlive => true;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _setup();
  }

  void _setup() {
    final homepageState =
        Provider.of<HomePageSongProvider>(context, listen: false);
    homepageState.checkPermissionsAndQuerySongs(
        homepageState.defaultSort, context);
    getSortOption().then((SortOption value) {
      homepageState.defaultSort = value;
    });
  }

  List<SongModel> selectedSongs = [];

  @override
  Widget build(BuildContext context) {
    log("Song listing page rebuilds");
    super.build(context);
    final homepageState = Provider.of<HomePageSongProvider>(context);
    final removeSongList = Provider.of<RemoveSongFromList>(context);
    final removehomepageState =
        Provider.of<HomePageSongProvider>(context, listen: false);
    if (homepageState.permissionGranted) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          key: scaffoldKey,
          drawer: drawerWidget(context: context, scaffoldKey: scaffoldKey),
          extendBody: true,
          extendBodyBehindAppBar: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  surfaceTintColor: Colors.transparent,
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
                          fontFamily: 'rounder',
                          fontWeight: FontWeight.w500,
                          fontSize: MediaQuery.of(context).size.width * 0.06,
                          color: Theme.of(context).disabledColor,
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
                    if (removeSongList.isSelect)
                      IconButton.filled(
                        style: IconButton.styleFrom(
                            backgroundColor: Colors.red[300]),
                        onPressed: () {
                          removeSongList.setValue = false;
                          setState(() {
                            selectedSongs.clear();
                          });
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
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
                            backgroundColor: Colors.transparent,
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
                        } else if (value == 'select') {
                          // homepageState.resetRemovedSongs();
                          removeSongList.setValue = true;
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'sort',
                          child: ListTile(
                            leading: Icon(Icons.sort,
                                color: Theme.of(context).cardColor),
                            title: Text(
                              'Sort',
                              style:
                                  TextStyle(color: Theme.of(context).cardColor),
                            ),
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'select',
                          child: ListTile(
                            leading: Icon(Icons.select_all,
                                color: Theme.of(context).cardColor),
                            title: Text(
                              'select Songs',
                              style:
                                  TextStyle(color: Theme.of(context).cardColor),
                            ),
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    )
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
                      return Center(
                        child: Lottie.asset('assets/loading.json',
                            frameRate: FrameRate.max,
                            height: 100.0,
                            repeat: true,
                            animate: true),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          "NO Songs Found",
                          style: TextStyle(
                            fontFamily: 'coolvetica',
                            color: Theme.of(context).cardColor,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.030,
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
                            fontSize:
                                MediaQuery.of(context).size.height * 0.030,
                          ),
                        ),
                      );
                    } else {
                      startSong = snapshot.data!;
                      MozController.songscopy =
                          sortSongs(snapshot.data!, homepageState.defaultSort);

                      if (!FavoriteDb.isInitialized ||
                          !RecentDb.isInitialized) {
                        FavoriteDb.intialize(snapshot.data!);
                        RecentDb.initialize(snapshot.data!);
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
                                    duration:
                                        const Duration(milliseconds: 2500),
                                    curve: Curves.fastLinearToSlowEaseIn,
                                    child: FadeInAnimation(
                                      duration:
                                          const Duration(milliseconds: 2500),
                                      curve: Curves.fastLinearToSlowEaseIn,
                                      child: SongDisplay(
                                          isSelecting: selectedSongs.isNotEmpty,
                                          isTrailingChange: true,
                                          trailing: removeSongList.isSelect
                                              ? Checkbox.adaptive(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100)),
                                                  value: selectedSongs
                                                      .contains(song),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      if (value == true) {
                                                        selectedSongs.add(song);
                                                      } else {
                                                        selectedSongs
                                                            .remove(song);
                                                      }
                                                    });
                                                  },
                                                )
                                              : FavoriteButton(
                                                  songFavorite: song),
                                          song: song,
                                          remove: null,
                                          songs: sortedSongs,
                                          index: index),
                                    ),
                                  ),
                                );
                              },
                            ),
                            // const SongSections()
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: selectedSongs.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.sizeOf(context).height * .18),
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height * .05,
                    width: MediaQuery.sizeOf(context).width * .45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.redAccent,
                        shadowColor: Colors.black.withOpacity(0.5),
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                      ),
                      onPressed: () {
                        homepageState.removeSongs(selectedSongs);
                        setState(() {
                          selectedSongs.clear();
                        });

                        removeSongList.setValue = false;
                      },
                      child: Text(
                        "Remove Selected- ${selectedSongs.length}",
                        maxLines: 2,
                        key: ValueKey<int>(1),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: .5,
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox(),
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
                  openAppSettings().then((value) {
                    homepageState.checkPermissionsAndQuerySongs(
                        homepageState.defaultSort, context,
                        isallowed: true);
                  });
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
