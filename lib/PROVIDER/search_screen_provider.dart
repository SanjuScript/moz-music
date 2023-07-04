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
    foundSongs = allSongs;
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
