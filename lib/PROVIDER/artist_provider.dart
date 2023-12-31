import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ArtistProvider extends ChangeNotifier {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<ArtistModel> artists = [];
  ArtistProvider() {
    fetchArtists();
  }
  Future<void> fetchArtists() async {
    final fetchedArtists = await _audioQuery.queryArtists(
      // sortType: ArtistSortType.NUM_OF_TRACKS,
      // orderType: OrderType.DESC_OR_GREATER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    // Filter out unwanted albums
    final filteredArtists = fetchedArtists.where((artist) {
      final displayName = artist.artist.toLowerCase();
      return !displayName.contains("unknown") &&
          !displayName.contains("whatsapp");
    }).toList();

    artists = filteredArtists;
    notifyListeners();
  }
  int get totalArtists => artists.length;
}
