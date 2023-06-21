import 'dart:io';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../COLORS/colors.dart';

void deleteSong(SongModel songModel) {
  String filePath = songModel.data;
  File file = File(filePath);

  if (file.existsSync()) {
    try {
      file.deleteSync();
      print('File deleted successfully.');
    } catch (e) {
      print('Error deleting file: $e');
    }
  } else {
    print('File does not exist at the specified path: $filePath');
  }
}

void showSongDeleteDialogue(BuildContext context, SongModel song) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Theme(
        data: darkThemeMode.copyWith(
          dialogTheme: Theme.of(context).dialogTheme,
        ),
        child: AlertDialog(
          title: const Text('Delete Song'),
          content: const Text('Are you sure you want to delete this song?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteSong(song);
                Navigator.pop(context);
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
