import 'dart:io';
import 'package:flutter/material.dart';
import 'package:music_player/HELPER/toast.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../COLORS/colors.dart';

// Future<void> deleteSong(SongModel songModel) async {
// String filePath = songModel.data;

// try {
//   MediaStore mediaStore = MediaStore();
//   MediaStore.appFolder = "/data/data/com.myapp/files";
//   MediaStore().
//   bool deleted = await mediaStore.deleteFile(
//     fileName: filePath,
//     dirType: DirType.audio,
//     dirName: DirName.music,
//     relativePath: '',
//   );

//   if (deleted) {
//     File file = File(filePath);
//     await file.delete();
//     print('File deleted successfully.');
//   } else {
//     print('Error deleting file.');
//   }
// } catch (e) {
//   print('Error deleting file: $e');
// }
// }

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
                // deleteSong(song);
                customToast("Error File path", context);
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
