import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/WIDGETS/audio_artwork_definer.dart';
import 'package:music_player/screens/main_musicPlaying_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../DATABASE/recently_played.dart';
import '../WIDGETS/nuemorphic_button.dart';
import '../Widgets/song_list_maker.dart';
import '../CONTROLLER/song_controllers.dart';
import 'favoritepage/favorite_button.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  bool shouldAutofocus = true;
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

  bool tap = false;
  @override
  bool get wantKeepAlive => true;

  void updateList(String value) {
    setState(() {});
  }

  Widget? getListView() {
    if (foundSongs.isNotEmpty) {
      return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
          itemBuilder: ((context, index) {
            return searchScreenSongDisplay(
                foundSongs[index].id,
                foundSongs[index].title,
                foundSongs[index].artist.toString(),
                foundSongs[index].fileExtension,
                index,
                index);
          }),
          itemCount: foundSongs.length);
    } else {
      return const SizedBox();
    }
  }

  Widget searchScreenSongDisplay(
    int id,
    String title,
    String artist,
    String fileExtension,
    int initialIndexa,
    int inittialIndex,
  ) {
    final displayName = title.toLowerCase();

    if (displayName.contains(".opus") ||
        displayName.contains("aud") ||
        displayName.contains("recordings") ||
        displayName.contains("recording") ||
        displayName.contains("midi") ||
        displayName.contains("pxl") ||
        displayName.contains("record") ||
        displayName.contains("vid") ||
        displayName.contains("whatsapp")) {
      return const SizedBox();
    }
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
                  child: AudioArtworkDefiner(
                    id: id,
                    
                  )
                ),
              ),
            ),
          ),
        ),
        trailing: FavoriteButton(songFavorite: foundSongs[inittialIndex]),
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
                ? 'Unknown Artist' "." + fileExtension
                : "$artist.$fileExtension",
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
        onTap: () {
          tap = true;
          GetSongs.player.play();
          GetSongs.player.setAudioSource(GetSongs.createSongList(foundSongs),
              initialIndex: initialIndexa);
          GetSongs.player.play();
          RecentlyPlayedDB.addRecentlyPlayed(foundSongs[inittialIndex].id);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NowPlaying(songModelList: foundSongs)));
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchingAllSongsAndAssigningToFoundSongs();
    // Add this line to populate the song list initially
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: MediaQuery.of(context).size.height * 0.08,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 1,
        title: SizedBox(
          width: MediaQuery.of(context).size.width * 0.88,
          child: TextField(
            autofocus: shouldAutofocus,
            style: const TextStyle(fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1),
              filled: true,
              fillColor: Theme.of(context).highlightColor,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.07),
                  borderSide: BorderSide.none),
              hintText: 'Artists,songs,or albums',
              hintStyle: TextStyle(
                color: Theme.of(context).cardColor,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).cardColor,
              ),
            ),
            onChanged: ((value) {
              setState(() {
                shouldAutofocus = false;
              });
              runFilter(value);
            }),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: getListView() ?? const SizedBox(),
    );
  }
}
