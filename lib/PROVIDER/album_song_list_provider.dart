import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart';


class SongListProvider with ChangeNotifier {
  List<SongModel> _songs = [];

  List<SongModel> get songs => _songs;

  Future<void> fetchSongs(int albumId) async {
    try {
      final songs = await OnAudioQuery().queryAudiosFrom(AudiosFromType.ALBUM_ID, albumId);
      _songs = songs;
      notifyListeners();
    } catch (error) {
      print('Error fetching songs: $error');
    }
  }
}