import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AlbumProvider extends ChangeNotifier {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<AlbumModel> albums = [];
 AlbumProvider() {
    fetchAlbums();
  }
  Future<void> fetchAlbums() async {
    final fetchedAlbums = await _audioQuery.queryAlbums(
      sortType: AlbumSortType.NUM_OF_SONGS,
      orderType: OrderType.DESC_OR_GREATER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    // Filter out unwanted albums
    final filteredAlbums = fetchedAlbums.where((album) {
      final displayName = album.album.toLowerCase();
      return !displayName.contains(".opus") &&
          !displayName.contains("aud") &&
          !displayName.contains("recordings") &&
          !displayName.contains("recording") &&
          !displayName.contains("MIDI") &&
          !displayName.contains("pxl") &&
          !displayName.contains("20") &&
          !displayName.contains("Record") &&
          !displayName.contains("VID") &&
          !displayName.contains("whatsapp");
    }).toList();

    albums = filteredAlbums;
    notifyListeners();
  }
  int get totalAlbums => albums.length;
}
