// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
// import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoriteDb {
  static bool isInitialized = false;
  static final musicDb = Hive.box<int>('FavoriteDB');
  static ValueNotifier<List<SongModel>> favoriteSongs = ValueNotifier([]);
  static int get favoriteSongsLength => favoriteSongs.value.length;
  static intialize(List<SongModel> songs) {
    for (SongModel song in songs) {
      if (isFavor(song)) {
        favoriteSongs.value.add(song);
      }
    }
    isInitialized = true;
  }

  static isFavor(SongModel song) {
    if (musicDb.values.contains(song.id)) {
      return true;
    }
    return false;
  }

  static add(SongModel song) async {
    musicDb.add(song.id);
    favoriteSongs.value.add(song);
    // ignore: invalid_use_of_visible_for_testing_member
    FavoriteDb.favoriteSongs.notifyListeners();
  }

  static delete(int id) async {
    int deletekey = 0;
    if (!musicDb.values.contains(id)) {
      return;
    }
    final Map<dynamic, int> favorMap = musicDb.toMap();
    favorMap.forEach((key, value) {
      if (value == id) {
        deletekey = key;
      }
    });
    musicDb.delete(deletekey);
    favoriteSongs.value.removeWhere((song) => song.id == id);
  }

  static deleteAll() {
    musicDb.clear();
    favoriteSongs.value.clear();
  }

  static clear() async {
    FavoriteDb.favoriteSongs.value.clear();
  }
}
