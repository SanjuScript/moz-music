import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:flutter/services.dart';
import 'package:music_player/Model/music_model.dart';
import 'package:music_player/PROVIDER/album_song_list_provider.dart';
import 'package:music_player/PROVIDER/artist_provider.dart';
import 'package:music_player/PROVIDER/artist_song_provider.dart';
import 'package:music_player/PROVIDER/miniplayer_provider.dart';
import 'package:music_player/PROVIDER/now_playing_provider.dart';
import 'package:music_player/PROVIDER/sleep_timer_provider.dart';
import 'package:music_player/PROVIDER/theme_class_provider.dart';
import 'package:music_player/SCREENS/playlist/playlist_screen.dart';
import 'package:music_player/screens/const_splashScreen.dart';
import 'package:music_player/screens/playlist/playlistSong_display_screen.dart';
import 'package:music_player/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'COLORS/colors.dart';
import 'PROVIDER/album_provider.dart';

int? isViewed;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isViewed = prefs.getInt('onBoard');
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(MusicModelAdapter().typeId)) {
    Hive.registerAdapter(MusicModelAdapter());
  }
  await Hive.openBox('recentlyPlayed');
  await Hive.openBox<int>('FavoriteDB');
  await Hive.openBox<MusicModel>('playlistDB');
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(0, 0, 0, 0),
      statusBarIconBrightness: Brightness.light));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SharedPreferences.getInstance().then((prefs) async {
    var darkModeON = prefs.getBool('darkMode') ?? true;
    await JustAudioBackground.init(
        androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
        androidShowNotificationBadge: true,
        preloadArtwork: true,
        artDownscaleHeight: 100,
        artDownscaleWidth: 100,
        notificationColor: Colors.purple[400]);

    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(
        create: ((context) =>
            ThemeProvider(darkModeON ? lightThemeMode : darkThemeMode)),
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
      ChangeNotifierProvider(create: (context) => SongListProvider()),
    ], child: const MyApp()));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      home: isViewed != 0 ? const OneTimeSplashScreen() : const SplashScreen(),
      theme: themeProvider.gettheme(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/playlistsong': (context) => const PlaylistSongDisplayScreen(),
      },
    );
  }
}
