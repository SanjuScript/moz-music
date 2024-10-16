import 'package:flutter/material.dart';
import 'package:music_player/DATABASE/playlistDb.dart';
import 'package:music_player/WIDGETS/dialogues/UTILS/custom_dialogue.dart';

void showSongREstoreConfirmationDialogue(
    BuildContext context, void Function() onPressed) {
  CustomBlurDialog.show(
    context: context,
    title: 'Restore All Songs',
    content: 'Are you sure you want to restore all removed songs?',
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
        onPressed: onPressed,
        child: Text(
          'Restore All',
          style: TextStyle(color: Colors.red[400], fontSize: 18),
        ),
      ),
    ],
  );
}
