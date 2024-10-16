import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:music_player/DATABASE/playlistDb.dart';
import 'package:music_player/Model/music_model.dart';
import 'package:music_player/WIDGETS/dialogues/UTILS/custom_dialogue.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class TextFileListDialog extends StatefulWidget {
  const TextFileListDialog({super.key});

  @override
  _TextFileListDialogState createState() => _TextFileListDialogState();
}

class _TextFileListDialogState extends State<TextFileListDialog> {
  List<FileSystemEntity> selectedFiles = [];
  List<FileSystemEntity> files = [];

  @override
  void initState() {
    super.initState();
    _getTextFiles();
  }

  Future<void> _getTextFiles() async {
    Directory exportDirectory =
        Directory('/storage/emulated/0/Documents/Moz music');
    if (await exportDirectory.exists()) {
      final fileList = exportDirectory.listSync().where((file) {
        return file is File && file.path.endsWith('.txt');
      }).toList();

      setState(() {
        files = fileList;
      });
    }
  }

  Future<List<int>> readSongIdsFromFile(FileSystemEntity file) async {
    final filePath = file.path;
    final fileContent = await File(filePath).readAsString();
    return fileContent
        .split('\n')
        .map((id) => int.tryParse(id))
        .whereType<int>()
        .toList();
  }

  Future<void> _createPlaylists(BuildContext context) async {
    for (var file in selectedFiles) {
      List<int> songIds = await readSongIdsFromFile(file);
      final playlistName = path.basenameWithoutExtension(file.path);
      final music = MusicModel(songId: songIds, name: playlistName);

      final data =
          PlayListDB.playListDb.values.map((e) => e.name.trim()).toList();

      if (!data.contains(music.name)) {
        PlayListDB.playlistAdd(music);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${music.name} already exists',
              style: const TextStyle(color: Colors.red)),
        ));
      }
    }

    selectedFiles.clear();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).splashColor.withOpacity(0.9),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(20),
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Text Files',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).cardColor,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),

                if(files.isEmpty)
                Expanded(
                  child: Center(
                    child: Text("No Playlist Available",style: TextStyle(color: Theme.of(context).cardColor),),
                  ),
                ),
                Expanded(
                  child: Scrollbar(
                    interactive: true,
                    child: SingleChildScrollView(
                      child: Column(
                        children: files.map((file) {
                          return CheckboxListTile(
                            contentPadding: EdgeInsets.all(10),
                            value: selectedFiles.contains(file),
                            secondary: Icon(Icons.music_note),
                            title: Text(
                              '${path.basenameWithoutExtension(file.path)}.moz',
                              style:
                                  TextStyle(color: Theme.of(context).cardColor),
                            ),
                            onChanged: (bool? selected) {
                              setState(() {
                                if (selected == true) {
                                  selectedFiles.add(file);
                                } else {
                                  selectedFiles.remove(file);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () async {
                    await _createPlaylists(context);
                  },
                  child: const Text(
                    'Import Playlists',
                    style: TextStyle(color: Colors.deepPurple, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.deepPurple, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showPlaylistImportDialogue(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (BuildContext context) {
      return TextFileListDialog();
    },
  );
}
