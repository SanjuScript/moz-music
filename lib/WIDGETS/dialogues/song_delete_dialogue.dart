import 'package:flutter/material.dart';
import 'package:music_player/WIDGETS/dialogues/UTILS/custom_dialogue.dart';

 void showSongDeletionDialogue({
    required BuildContext context,
    required String songTitle,
    required void Function() onDelete,
  }) {
    CustomBlurDialog.show(
      context: context,
      title: 'Delete Song',
      content: 'Are you sure you want to delete "$songTitle"?',
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
            onDelete(); 
            Navigator.of(context).pop(); 
          },
          child: const Text(
            'Delete',
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
      ],
    );
  }