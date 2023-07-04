import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../HELPER/sort_enum.dart';

class HomePageSongProvider extends ChangeNotifier {
  List<SongModel> homePageSongs = [];

  bool _permissionGranted = false;
  Future<List<SongModel>>? _songsFuture;
  SortOption _defaultSort = SortOption.adate;
  Set<int> _removedSongs = {};

  Set<int> get removedSongs => _removedSongs;

  bool get permissionGranted => _permissionGranted;
  Future<List<SongModel>>? get songsFuture => _songsFuture;
  SortOption get defaultSort => _defaultSort;
  List<SongModel> get songs => homePageSongs;

  final OnAudioQuery _audioQuery = OnAudioQuery();
  void removeSong(SongModel song) {
    homePageSongs.remove(song);
    _removedSongs.add(song.id);
    saveRemovedSongs(); // Save the updated removed songs
    notifyListeners(); // Notify listeners of the state change
  }

  void removeSongs(List<SongModel> songs) {
    homePageSongs.removeWhere((song) => songs.contains(song));
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

void resetRemovedSongs() {
  _removedSongs.clear();
  _songsFuture = querySongs(_defaultSort);
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

  Future<List<SongModel>> querySongs(SortOption sortOption) async {
    final sortType = getSortType(sortOption);
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      throw Exception('Permission Not Granted');
    }
    final songs = await _audioQuery.querySongs(
      sortType: sortType,
      orderType: OrderType.DESC_OR_GREATER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    // Filter out unwanted songs
    final filteredSongs = songs.where((song) {
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

    homePageSongs = filteredSongs;
    notifyListeners();
    return homePageSongs;
  }

  Future<void> handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    _songsFuture = querySongs(_defaultSort);
    notifyListeners(); // Notify listeners of the state change
  }

  Future<void> checkPermissionsAndQuerySongs(SortOption defaultSort) async {
    final permStatus = await Permission.storage.request();
    if (permStatus.isDenied) {
      await Permission.storage.request();
    }

    // Update the permissionGranted flag and call querySongs
    _permissionGranted = true;
    _songsFuture = querySongs(defaultSort);
    notifyListeners(); // Notify listeners of the state change
  }

  HomePageSongProvider() {
    // Call loadRemovedSongs asynchronously using a microtask
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadRemovedSongs();
    });
  }
}
