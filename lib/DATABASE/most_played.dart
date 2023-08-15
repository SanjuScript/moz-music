import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../CONTROLLER/song_controllers.dart';

class MostlyPlayedDB {
  static ValueNotifier<List<SongModel>> mostlyPlayedSongNotifier =
      ValueNotifier([]);
  static bool isInitialized = false;
  static const int maxSongCount = 100;
  static List<dynamic> mostlyPlayed = [];

  static initialize(List<SongModel> songs) {
    for (SongModel song in songs) {
      if (isMostlyPlayed(song)) {
        mostlyPlayedSongNotifier.value.add(song);
      }
    }
    isInitialized = true;
  }

  static isMostlyPlayed(SongModel song) async {
    final mostlyPlayedDb = await Hive.openBox('mostlyPlayed');
    if (mostlyPlayedDb.values.contains(song.id)) {
      return true;
    }
    return false;
  }

  static Future<void> incrementPlayCount(SongModel song) async {
  final mostlyPlayedDb = await Hive.openBox('mostlyPlayed');
  int currentPlayCount = mostlyPlayedDb.get(song.id) ?? 0;

  if (currentPlayCount >= 500) {
    mostlyPlayedDb.put(song.id, 0); // Reset play count to 0
  } else {
    mostlyPlayedDb.put(song.id, currentPlayCount + 1);
  }

  getMostlyPlayedSongs();
  mostlyPlayedSongNotifier.notifyListeners();
}


 static int getPlayCount(int songId) {
  final mostlyPlayedDb = Hive.box('mostlyPlayed');
  return mostlyPlayedDb.get(songId) ?? 0;
}

  static Future<void> getMostlyPlayedSongs() async {
    final mostlyPlayedDb = await Hive.openBox('mostlyPlayed');
    mostlyPlayed = mostlyPlayedDb.values.toList();
    displayMostlyPlayed();
    mostlyPlayedSongNotifier.notifyListeners();
  }

  static deleteAll() async {
    MostlyPlayedDB.mostlyPlayedSongNotifier.value.clear();
    final mostlyPlayedDb = await Hive.openBox('mostlyPlayed');
    mostlyPlayedDb.clear();
    mostlyPlayedSongNotifier.notifyListeners();
  }

static Future<void> displayMostlyPlayed() async {
  final mostlyPlayedDb = await Hive.openBox('mostlyPlayed');
  final mostlyPlayedSongItems = mostlyPlayedDb.toMap();

  final List<int> sortedSongIds = mostlyPlayedSongItems.keys
      .cast<int>()
      .toList()
    ..sort((a, b) =>
        mostlyPlayedSongItems[b].compareTo(mostlyPlayedSongItems[a]));

  final List<SongModel> sortedSongs = sortedSongIds.map((songId) {
    return GetSongs.songscopy.firstWhere(
      (element) => element.id == songId,
      orElse: () => SongModel({
        "_id": songId
      }), // Create a SongModel instance with the proper parameter
    );
  }).toList();

  mostlyPlayedSongNotifier.value.clear();
  mostlyPlayedSongNotifier.value.addAll(sortedSongs); // Use addAll to update the list

  mostlyPlayed.clear();
  mostlyPlayed.addAll(sortedSongs); // Update the mostlyPlayed list too
}

}
