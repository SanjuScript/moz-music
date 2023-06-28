import 'package:flutter/material.dart';
import 'package:music_player/PROVIDER/sleep_timer_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SleepTimerForMoz extends StatefulWidget {
  const SleepTimerForMoz({Key? key}) : super(key: key);

  @override
  _SleepTimerForMozState createState() => _SleepTimerForMozState();
}

class _SleepTimerForMozState extends State<SleepTimerForMoz> {
  double selectedDuration = 0;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    loadSelectedDuration();
  }

  Future<void> loadSelectedDuration() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedDuration = _prefs.getDouble('selectedDuration') ?? 0;
    });
  }

  Future<void> saveSelectedDuration(double duration) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setDouble('selectedDuration', duration);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SleepTimeProvider>(
      builder: (context, sleepTimer, _) {
        void startTimer() {
          if (selectedDuration == 0) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                duration: const Duration(milliseconds: 800),
                backgroundColor: Colors.deepPurple[400],
                dismissDirection: DismissDirection.horizontal,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                content: const Text("No Timer Selected")));
          }

          sleepTimer.startTimer(selectedDuration.toInt());
        }

        void stopTimer() {
          selectedDuration = 0;
          sleepTimer.stopTimer();
        }

        double remainingDuration = sleepTimer.remainingTime.toDouble() / 60;
        double sliderValue = sleepTimer.isStart && sleepTimer.remainingTime > 0
            ? remainingDuration
            : selectedDuration;

        if (sleepTimer.isStart && sleepTimer.remainingTime == 0) {
          // Timer has ended, set the slider value to 0
          sliderValue = 0;
        }

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.30,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                sleepTimer.isStart ? "Timer running" : "Timer stoped",
                maxLines: 1,
                style: TextStyle(
                  fontFamily: 'coolvetica',
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                  color: const Color.fromARGB(255, 132, 132, 132),
                ),
              ),
              Text(
                sleepTimer.isStart && sleepTimer.remainingTime > 0
                    ? "Stop audio in ${remainingDuration.toStringAsFixed(0)} minutes"
                    : selectedDuration != 0
                        ? "Stop audio in ${selectedDuration.toStringAsFixed(0)} minutes"
                        : "Sleep timer off",
                style: TextStyle(
                  fontFamily: 'coolvetica',
                  color: selectedDuration != 0
                      ? Theme.of(context).cardColor
                      : Colors.grey,
                  fontSize: MediaQuery.of(context).size.height * 0.030,
                ),
              ),
              Slider(
                inactiveColor: Theme.of(context).cardColor,
                value: sliderValue,
                min: 0,
                max: 90,
                onChanged: (value) {
                  setState(() {
                    sliderValue = value;
                    selectedDuration = value;
                    saveSelectedDuration(value);
                  });
                },
                onChangeEnd: (value) {
                  setState(() {
                    selectedDuration = value;
                    saveSelectedDuration(value);
                  });
                },
                label: selectedDuration.toStringAsFixed(0),
              ),
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.deepPurple.withOpacity(.8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: sleepTimer.isStart ? stopTimer : startTimer,
                child: Text(
                  sleepTimer.isStart
                      ? "stop".toUpperCase()
                      : "start".toUpperCase(),
                  maxLines: 1,
                  style: TextStyle(
                    letterSpacing: 1,
                    fontSize: MediaQuery.of(context).size.width * 0.038,
                    fontFamily: 'coolvetica',
                    fontWeight: FontWeight.w400,
                    color: const Color.fromARGB(255, 228, 229, 229),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
