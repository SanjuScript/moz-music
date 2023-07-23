import 'package:flutter/widgets.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchScreenProvider extends ChangeNotifier {
  late List<SongModel> allSongs;
  List<SongModel> foundSongs = [];
  final OnAudioQuery audioQueryObject = OnAudioQuery();
void fetchAllSongs() async {
  allSongs = await audioQueryObject.querySongs(
    sortType: SongSortType.DATE_ADDED,
    orderType: OrderType.DESC_OR_GREATER,
    uriType: UriType.EXTERNAL,
    ignoreCase: null,
  );

  // Filter out unwanted songs
  foundSongs = allSongs.where((song) {
    final displayName = song.displayName.toLowerCase();
    return  // Exclude removed songs 
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
}
