import 'package:flutter/material.dart';
import 'package:music_player/DATABASE/playlistDb.dart';
import 'package:music_player/WIDGETS/dialogues/UTILS/custom_dialogue.dart';


void showResetConfirmationDialogue(BuildContext context) {
  CustomBlurDialog.show(
    context: context,
    title: 'Reset App',
    content:
        'Are you sure you want to reset the app? This will delete all data.',
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text(
          'Cancel',
          style: TextStyle(color: Colors.deepPurple, fontSize: 18),
        ),
      ),
      TextButton(
        onPressed: () {
          PlayListDB.resetAPP(context);
          Navigator.of(context).pop();
        },
        child: const Text(
          'Reset',
          style: TextStyle(color: Colors.red, fontSize: 18),
        ),
      ),
    ],
  );
}
