
import 'package:flutter/material.dart';

import '../../CONTROLLER/song_controllers.dart';
void showSpeedDialogue(BuildContext context) {
  double selectedSpeed = GetSongs.player.playing ? GetSongs.player.speed : 1.0;

  showDialog(
    context: context,
    builder: ((context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          "Speed Controls",
          style: TextStyle(
            fontFamily: 'coolvetica',
            color: Theme.of(context).cardColor,
            fontSize: MediaQuery.of(context).size.height *0.030,
          ),
        ),
        titlePadding: const EdgeInsets.all( 10),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: speedSelector(context, "0.5x", 0.5, selectedSpeed == 0.5),
            ),
             Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: speedSelector(context, "0.8x", 0.8, selectedSpeed == 0.8),
            ),
             Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: speedSelector(context, "1.0x", 1.0, selectedSpeed == 1.0),
            ),
             Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: speedSelector(context, "1.5x", 1.5, selectedSpeed == 1.5),
            ),
             Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: speedSelector(context, "2.0x", 2.0, selectedSpeed == 2.0),
            ),
            
          
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Close",
              style: TextStyle(
                fontFamily: 'coolvetica',
                fontSize: 16,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      );
    }),
  );
} 

Widget speedSelector(
    BuildContext context, String speedLabel, double speedValue, bool isSelected) {
  Color buttonColor = isSelected ? Colors.green : const Color(0xff97A4B7);

  return SizedBox(
    height: 50,
    width: double.infinity,
    child: TextButton(
      onPressed: () {
        if (GetSongs.player.playing) {
          GetSongs.player.setSpeed(speedValue);
          Navigator.pop(context);
        }
      },
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xff97A4B7)),
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: buttonColor,
      ),
      child: Text(
        speedLabel,
        style: TextStyle(
          fontFamily: 'coolvetica',
          fontSize: 14,
          color: isSelected ? Colors.white : const Color.fromARGB(255, 227, 231, 236),
        ),
      ),
    ),
  );
}
