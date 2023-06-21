import 'dart:async';
import 'package:flutter/material.dart';
import 'package:music_player/CONTROLLER/song_controllers.dart';

class SleepTimeProvider extends ChangeNotifier {
  Timer? _timer;
  int _remainingTime = 0;
  bool _isStart = false;
  bool get isStart => _isStart;
  int get remainingTime => _remainingTime;

  void startTimer(int minute) {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    _isStart = true;
    _remainingTime = minute * 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        notifyListeners();
      } else {
        stopTimer();
       if(minute != 0){
         GetSongs.player.stop();
       }
      }
    });
    notifyListeners();
  }

  void stopTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    _isStart = false;
    _remainingTime = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
