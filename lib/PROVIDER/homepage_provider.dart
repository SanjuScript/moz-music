import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../HELPER/sort_enum.dart';

class HomePageSongProvider extends ChangeNotifier {
  List<SongModel> homePageSongs = [];
  List<SongModel> foundSongs = [];
  late List<SongModel> allSongs;
  List<SongModel> recentSongs = [];
  bool _permissionGranted = false;
  Future<List<SongModel>>? _songsFuture;
  SortOption _defaultSort = SortOption.adate;
  Set<int> _removedSongs = {};
  int _currentSongCount = 0;

  int get currentSongCount => _currentSongCount;

  Set<int> get removedSongs => _removedSongs;

  bool get permissionGranted => _permissionGranted;
  Future<List<SongModel>>? get songsFuture => _songsFuture;
  SortOption get defaultSort => _defaultSort;
  List<SongModel> get songs => homePageSongs;
  List<SongModel> get recentsong => recentSongs;

  final OnAudioQuery _audioQuery = OnAudioQuery();

  void removeSong(SongModel song) {
    homePageSongs.remove(song);
    _removedSongs.add(song.id);
    saveRemovedSongs(); // Save the updated removed songs
    notifyListeners();
  }

  void removeSongs(List<SongModel> songs) {
    homePageSongs.removeWhere((song) => songs.contains(song));
    _removedSongs.addAll(songs.map((song) => song.id));
    saveRemovedSongs(); // Save the updated removed songs
    notifyListeners();
  }

  void filterSongs(String enteredKeyword) {
    List<SongModel> results = [];
    if (enteredKeyword.isEmpty) {
      results = allSongs;
    } else {
      results = allSongs.where((element) {
        return element.displayNameWOExt
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase().trimRight());
      }).toList();
    }

    foundSongs = results;
    notifyListeners();
  }

  set currentSongCount(int count) {
    _currentSongCount = count;
    notifyListeners();
  }

  set defaultSort(SortOption sortOption) {
    _defaultSort = sortOption;
    notifyListeners(); // Notify listeners of the state change
  }

  void toggleValue(SortOption? value) {
    if (value != null) {
      _defaultSort = value;
      saveSortOption(value);
      notifyListeners(); // Notify listeners of the state change
    }
  }

  void resetRemovedSongs() async {
    _removedSongs.clear();
    await saveRemovedSongs(); // Save the cleared removed songs
    _songsFuture = querySongs(); // Update homePageSongs with filtered songs
    notifyListeners();
  }

  void fetchAllSongs() async {
    allSongs = await OnAudioQuery().querySongs(
      sortType: SongSortType.DATE_ADDED,
      orderType: OrderType.DESC_OR_GREATER,
      uriType: UriType.EXTERNAL,
      ignoreCase: null,
    );

    // Filter out unwanted songs
    foundSongs = allSongs.where((song) {
      final displayName = song.displayName.toLowerCase();
      return !_removedSongs.contains(song.id) && // Exclude removed songs
          !displayName.contains(".opus") &&
          !displayName.contains("aud") &&
          !displayName.contains("recordings") &&
          !displayName.contains("recording") &&
          !displayName.contains("MIDI") &&
          !displayName.contains("pxl") &&
          !displayName.contains("Record") &&
          !displayName.contains("VID") &&
          !displayName.contains("whatsapp");
    }).toList();
    notifyListeners();
  }

  Future<void> saveRemovedSongs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'removed_songs',
      _removedSongs.map((id) => id.toString()).toList(),
    );
  }

  Future<void> loadRemovedSongs() async {
    final prefs = await SharedPreferences.getInstance();
    final removedSongIds = prefs.getStringList('removed_songs') ?? [];
    _removedSongs = removedSongIds.map(int.parse).toSet();
  }

  List<SongModel> getLastAddedSongs(int count) {
    final effectiveCount = count.clamp(0, homePageSongs.length);
    final sonrted = sortSongs(homePageSongs, SortOption.adate);
    return sonrted.take(effectiveCount).toList();
  }  

  Future<List<SongModel>> querySongs() async {
    final sortType = getSortType(defaultSort);

    final songs = await _audioQuery.querySongs(
      sortType: sortType,
      orderType: OrderType.DESC_OR_GREATER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    // Filter out unwanted songs
    final filteredSongs = songs.where((song) {
      final displayName = song.displayName.toLowerCase();
      final songDur = (song.duration! / 1000) >= 10;

      return !_removedSongs.contains(song.id) && // Exclude removed songs
          !displayName.contains(".opus") &&
          !displayName.contains("aud") &&
          !displayName.contains("ptt".toUpperCase()) &&
          !displayName.contains("recordings") &&
          !displayName.contains("recording") &&
          !displayName.contains("MIDI") &&
          !displayName.contains("pxl") &&
          !displayName.contains("Record") &&
          !displayName.contains("VID") &&
          !displayName.contains("whatsapp") &&
          songDur;
    }).toList();

    homePageSongs = filteredSongs;
    currentSongCount = filteredSongs.length;

    notifyListeners();
    return homePageSongs;
  }

  Future<void> handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    _songsFuture = querySongs();
    notifyListeners();
  }

  Future<void> checkPermissionsAndQuerySongs(
      SortOption defaultSort, BuildContext context,
      {bool isallowed = false}) async {
    _permissionGranted = await _audioQuery.checkAndRequest(
      retryRequest: isallowed,
    );
    if (_permissionGranted) {
      _songsFuture = querySongs();
      notifyListeners();
    }
  }

  HomePageSongProvider() {
    // Call loadRemovedSongs asynchronously using a microtask
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadRemovedSongs();
      if (_permissionGranted) {
        _songsFuture =
            querySongs(); 
        notifyListeners();
      } else {
        // log("message LLLLLL");
      }
    });
  }
}
