import 'package:flutter/material.dart';
import 'package:music_player/CONTROLLER/song_controllers.dart';
import 'package:music_player/DATABASE/favorite_db.dart';
import 'package:provider/provider.dart';

class NowPlayingProvider extends ChangeNotifier {
  Duration duration = const Duration();
  Duration position = const Duration();
  int currentIndex = 0;

  Future<bool> willPopHere() async {
    FavoriteDb.favoriteSongs.notifyListeners();
    return true;
  }

  void backButtonHere(BuildContext context) {
    Navigator.pop(context);
  }

  void playSong() {
    GetSongs.player.durationStream.listen((d) {
      if (d != null) {
        duration = d;
        notifyListeners();
      }
    });
    GetSongs.player.positionStream.listen((p) {
      position = p;
      notifyListeners();
    });
  }

  void initStateHere() {
    GetSongs.player.currentIndexStream.listen((index) {
      if (index != null) {
        currentIndex = index;
        GetSongs.currentIndex = index;
        notifyListeners();
      }
    });
  }

  Future<void> previousButtonHere() async {
    if (GetSongs.player.hasPrevious) {
      await GetSongs.player.seekToPrevious();
      await GetSongs.player.play();
    } else {
      await GetSongs.player.play();
    }
  }

  Future<void> playPauseButtonHere() async {
    if (GetSongs.player.playing) {
      await GetSongs.player.pause();
      notifyListeners();
    } else {
      await GetSongs.player.play();
      notifyListeners();
    }
  }

  Future<void> nextButtonHere() async {
    if (GetSongs.player.hasNext) {
      await GetSongs.player.seekToNext();
      await GetSongs.player.play();
    } else {
      await GetSongs.player.play();
    }
  }

  void changeToSeconds(double seconds) {
    Duration duration = Duration(seconds: seconds.toInt());
    GetSongs.player.seek(duration);
    notifyListeners();
  }
}
