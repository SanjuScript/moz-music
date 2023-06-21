// import 'dart:developer';

// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/DATABASE/playlistDb.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../Model/music_model.dart';
import '../../WIDGETS/nuemorphic_button.dart';
import '../../Widgets/song_list_maker.dart';

class PlaylistSongListScreen extends StatefulWidget {
  const PlaylistSongListScreen({Key? key, required this.playlist})
      : super(key: key);

  final MusicModel playlist;

  @override
  State<PlaylistSongListScreen> createState() => _PlaylistSongState();
}

class _PlaylistSongState extends State<PlaylistSongListScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    fetchingAllSongsAndAssigningToFoundSongs();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  late List<SongModel> allSongs;
  List<SongModel> foundSongs = [];
  final OnAudioQuery audioQueryObject = OnAudioQuery();
  final AudioPlayer searchPageAudioPlayer = AudioPlayer();

  void fetchingAllSongsAndAssigningToFoundSongs() async {
    allSongs = await audioQueryObject.querySongs(
      sortType: SongSortType.DATE_ADDED,
      orderType: OrderType.DESC_OR_GREATER,
      uriType: UriType.EXTERNAL,
      ignoreCase: null,
    );
    foundSongs = allSongs;
  }

  void runFilter(String enteredKeyword) {
    List<SongModel> results = [];
    if (enteredKeyword.isEmpty) {
      results = allSongs;
    }
    if (enteredKeyword.isNotEmpty) {
      results = allSongs.where((element) {
        return element.displayNameWOExt
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase().trimRight());
      }).toList();
    }

    setState(() {
      foundSongs = results;
    });
  }

  void updateList(String value) {
    setState(() {});
  }

  final OnAudioQuery audioQuery = OnAudioQuery();
  bool searchBar = false;

  Widget? getListView() {
    if (foundSongs.isNotEmpty) {
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
        itemBuilder: (context, index) {
          final song = foundSongs[index];
          if (isSongSupported(song)) {
            return songDisplayScreen(
              song.id,
              song.title,
              song.artist.toString(),
              song.fileExtension,
              song,
            );
          }
          return const SizedBox();
        },
        itemCount: foundSongs.length,
      );
    } else {
      return null;
    }
  }

  bool isSongSupported(SongModel song) {
    final displayName = song.displayName.toLowerCase();
    return !displayName.contains(".opus") &&
        !displayName.contains("aud") &&
        !displayName.contains("recordings") &&
        !displayName.contains("recording") &&
        !displayName.contains("MIDI") &&
        !displayName.contains("pxl") &&
        !displayName.contains("Record") &&
        !displayName.contains("VID") &&
        !displayName.contains("whatsapp");
  }

  Widget songDisplayScreen(
    int id,
    String title,
    String artist,
    String fileExt,
    SongModel data,
  ) {
    return SongListViewer(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
      color: Theme.of(context).scaffoldBackgroundColor,
     
     shadowVisibility: false,
      borderradius: const BorderRadius.all(Radius.circular(20)),
      child: ListTile(
        contentPadding:
            EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.025),
        tileColor: Theme.of(context).scaffoldBackgroundColor,
        leading: Transform.scale(
          scale: MediaQuery.of(context).size.width * 0.0031,
          child: Padding(
            padding: const EdgeInsets.only(left: 7),
            child: CircleAvatar(
              child: Transform.scale(
                scale: MediaQuery.of(context).size.width * 0.0040,
                child: Nuemorphic(
               
                  padding: const EdgeInsets.all(2),
                  borderRadius: BorderRadius.circular(100),
                  child: QueryArtworkWidget(
                    keepOldArtwork: true,
                    id: id,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: Transform.scale(
                      scale: MediaQuery.of(context).size.width * 0.0027,
                      child: ClipOval(
                        child: Transform.scale(
                            scale: MediaQuery.of(context).size.width * 0.0030,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  // Color.fromARGB(255, 92, 107, 118),
                                  //   Color.fromARGB(255, 92, 107, 118),
                                  // Color.fromARGB(255, 98, 173, 193),
                                  // Color.fromARGB(255, 170, 187, 185),
                                  Theme.of(context).primaryColorDark,
                                  Theme.of(context).primaryColorLight,
                                ]),
                              ),
                              child: Center(
                                  child: Icon(
                                FontAwesomeIcons.music,
                                size: 15,
                                color: Theme.of(context).scaffoldBackgroundColor,
                              )),
                            )),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.06),
          child: Text(
            title.toUpperCase(),
            maxLines: 1,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).cardColor,
              letterSpacing: .7,
              // fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        subtitle: Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.06),
          child: Text(
            artist == '<unknown>'
                ? 'Unknown Artist' "." + fileExt
                : "$artist.$fileExt",
            maxLines: 1,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.038,
                fontFamily: 'optica',
                fontWeight: FontWeight.w400,
                color: Theme.of(context).cardColor),
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(MediaQuery.of(context).size.width * 0.1)),
        trailing: !widget.playlist.isValueIn(id)
            ? IconButton(
                splashColor: Colors.transparent,
                onPressed: (() {
                  setState(
                    () {
                      playlistCheck(data);
                      // ignore: invalid_use_of_visible_for_testing_member
                      PlayListDB.playlistnotifier.notifyListeners();
                    },
                  );
                }),
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).canvasColor,
                  size: 30,
                ),
              )
            : IconButton(
                splashColor: Colors.transparent,
                onPressed: (() {
                  setState(() {
                    widget.playlist.deleteData(id);
                  });
                }),
                icon: const Icon(
                  Icons.done,
                  color: Colors.green,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 80,
        actions: [
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: EdgeInsets.fromLTRB(
                0,
                MediaQuery.of(context).size.width * 0.027,
                MediaQuery.of(context).size.width * 0.02,
                0),
            width: MediaQuery.of(context).size.width * 0.88,
            child: TextField(
              autofocus: true,
              style: const TextStyle(fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.1),
                filled: true,
                fillColor: Colors.deepPurple[400],
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.07),
                    borderSide: BorderSide.none),
                hintText: 'Search & Add to Playlist',
                hintStyle: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).cardColor,
                ),
              ),
              onChanged: ((value) {
                runFilter(value);
              }),
            ),
          ),
        ],
        elevation: 2,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: getListView(),
    );
  }

  void playlistCheck(SongModel data) {
    if (!widget.playlist.isValueIn(data.id)) {
      widget.playlist.add(data.id);

      // log('song added');
    }
    // else {
    //   widget.playlist.delete();
    // }
  }
}
