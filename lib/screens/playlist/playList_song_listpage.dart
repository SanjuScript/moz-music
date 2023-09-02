// import 'dart:developer';

// ignore_for_file: invalid_use_of_protected_member
import 'package:flutter/material.dart';
import 'package:music_player/DATABASE/playlistDb.dart';
import 'package:music_player/Model/music_model.dart';
import 'package:music_player/PROVIDER/homepage_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../Widgets/song_list_maker.dart';

class PlayListSongListScreen extends StatefulWidget {
  const PlayListSongListScreen({Key? key}) : super(key: key);

  @override
  State<PlayListSongListScreen> createState() => _PlayListSongListScreenState();
}

class _PlayListSongListScreenState extends State<PlayListSongListScreen>
    with AutomaticKeepAliveClientMixin {
  bool shouldAutofocus = true;
  late HomePageSongProvider searchProvider;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    searchProvider = Provider.of<HomePageSongProvider>(context, listen: false);
    searchProvider.fetchAllSongs();
  }

  Widget? getListView() {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final MusicModel playlist = arguments['playlistt'] as MusicModel;

    void playlistCheck(SongModel data) {
      if (!playlist.isValueIn(data.id)) {
        playlist.add(data.id);
      } else {
        playlist.deleteData(data.id);
      }
    }

    final foundSongs = searchProvider.foundSongs;
    if (foundSongs.isNotEmpty) {
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
        itemBuilder: (context, index) {
          return songDisplay(context,
              disableOnTap: true,
              isTrailingChange: true,
              song: foundSongs[index],
              songs: foundSongs,
              index: index,
              trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      playlistCheck(foundSongs[index]);
                      PlayListDB.playlistnotifier.notifyListeners();
                    });
                  },
                  icon: playlist.isValueIn(foundSongs[index].id)
                      ? const Icon(Icons.done)
                      : const Icon(Icons.add)));
        },
        itemCount: foundSongs.length,
      );
    } else {
      return const Center(child: Text.rich(TextSpan(text: "NO SEARCH FOUND")));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: MediaQuery.of(context).size.height * 0.08,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        title: SizedBox(
          width: MediaQuery.of(context).size.width * 0.88,
          child: TextField(
            autofocus: shouldAutofocus,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).cardColor),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1),
              filled: true,
              fillColor:
                  Theme.of(context).colorScheme.inversePrimary.withOpacity(.3),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none),
              hintText: 'Artists, songs, or albums',
              hintStyle: TextStyle(
                fontFamily: 'rounder',
                fontWeight: FontWeight.normal,
                color: Theme.of(context).cardColor,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).cardColor,
              ),
            ),
            onChanged: (value) {
              setState(() {
                shouldAutofocus = false;
              });
              searchProvider.filterSongs(value);
            },
          ),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Consumer<HomePageSongProvider>(
        builder: (context, provider, _) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 700),
            child: getListView() ?? const SizedBox(),
          );
        },
      ),
    );
  }
}
