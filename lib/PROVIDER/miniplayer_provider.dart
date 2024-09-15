import 'package:flutter/material.dart';
import 'package:music_player/CONTROLLER/song_controllers.dart';

class MiniplayerProvider extends ChangeNotifier {
  void checkMounted() async {
    MozController.player.currentIndexStream.listen((index) {
      if (index != null) {
        notifyListeners();
      }
    });
  }

  Future<void> playPauseButton(BuildContext context) async {
    if (MozController.player.playing) {
      await MozController.player.pause();
    } else {
      await MozController.player.play();
      notifyListeners();
    }
  }

  Future<void> previousButton(BuildContext context) async {
    if (MozController.player.hasPrevious) {
      await MozController.player.seekToPrevious();
      await MozController.player.play();
    } else {
      await MozController.player.play();
    }
  }

  Future<void> nextButton(BuildContext context) async {
    if (MozController.player.hasNext) {
      await MozController.player.seekToNext();
      await MozController.player.play();
    } else {
      await MozController.player.play();
    }
  }  
}