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
  Navigator.push(
    context,
    PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) {
        return AnimatedBuilder(
          animation: ModalRoute.of(context)!.animation!,
          builder: (BuildContext context, Widget? child) {
            final double animationValue = ModalRoute.of(context)!.animation!.value;
            return Transform.scale(
              scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: ModalRoute.of(context)!.animation!,
                  curve: Curves.elasticOut,
                ),
              ).value,
              child: Opacity(
                opacity: animationValue,
                child: Theme(
                  data: CustomThemes.darkThemeMode.copyWith(
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
                ),
              ),
            );
          },
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (BuildContext context, Animation<double> animation, _, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ),
  );
}
