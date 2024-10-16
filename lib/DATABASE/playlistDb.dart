import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_player/DATABASE/favorite_db.dart';
import 'package:music_player/DATABASE/most_played.dart';
import 'package:music_player/DATABASE/recently_played.dart';
import 'package:music_player/SCREENS/const_splashScreen.dart';
import 'package:music_player/screens/mainUI/most_played_songs.dart';
import '../Model/music_model.dart';

class PlayListDB {
  static ValueNotifier<List<MusicModel>> playlistnotifier = ValueNotifier([]);
  static final playListDb = Hive.box<MusicModel>('playlistDb');

//  ValueNotifier<List<MusicModel>> viewPlaylistnotifier = ValueNotifier([]);
  static int get playlistLength => playlistnotifier.value.length;
  static Future<void> playlistAdd(MusicModel value) async {
    final playListDb = Hive.box<MusicModel>('playlistDB');
    await playListDb.add(value);
    playlistnotifier.value.add(value);
  }

  static Future<void> getAllPlaylist() async {
    final playListDb = Hive.box<MusicModel>('playlistDB');
    playlistnotifier.value.clear();
    playlistnotifier.value.addAll(playListDb.values);

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    playlistnotifier.notifyListeners();
  }

  static Future<void> playlistDelete(int index) async {
    final playListDb = Hive.box<MusicModel>('playlistDB');

    await playListDb.deleteAt(index);
    getAllPlaylist();
  }

  static Future<void> deleteAllPlaylist() async {
    final playListDb = Hive.box<MusicModel>('playlistDB');
    await playListDb.clear();
    getAllPlaylist();
  }

  static Future<void> renamePlaylist(int index, String newName) async {
    final playListDb = Hive.box<MusicModel>('playlistDB');
    final MusicModel playlist = playListDb.getAt(index)!;
    // ignore: unnecessary_null_comparison
    if (playlist != null) {
      final updatedPlaylist =
          MusicModel(name: newName, songId: playlist.songId);
      await playListDb.putAt(index, updatedPlaylist);
      getAllPlaylist();
    }
  }

  static Future<void> resetAPP(context) async {
    final playListDb = Hive.box<MusicModel>('playlistDB');
    final musicDb = Hive.box<int>('FavoriteDB');
    // final mostlyDB = Hive.box('MostPlayedDB');
    // final recentDB = Hive.box('RecentDB');

    await PlayCountService.clearPlayCountData();
    await RecentDb.clear();
    await musicDb.clear();
    await playListDb.clear();

    FavoriteDb.favoriteSongs.value.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SplashScreen()),
        (route) => false);
  }
}
