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
    MozController.player.durationStream.listen((d) {
      if (d != null) {
        duration = d;
        notifyListeners();
      }
    });
    MozController.player.positionStream.listen((p) {
      position = p;
      notifyListeners();
    });
  }

  void initStateHere() {
    MozController.player.currentIndexStream.listen((index) {
      if (index != null) {
        currentIndex = index;
        MozController.currentIndex = index;
        notifyListeners();
      }
    });
  }

  Future<void> previousButtonHere() async {
    if (MozController.player.hasPrevious) {
      await MozController.player.seekToPrevious();
      await MozController.player.play();
    } else {
      await MozController.player.play();
    }
  }

  Future<void> playPauseButtonHere() async {
    if (MozController.player.playing) {
      await MozController.player.pause();
      notifyListeners();
    } else {
      await MozController.player.play();
      notifyListeners();
    }
  }

  Future<void> nextButtonHere() async {
    if (MozController.player.hasNext) {
      await MozController.player.seekToNext();
      await MozController.player.play();
    } else {
      await MozController.player.play();
    }
  }

  void changeToSeconds(double seconds) {
    Duration duration = Duration(seconds: seconds.toInt());
    MozController.player.seek(duration);
    notifyListeners();
  }
}
