import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:flutter/services.dart';
import 'package:music_player/DATABASE/favorite_db.dart';
import 'package:music_player/DATABASE/most_played.dart';
import 'package:music_player/DATABASE/playlistDb.dart';
import 'package:music_player/DATABASE/recently_played.dart';
// import 'package:music_player/HELPER/audio_handler.dart';
import 'package:music_player/Model/music_model.dart';
import 'package:music_player/PROVIDER/album_song_list_provider.dart';
import 'package:music_player/PROVIDER/artist_provider.dart';
import 'package:music_player/PROVIDER/artist_song_provider.dart';
import 'package:music_player/PROVIDER/bottom_nav_provider.dart';
import 'package:music_player/PROVIDER/color_extraction.dart';
import 'package:music_player/PROVIDER/device_info_provider.dart';
import 'package:music_player/PROVIDER/homepage_provider.dart';
import 'package:music_player/PROVIDER/miniplayer_provider.dart';
import 'package:music_player/PROVIDER/now_playing_provider.dart';
import 'package:music_player/PROVIDER/sleep_timer_provider.dart';
import 'package:music_player/PROVIDER/theme_class_provider.dart';
import 'package:music_player/SCREENS/about.dart';
import 'package:music_player/SCREENS/const_splashScreen.dart';
import 'package:music_player/SCREENS/playlist/playList_song_listpage.dart';
import 'package:music_player/SCREENS/playlist/playlistSong_display_screen.dart';
import 'package:music_player/SCREENS/privacy_policy.dart';
import 'package:music_player/SCREENS/song_info.dart';
import 'package:music_player/SCREENS/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'COLORS/colors.dart';
import 'PROVIDER/album_provider.dart';

int? isViewed;
// MozMusicHandler mozMusicHandler = MozMusicHandler();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  isViewed = prefs.getInt('onBoard');
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(MusicModelAdapter().typeId)) {
    Hive.registerAdapter(MusicModelAdapter());
  }
  await Hive.openBox('recentlyPlayed');
  await Hive.openBox('mostlyPlayed');
  await Hive.openBox<int>('FavoriteDB');
  await Hive.openBox('songsBox');
  await Hive.openBox<MusicModel>('playlistDB');
  await RecentlyPlayedDB.getRecentlyPlayedSongs();
  await MostlyPlayedDB.getMostlyPlayedSongs();
  FavoriteDb.favoriteSongs;
  await PlayListDB.getAllPlaylist();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(0, 0, 0, 0),
    ),
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Moz Audio playback',
      androidNotificationOngoing: true,
      androidShowNotificationBadge: true,
      preloadArtwork: true,
      artDownscaleHeight: 100,
      artDownscaleWidth: 100,
      notificationColor: const Color.fromARGB(255, 169, 142, 174));

// mozMusicHandler =  await AudioService.init(
//     builder: () => MozMusicHandler(),
//     config: const AudioServiceConfig(
//       // androidNotificationChannelId: 'com.musicapp.example',
//       androidNotificationChannelName: 'Audio Playback',
//       androidNotificationOngoing: true,
//     ),
//   );
  SharedPreferences.getInstance().then(
    (prefs) async {
      var darkModeON = prefs.getBool('darkMode') ?? true;

      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: ((context) => ThemeProvider(darkModeON
                  ? CustomThemes.lightThemeMode
                  : CustomThemes.darkThemeMode)),
            ),
            ChangeNotifierProvider(
              create: ((context) => SleepTimeProvider()),
            ),
            ChangeNotifierProvider(
              create: ((context) => MiniplayerProvider()),
            ),
            ChangeNotifierProvider(
              create: ((context) => NowPlayingProvider()),
            ),
            ChangeNotifierProvider(
              create: (context) => AlbumProvider(),
            ),
            ChangeNotifierProvider(
              create: (context) => ArtistSongListProvider(),
            ),
            ChangeNotifierProvider(
              create: (context) => ArtistProvider(),
            ),
            ChangeNotifierProvider(
              create: (context) => HomePageSongProvider(),
            ),
            ChangeNotifierProvider(
              create: (context) => DeviceInformationProvider(),
            ),
            ChangeNotifierProvider(
              create: (context) => SongListProvider(),
            ),
            ChangeNotifierProvider(
              create: ((context) => BottomNavProvider()),
            ),
            ChangeNotifierProvider(
              create: ((context) => ArtworkColorProvider()),
            ),
          ],
          child: const MyApp(),
        ),
      );
      // SystemChrome.setEnabledSystemUIMode(SystemUiMode.);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    log('My app rebuilds');
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          home: isViewed != 0
              ? const OneTimeSplashScreen()
              : const SplashScreen(),
          theme: themeProvider.gettheme(),
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                statusBarIconBrightness:
                    themeProvider.gettheme() == CustomThemes.darkThemeMode
                        ? Brightness.light
                        : Brightness.dark,
                // ... other style configurations
              ),
            );
            return child!;
          },
          routes: {
            '/playlistsong': (context) => const PlaylistSongDisplayScreen(),
            '/songInfo': (context) => const SongInfo(),
            '/playlistSongList': (context) => const PlayListSongListScreen(),
            '/about': (context) => const AboutPage(),
            '/privacyPage': (context) => const PrivacyPolicyPage(),
          },
        );
      },
    );
  }
}
