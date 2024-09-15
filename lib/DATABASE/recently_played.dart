import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

class RecentDb {
  static bool isInitialized = false;
  static final musicDb = Hive.box<int>('RecentDB');
  static ValueNotifier<List<SongModel>> recentSongs = ValueNotifier([]);
  static int get recentSongsLength => recentSongs.value.length;

   static initialize(List<SongModel> songs) {
    for (SongModel song in songs) {
      if (isRecent(song)) {
        recentSongs.value.add(song);
      }
    }
    isInitialized = true;
  }
  static bool isRecent(SongModel song) {
    return musicDb.containsKey(song.id);
  }

  static Future<void> add(SongModel song) async {
    musicDb.put(song.id, DateTime.now().millisecondsSinceEpoch);
    recentSongs.value.insert(0, song); // Insert at the beginning of the list
    if (recentSongs.value.length > 100) {
      recentSongs.value.removeLast(); // Remove the last item if list exceeds 100
    }
    recentSongs.notifyListeners();
  }

  static delete(int id) async {
    int deleteKey = 0;
    if (!musicDb.values.contains(id)) {
      return;
    }
    final Map<dynamic, int> recentMap = musicDb.toMap();
    recentMap.forEach((key, value) {
      if (value == id) {
        deleteKey = key;
      }
    });
    musicDb.delete(deleteKey);
    recentSongs.value.removeWhere((song) => song.id == id);
  }

  static deleteAll() {
    musicDb.clear();
    recentSongs.value.clear();
  }

  static clear() async {
    RecentDb.recentSongs.value.clear();
  }
}
