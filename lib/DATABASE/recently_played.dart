import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:music_player/screens/home_page.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../CONTROLLER/song_controllers.dart';

class RecentlyPlayedDB {
  static ValueNotifier<List<SongModel>> recentlyplayedSongNotifier =
      ValueNotifier([]);
  static bool isInitialized = false;
  static const int maxSongCount = 50;
  static List<dynamic> recentlyPlayed = [];

  static intialize(List<SongModel> songs) {
    for (SongModel song in songs) {
      if (isDoes(song)) {
        recentlyplayedSongNotifier.value.add(song);
      }
    }
    isInitialized = true;
  }

  static isDoes(SongModel song) async {
    final recentDb = await Hive.openBox('recentlyPlayed');
    if (recentDb.values.contains(song.id)) {
      return true;
    }
    return false;
  }

  static Future<void> addRecentlyPlayed(item) async {
    final recentDb = await Hive.openBox('recentlyPlayed');
    await recentDb.add(item);

    getRecentlyPlayedSongs();
    recentlyplayedSongNotifier.notifyListeners();
  }

  static Future<void> getRecentlyPlayedSongs() async {
    final recentDb = await Hive.openBox('recentlyPlayed');
    recentlyPlayed = recentDb.values.toList();
    displayRecentlyPlayed();
    recentlyplayedSongNotifier.notifyListeners();
  }

  static deleteAll() async {
    RecentlyPlayedDB.recentlyplayedSongNotifier.value.clear();
    final recentDb = await Hive.openBox('recentlyPlayed');
    recentDb.clear();
    recentlyplayedSongNotifier.notifyListeners();
  }

  static Future<void> displayRecentlyPlayed() async {
    final recentDb = await Hive.openBox('recentlyPlayed');
    final recentSongItems = recentDb.values.toList();
    recentlyplayedSongNotifier.value.clear();
    recentlyPlayed.clear();

    final int startIndex = recentSongItems.length > maxSongCount
        ? recentSongItems.length - maxSongCount
        : 0;

    for (int i = startIndex; i < recentSongItems.length; i++) {
      final songId = recentSongItems[i];
      final song = GetSongs.songscopy.firstWhere(
        (element) => element.id == songId,
        orElse: () => SongModel(songId), // Return a default instance of SongModel
      );

      recentlyplayedSongNotifier.value.add(song);
      recentlyPlayed.add(song);
    }
  }
}
