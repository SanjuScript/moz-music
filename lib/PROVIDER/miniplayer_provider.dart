import 'package:flutter/material.dart';
import 'package:music_player/CONTROLLER/song_controllers.dart';

class MiniplayerProvider extends ChangeNotifier {
  void checkMounted() async {
    GetSongs.player.currentIndexStream.listen((index) {
      if (index != null) {
        notifyListeners();
      }
    });
  }

  Future<void> playPauseButton(BuildContext context) async {
    if (GetSongs.player.playing) {
      await GetSongs.player.pause();
    } else {
      await GetSongs.player.play();
      notifyListeners();
    }
  }

  Future<void> previousButton(BuildContext context) async {
    if (GetSongs.player.hasPrevious) {
      await GetSongs.player.seekToPrevious();
      await GetSongs.player.play();
    } else {
      await GetSongs.player.play();
    }
  }

  Future<void> nextButton(BuildContext context) async {
    if (GetSongs.player.hasNext) {
      await GetSongs.player.seekToNext();
      await GetSongs.player.play();
    } else {
      await GetSongs.player.play();
    }
  }  
}