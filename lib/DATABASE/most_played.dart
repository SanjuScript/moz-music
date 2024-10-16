import 'dart:developer';
import 'package:hive/hive.dart';
import 'package:music_player/MODEL/song_play_count.dart';

class PlayCountService {
  static final Box<SongPlayCount> _playCountBox =
      Hive.box<SongPlayCount>('play_counts');
  static void addOrUpdatePlayCount(String songId) {
    var songPlayCount = _playCountBox.get(songId);
    songPlayCount ??= SongPlayCount(songId: songId);
    songPlayCount.playCount += 1;
    _playCountBox.put(songId, songPlayCount);
    log("Added :$songId");
  }

  static int getPlayCount(String songId) {
    var songPlayCount = _playCountBox.get(songId);
    return songPlayCount?.playCount ?? 0;
  }

  static List<String> getMostPlayedSongIds() {
    List<SongPlayCount> playCounts = _playCountBox.values.toList();
    playCounts.sort((a, b) => b.playCount.compareTo(a.playCount));

    List<String> mostPlayedSongIds = [];
    for (var playCount in playCounts) {
      mostPlayedSongIds.add(playCount.songId);
    }
    log(mostPlayedSongIds.toString());
    return mostPlayedSongIds;
  }

  static bool get isMostPlayedSongIdsEmpty {
    return _playCountBox.isEmpty;
  }

  static int get currentlength {
    return _playCountBox.length;
  }

  static Future<void> clearPlayCountData()async {
    _playCountBox.clear();
    log("All play count data deleted.");
  }
}
