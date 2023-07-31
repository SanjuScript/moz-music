// ignore_for_file: deprecated_member_use, invalid_use_of_protected_member
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/DATABASE/playlistDb.dart';
import 'package:music_player/WIDGETS/audio_artwork_definer.dart';
import 'package:music_player/WIDGETS/dialogues/playlist_creation_dialogue.dart';
import 'package:music_player/WIDGETS/dialogues/playlist_delete_dialogue.dart';
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

  Widget _showText(String text, {FontWeight fontWeight = FontWeight.w400}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        text,
        style: TextStyle(
            fontFamily: 'coolvetica',
            fontSize: MediaQuery.of(context).size.height * 0.020,
            letterSpacing: 1.5,
            overflow: TextOverflow.ellipsis,
            fontWeight: fontWeight,
            color: Theme.of(context).cardColor),
      ),
    );
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
              nxt: true,
              isPop: musicList.isEmpty ? false : true,
              onSelected: (p0) {
                if (p0 == 'ClearAll') {
                  showPlaylistDeleteDialogue(
                      context: context,
                      text1: "Delete All Playlists",
                      onPress: deletePlaylistsOntap);
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
                            showPlaylistDeleteDialogue(
                                context: context,
                                isPlaylistPage: true,
                                rename: () {
                                  editPlaylist(context, index, data);
                                },
                                text1:
                                    "Delete Playlist ${data.name.toUpperCase()}",
                                onPress: () {
                                  musicList.deleteAt(index);
                                  Navigator.pop(context);
                                });
                          },
                          onTap: () {
                            Navigator.pushNamed(context, '/playlistsong',
                                arguments: {
                                  'playlist': data,
                                  'folderindex': index
                                });
                          },
                          child: data.songId.isEmpty
                              ? SongListViewer(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10, top: 10),
                                  borderradius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.playlist_add_circle_rounded,
                                        color: Theme.of(context).cardColor,
                                        size: 26,
                                      ),
                                      _showText(data.name),
                                      _showText("Add song")
                                    ],
                                  ),
                                )
                              : SongListViewer(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10, top: 10),
                                  borderradius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: SizedBox(
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.18,
                                          //  width: MediaQuery.sizeOf(context).width * 0.23,
                                          child: AudioArtworkDefiner(
                                              size: 500,
                                              imgRadius: 6,
                                              id: data.songId.last),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          "${data.songId.length.toString()} songs",
                                          style: TextStyle(
                                              fontFamily: 'coolvetica',
                                              letterSpacing: 1,
                                              fontSize: 11,
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Theme.of(context).cardColor),
                                        ),
                                      ),
                                      _showText(data.name,
                                          fontWeight: FontWeight.w500)
                                    ],
                                  ),
                                ),
                        );
                      }),
                      itemCount: musicList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: .8, crossAxisCount: 2),
                    ),
              icon: Icons.playlist_add_rounded,
              iconTap: () {
                showPlaylistCreationDialogue(
                    mainText: 'Create New Playlist',
                    context: context,
                    formKey: _formKey,
                    nameController: nameController,
                    hint: 'Enter playlist name',
                    donePress: () {
                      if (_formKey.currentState!.validate()) {
                        whenButtonClicked();
                      }
                    },
                    validator: "Please enter playlist name");
              },
            ),
          ),
        );
      }),
    );
  }

  void editPlaylist(BuildContext context, int index, MusicModel data) {
    final TextEditingController newTextEditor = TextEditingController();
    return showPlaylistCreationDialogue(
        context: context,
        mainText: 'Rename Playlist ${data.name}',
        formKey: _formKey,
        hint: 'Enter new name',
        donePress: () async {
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
        validator: "Please enter playlist name",
        nameController: newTextEditor);
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
