import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class PlaylistExporter extends ChangeNotifier {
  Future<void> exportIDs(
      List<int> datas, String playlistname, BuildContext context) async {
    Directory exportDirectory =
        Directory('/storage/emulated/0/Documents/Moz music');
    if (!exportDirectory.existsSync()) {
      exportDirectory.createSync(recursive: true);
    }

    try {
      File file = File(path.join(exportDirectory.path, "$playlistname.txt"));
      if (datas.isNotEmpty) {
        
       ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text("File Saved successfully",  style: TextStyle(color: Colors.green[500]),)));
          await file.writeAsString(datas.join('\n'));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          "Playlist empty ! please add songs before exporting",
          style: TextStyle(color: Colors.red[300]),
        )));
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("error : $e")));
    }

    // if (!file.parent.existsSync()) {
    //   file.parent.createSync(recursive: true);
    // }
  }
}
