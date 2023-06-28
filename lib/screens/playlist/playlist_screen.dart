// ignore_for_file: deprecated_member_use, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/DATABASE/playlistDb.dart';
import 'package:music_player/WIDGETS/dialogues/playlist_delete_dialogue.dart';
import 'package:music_player/screens/playlist/playlistSong_display_screen.dart';
import '../../HELPER/toast.dart';
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
    // ignore: invalid_use_of_visible_for_testing_member
    PlayListDB.playlistnotifier.notifyListeners();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    FocusManager.instance.primaryFocus?.unfocus();
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
                  : ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.001),
                      itemBuilder: ((BuildContext context, int index) {
                        final data = musicList.values.toList()[index];
                        return SongListViewer(
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 2, top: 10),
                          borderradius:
                              const BorderRadius.all(Radius.circular(25)),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: ListTile(
                            leading: Transform.scale(
                              scale: MediaQuery.of(context).size.width * 0.0035,
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.20,
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context).shadowColor,
                                          blurRadius: 1,
                                          offset: const Offset(2, 2),
                                        ),
                                        BoxShadow(
                                          color: Theme.of(context).dividerColor,
                                          blurRadius: 1,
                                          offset: const Offset(-2, -2),
                                        ),
                                      ],
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    Icons.playlist_play_rounded,
                                    color: Theme.of(context).cardColor,
                                  )),
                            ),
                            title: Padding(
                              padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.089,
                              ),
                              child: Text(
                                data.name.toUpperCase(),
                                style: TextStyle(
                                    fontFamily: 'coolvetica',
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.025,
                                    letterSpacing: 1.5,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).cardColor),
                              ),
                            ),
                            onLongPress: () {
                              showPlaylistDeleteDialogue(
                                  context: context,
                                  text1:
                                      "Delete Playlist ${data.name.toUpperCase()}",
                                  onPress: () {
                                    musicList.deleteAt(index);
                                    Navigator.pop(context);
                                    customToast(
                                        'Deleted ${data.name}', context);
                                  });
                            },
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: ((BuildContext context) {
                              //       return PlaylistSongDisplayScreen(
                              //         playlist: data,
                              //         folderindex: index,
                              //       );
                              //     }),
                              //   ),
                              // );
                              Navigator.pushNamed(context, '/playlistsong',arguments: {
                                'playlist': data,
                                'folderindex': index
                              });
                            },
                          ),
                        );
                      }),
                      itemCount: musicList.length),
              icon: Icons.playlist_add_rounded,
              iconTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      elevation: 5,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        height: MediaQuery.of(context).size.height * 0.22,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Create New Playlist',
                              style: TextStyle(
                                color: Theme.of(context).cardColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Form(
                              key: _formKey,
                              child: TextFormField(
                                autofocus: true,
                                style: TextStyle(
                                  color: Theme.of(context).cardColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                controller: nameController,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Theme.of(context).cardColor,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Theme.of(context).cardColor,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  hintText: 'Enter playlist name',
                                  hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .cardColor
                                        .withOpacity(0.6),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter playlist name";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: Theme.of(context).cardColor,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      whenButtonClicked();
                                    }
                                  },
                                  icon: Icon(
                                    Icons.done,
                                    color: Theme.of(context).cardColor,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      }),
    );
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
