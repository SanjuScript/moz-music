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
          !displayName.contains("whatsapp");
    }).toList();

    homePageSongs = filteredSongs;
  
  // Update the current song count
  currentSongCount = homePageSongs.length;

  notifyListeners();
  return homePageSongs;
  }

  Future<void> handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    _songsFuture = querySongs();
    notifyListeners();
  }

  // Future<void> checkPermissionsAndQuerySongs(
  //     SortOption defaultSort, BuildContext context) async {
  //   final status = await Permission.storage.request();

  //   if (status.isGranted) {
  //     _permissionGranted = true;
  //     _songsFuture = querySongs();
  //     notifyListeners();
  //   } else if (status.isDenied) {
  //     // ignore: use_build_context_synchronously
  //     return showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: const Text('Permission Denied'),
  //           content: const Text(
  //             'This app needs storage permission to perform certain functions. Please grant the permission in app settings.',
  //           ),
  //           actions: <Widget>[
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context); // Close the dialog
  //               },
  //               child: const Text('OK'),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context); // Close the dialog
  //                 openAppSettings(); // Open app settings page
  //               },
  //               child: const Text('Open Settings'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   } else {
  //     openAppSettings();
  //   }
  // }
  Future<void> checkPermissionsAndQuerySongs(
      SortOption defaultSort, BuildContext context,
      {bool isallowed = false}) async {
    _permissionGranted = await _audioQuery.checkAndRequest(
      retryRequest: isallowed,
    );
    if (_permissionGranted) {
      _songsFuture = querySongs();
      print('\x1B[31mPermission Granted\x1B[0m');
      notifyListeners();
    }
  }

  void _handlePermissionStatus(PermissionStatus status) {
    if (status.isGranted) {
      // Permission is granted, load audio files
      _permissionGranted = true;
      log(_permissionGranted.toString());
      _songsFuture = querySongs();
      notifyListeners();
    } else if (status.isDenied) {
      // Permission is denied
      log('Permission is denied');
    } else if (status.isPermanentlyDenied) {
      // Permission is permanently denied, navigate to app settings
      log('Permission is permanently denied');
      openAppSettings();
    }
  }

  HomePageSongProvider() {
    // Call loadRemovedSongs asynchronously using a microtask
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadRemovedSongs();
      _songsFuture =
          querySongs(); // Call querySongs after loading removed songs
      notifyListeners();
    });
  }
}
