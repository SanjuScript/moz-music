// ignore_for_file: deprecated_member_use, invalid_use_of_protected_member
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/DATABASE/playlistDb.dart';
import 'package:music_player/SCREENS/playlist/playList_song_listpage.dart';
import 'package:music_player/WIDGETS/audio_artwork_definer.dart';
import 'package:music_player/WIDGETS/audio_for_others.dart';
import 'package:music_player/WIDGETS/dialogues/UTILS/dialogue_utils.dart';
import 'package:music_player/WIDGETS/dialogues/import_playlist_dialogue.dart';
import 'package:music_player/WIDGETS/dialogues/playlist_creation_dialogue.dart';
import 'package:music_player/WIDGETS/dialogues/playlist_delete_dialogue.dart';
import 'package:music_player/WIDGETS/playlist_box.dart';
import '../../Model/music_model.dart';
import '../../Widgets/appbar.dart';
import '../../Widgets/song_list_maker.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

final nameController = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _PlaylistScreenState extends State<PlaylistScreen>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  void deletePlaylistsOntap() {
    PlayListDB.deleteAllPlaylist();
    Navigator.pop(context);
    // ignore: invalid_use_of_visible_for_testing_member
    PlayListDB.playlistnotifier.notifyListeners();
  }

  @override
  void initState() {
    PlayListDB.getAllPlaylist();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // FocusManager.instance.primaryFocus?.unfocus();
    return ValueListenableBuilder(
      valueListenable: Hive.box<MusicModel>('playlistDB').listenable(),
      builder:
          ((BuildContext context, Box<MusicModel> musicList, Widget? child) {
        return Scaffold(
          extendBody: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: TopAppBar(
              showImportButton: true,
              nxt: true,
              isPop: musicList.isEmpty ? false : true,
              onSelected: (p0) {
                if (p0 == 'ClearAll') {
                  DialogueUtils.getDialogue(
                    context,
                    'pdelete',
                    arguments: [
                      "Delete All Playlists",
                      deletePlaylistsOntap,
                      null,
                      null
                    ],
                  );
                } else if (p0 == 'import') {
                  DialogueUtils.getDialogue(context, 'pimport');
                }
              },
              firstString: "Playlists",
              secondString: musicList.length.toString(),
              topString: "Playlist",
              widget: Hive.box<MusicModel>('playlistDB').isEmpty
                  ? Center(
                      heightFactor: 30,
                      child: Text(
                        'NO PLAYLIST AVAILABLE',
                        style: TextStyle(
                          letterSpacing: 2,
                          fontFamily: "appollo",
                          color: Theme.of(context).cardColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : GridView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.001),
                      itemBuilder: ((BuildContext context, int index) {
                        final data = musicList.values.toList()[index];
                        return InkWell(
                            overlayColor: MaterialStatePropertyAll(
                                Theme.of(context).shadowColor.withOpacity(.2)),
                            onLongPress: () {
                              DialogueUtils.getDialogue(
                                context,
                                'pdelete',
                                arguments: [
                                  "Delete Playlist ${data.name.toUpperCase()}",
                                  () {
                                    musicList.deleteAt(index);
                                    Navigator.pop(context);
                                  },
                                  true,
                                  () {
                                    editPlaylist(context, index, data);
                                  },
                                ],
                              );
                            },
                            onTap: () {
                              if (data.songId.isEmpty) {
                                Navigator.pushNamed(
                                    context, '/playlistSongList',
                                    arguments: {'playlistt': data});
                              } else {
                                Navigator.pushNamed(context, '/playlistsong',
                                    arguments: {
                                      'playlist': data,
                                      'folderindex': index
                                    });
                              }
                            },
                            child: data.songId.isEmpty
                                ? PlaylistCreationBox(
                                    datas: data.songId,
                                    name: data.name,
                                    artwork: Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .indicatorColor,
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: Icon(
                                          Icons.playlist_add_rounded,
                                          size: 40,
                                          color: Theme.of(context)
                                              .secondaryHeaderColor,
                                        )),
                                    songCount:
                                        "${data.songId.length.toString()} songs",
                                    isArtworkAvailable: true,
                                    text: data.name,
                                  )
                                : PlaylistCreationBox(
                                    artwork: AudioArtworkDefinerForOthers(
                                        size: 500,
                                        imgRadius: 6,
                                        id: data.songId.last),
                                    songCount:
                                        "${data.songId.length.toString()} songs",
                                    isArtworkAvailable: true,
                                    text: data.name,
                                    datas: data.songId,
                                    name: data.name,
                                  ));
                      }),
                      itemCount: musicList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: .8, crossAxisCount: 2),
                    ),
              icon: Icons.playlist_add_rounded,
              iconTap: () {
                DialogueUtils.getDialogue(
                  context,
                  'pcreate',
                  arguments: [
                    _formKey,
                    nameController,
                    'Enter playlist name',
                    () {
                      if (_formKey.currentState!.validate()) {
                        whenButtonClicked();
                      }
                    },
                    'Create New Playlist',
                    "Please enter playlist name",
                  ],
                );
              },
            ),
          ),
        );
      }),
    );
  }

  void editPlaylist(BuildContext context, int index, MusicModel data) {
    final TextEditingController newTextEditor = TextEditingController();
    return DialogueUtils.getDialogue(context, 'pcreate', arguments: [
      _formKey,
      newTextEditor,
      'Enter new name',
      () async {
        if (_formKey.currentState!.validate()) {
          final newName = newTextEditor.text.trim();
          final music = MusicModel(
            songId: [],
            name: newName,
          );
          final data =
              PlayListDB.playListDb.values.map((e) => e.name.trim()).toList();
          if (newName.isEmpty) {
            return;
          } else if (data.contains(music.name)) {
            SnackBar snackBar = SnackBar(
              behavior: SnackBarBehavior.floating,
              width: 200.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              content: const Text(
                'Name Unavilable',
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            await PlayListDB.renamePlaylist(index, newName);

            newTextEditor.clear();
            Navigator.pop(context);
            Navigator.pop(context);
          }
        }
      },
      'Rename Playlist ${data.name}',
      "Please enter new playlist name",
    ]);
  }

  Future<void> whenButtonClicked() async {
    final name = nameController.text.trim();
    final music = MusicModel(
      songId: [],
      name: name,
    );
    final data =
        PlayListDB.playListDb.values.map((e) => e.name.trim()).toList();

    if (name.isEmpty) {
      return;
    } else if (data.contains(music.name)) {
      SnackBar snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        width: 200.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        content: const Text(
          'Name Unavilable',
          style: TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      PlayListDB.playlistAdd(music);
      nameController.clear();
      Navigator.pop(context);
    }
  }
}
