// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:music_player/DATABASE/most_played.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../CONTROLLER/song_controllers.dart';

class RecentlyPlayedDB {
  static ValueNotifier<List<SongModel>> recentlyplayedSongNotifier =
      ValueNotifier([]);
  static bool isInitialized = false;
  static const int maxSongCount = 100; // Remove this line

  static intialize(List<SongModel> songs) async {
    for (SongModel song in songs) {
      if (await isDoes(song)) {
        recentlyplayedSongNotifier.value.add(song);
      }
    }
    isInitialized = true;
  }

  static Future<bool> isDoes(SongModel song) async {
    try {
      final recentDb = await Hive.openBox('recentlyPlayed');
      return recentDb.values.contains(song.id);
    } catch (e) {
      // Handle the exception, e.g., log it or return a default value
      log("Is Does Error : $e");
      return false;
    }
  }

  static Future<void> addRecentlyPlayed(SongModel song) async {
    try {
      final recentDb = await Hive.openBox('recentlyPlayed');
      await recentDb.add(song.id);
      // await MostlyPlayedDB.incrementPlayCount(song);
      await getRecentlyPlayedSongs();
      recentlyplayedSongNotifier.notifyListeners();
    } catch (e) {
      log("Add Recently Played Error : $e");
    }
  }

  static Future<void> getRecentlyPlayedSongs() async {
    try {
      final recentDb = await Hive.openBox('recentlyPlayed');
      final recentSongItems = recentDb.values.toList();

      // Ensure that the recently played list is capped at maxSongCount
      if (recentSongItems.length > maxSongCount) {
        final int startIndex = recentSongItems.length - maxSongCount;
        recentSongItems.removeRange(0, startIndex);
      }

      await displayRecentlyPlayed(recentSongItems);
      recentlyplayedSongNotifier.notifyListeners();
    } catch (e) {
      log("Error loading recently played songs on start: $e");
    }
  }

  static Future<void> displayRecentlyPlayed(
      List<dynamic> recentSongItems) async {
    try {
      final recentDb = await Hive.openBox('recentlyPlayed');
      final List<SongModel> displayedRecentlyPlayed = [];

      for (int i = 0; i < recentSongItems.length; i++) {
        final songId = recentSongItems[i];
        final song = GetSongs.songscopy.firstWhere(
          (element) => element.id == songId,
          orElse: () => SongModel({"_id": songId}),
        );

        displayedRecentlyPlayed.add(song);
      }

      recentlyplayedSongNotifier.value = displayedRecentlyPlayed;
    } catch (e) {
      log("Display Recently Played Error : $e");
    }
  }

  static deleteAll() async {
    RecentlyPlayedDB.recentlyplayedSongNotifier.value.clear();
    final recentDb = await Hive.openBox('recentlyPlayed');
    recentDb.clear();
    recentlyplayedSongNotifier.notifyListeners();
  }
}
