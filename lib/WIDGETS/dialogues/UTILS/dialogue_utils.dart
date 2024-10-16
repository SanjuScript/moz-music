import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:music_player/WIDGETS/dialogues/import_playlist_dialogue.dart';
import 'package:music_player/WIDGETS/dialogues/playlist_creation_dialogue.dart';
import 'package:music_player/WIDGETS/dialogues/playlist_delete_dialogue.dart';
import 'package:music_player/WIDGETS/dialogues/reset_confirmation_dialogue.dart';
import 'package:music_player/WIDGETS/dialogues/song_delete_dialogue.dart';
import 'package:music_player/WIDGETS/dialogues/song_restore_dialogue.dart';
import 'package:music_player/WIDGETS/dialogues/speed_dialogue.dart';

import '../playlist_easy_access.dart';

class DialogueUtils {
  static void getDialogue(BuildContext context, String text,
      {dynamic arguments}) {
    switch (text.toLowerCase()) {
      case 'reset':
        showResetConfirmationDialogue(context);
        break;
      case 'pcreate':
        showPlaylistCreationDialogue(
          context: context,
          formKey: arguments[0],
          nameController: arguments[1],
          hint: arguments[2],
          donePress: arguments[3],
          mainText: arguments[4],
          validator: arguments[5],
        );
        break;
      case 'pdelete':
        if (arguments != null && arguments.length >= 4) {
          showPlaylistDeleteDialogue(
            context: context,
            text1: arguments[0],
            onPress: arguments[1],
            isPlaylistPage: arguments[2] ?? false,
            rename: arguments[3],
          );
        }
        break;
      case 'peasy':
        showPlaylistEasyAccessDialogue(context: context, getList: arguments);
        break;
      case 'speed':
        showSpeedDialogue(context: context, color: arguments);
        break;
      case 'sdelete':
        showSongDeletionDialogue(
            context: context, songTitle: arguments[0], onDelete: arguments[1]);
      case 'pimport':
        showPlaylistImportDialogue(context);
        break;
      case 'srestore':
        showSongREstoreConfirmationDialogue(context, arguments[0]);
        break;
      default:
        break;
    }
  }
}
