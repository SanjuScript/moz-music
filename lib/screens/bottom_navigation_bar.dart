// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:music_player/PROVIDER/bottom_nav_provider.dart';
import 'package:music_player/SCREENS/mainUI/home_page.dart';
import 'package:music_player/SCREENS/mainUI/most_played_songs.dart';
import 'package:music_player/SCREENS/playlist/playlist_screen.dart';
import 'package:music_player/PROVIDER/sleep_timer_provider.dart';
import 'package:music_player/SCREENS/mainUI/recently_played.dart';
import 'package:music_player/SCREENS/settings/setting.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../DATABASE/favorite_db.dart';
import '../CONTROLLER/song_controllers.dart';
import '../WIDGETS/bottomsheet/sleep_timer_sheet.dart';
import 'favoritepage/favoriteSongLists.dart';
import 'mainUI/song_listing_page.dart';
import 'mini_player.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectedIndex = 1;
  late PageController pageController;
  late List<Widget> pages = [];
  void onPageChange(int index) {
    final provider = context.read<BottomNavProvider>();
    provider.selectedIndex = index;
  }

  void navigateToPage(int index) {
    final provider = context.read<BottomNavProvider>();
    provider.navigateToPage(pageController, index);
  }

  @override
  void initState() {
    super.initState();
    final provider = context.read<BottomNavProvider>();
    pageController = provider.createPageController();
    pages = [
      _homepage(),
      const SongListingPage(),
      const FavoriteScreen(),
      const PlaylistScreen(),
      const RecentlyPlayed(),
      const MostlyPlayed(),
    ];
  }

  Widget _homepage() {
    return HomePage(favorite: () {
      navigateToPage(2);
    }, songs: () {
      navigateToPage(1);
    }, playlist: () {
      navigateToPage(3);
    }, recently: () {
      navigateToPage(4);
    }, mostly: () {
      navigateToPage(5);
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('Bottom Nav rebuilded');
    return WillPopScope(
      onWillPop: () async {
        if (selectedIndex != 0) {
          navigateToPage(0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        floatingActionButton: Consumer<SleepTimeProvider>(
          builder: (context, value, child) {
            return value.remainingTime > 0
                ? InkWell(
                    onTap: () {
                      sleepTimerBottomModalSheet(context);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.04,
                      width: MediaQuery.of(context).size.width * 0.18,
                      decoration: BoxDecoration(
                          color: Colors.deepPurple[400],
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Icon(
                              Icons.timer_sharp,
                              color: Color.fromARGB(255, 228, 229, 229),
                            ),
                            Text(
                              value.remainingTime.toString(),
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.042,
                                fontFamily: 'coolvetica',
                                fontWeight: FontWeight.w400,
                                color: const Color.fromARGB(255, 228, 229, 229),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox();
          },
        ),
        extendBody: true,
        body: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              if (selectedIndex > 0) {
                navigateToPage(selectedIndex - 1);
              }
            } else if (details.primaryVelocity! < 0) {
              if (selectedIndex < pages.length - 1) {
                navigateToPage(selectedIndex + 1);
              }
            }
          },
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: PageView(
              controller: pageController,
              onPageChanged: onPageChange,
              children: pages,
            ),
          ),
        ),
        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: FavoriteDb.favoriteSongs,
          builder:
              (BuildContext context, List<SongModel> music, Widget? child) {
            final provider = context.watch<BottomNavProvider>();
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MozController.player.currentIndex != null
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.098,
                        child: const MiniPlayer(),
                      )
                    : const SizedBox(),
                Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.085,
                    child: BottomNavigationBar(
                      showUnselectedLabels: false,
                      unselectedItemColor:
                          const Color.fromARGB(255, 63, 63, 63),
                      selectedFontSize:
                          MediaQuery.of(context).size.height * 0.01,
                      selectedItemColor: Colors.deepPurple[400],
                      selectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      currentIndex: provider.selectedIndex,
                      onTap: (int index) {
                        provider.selectedIndex = index;
                        navigateToPage(index);
                        // setState(() {
                        //   selectedIndex = index;
                        // });
                        // ignore: invalid_use_of_protected_member,
                        // FavoriteDb.favoriteSongs.notifyListeners();
                      },
                      items: <BottomNavigationBarItem>[
                        bottomNavBarMethod(
                          bottomNavBarIcon: Icons.home,
                          bottomNavBarLabel: 'Home',
                        ),
                        bottomNavBarMethod(
                          bottomNavBarIcon: Icons.library_music,
                          bottomNavBarLabel: 'Songs',
                        ),
                        bottomNavBarMethod(
                          bottomNavBarIcon: Icons.favorite,
                          bottomNavBarLabel: 'Favorites',
                        ),
                        bottomNavBarMethod(
                          bottomNavBarIcon: Icons.queue_music,
                          bottomNavBarLabel: 'Playlist',
                        ),
                        bottomNavBarMethod(
                          bottomNavBarIcon: Icons.music_note_outlined,
                          bottomNavBarLabel: 'Recently',
                        ),
                        bottomNavBarMethod(
                          bottomNavBarIcon: Icons.play_lesson_rounded,
                          bottomNavBarLabel: 'Most played',
                        ),
                       
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem bottomNavBarMethod({
    required IconData bottomNavBarIcon,
    required String bottomNavBarLabel,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(bottomNavBarIcon),
      label: bottomNavBarLabel,
    );
  }
}
