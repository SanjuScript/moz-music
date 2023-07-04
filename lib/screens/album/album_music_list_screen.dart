import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/HELPER/artist_helper.dart';
import 'package:music_player/SCREENS/main_music_playing_screen.dart.dart';
import 'package:music_player/WIDGETS/audio_artwork_definer.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../CONTROLLER/song_controllers.dart';
import '../../DATABASE/recently_played.dart';
import '../../PROVIDER/album_song_list_provider.dart';
import '../../WIDGETS/song_list_maker.dart';
import '../favoritepage/favorite_button.dart';

class AlbumMusicListing extends StatefulWidget {
  const AlbumMusicListing({Key? key, required this.albumModel})
      : super(key: key);
  final AlbumModel albumModel;

  @override
  State<AlbumMusicListing> createState() => _AlbumMusicListingState();
}

class _AlbumMusicListingState extends State<AlbumMusicListing> {
  @override
  void initState() {
    super.initState();
    Provider.of<SongListProvider>(context, listen: false)
        .fetchSongs(widget.albumModel.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SongListProvider>(
        builder: (context, songListProvider, _) {
          final songs = songListProvider.songs;

          if (songs.isEmpty) {
            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: Center(
                child: Text(
                  'NO SONGS FOUND',
                  style: TextStyle(
                    letterSpacing: 2,
                    color: Theme.of(context).cardColor,
                    fontFamily: "appollo",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 15),
                        IconButton(
                          splashColor: Colors.transparent,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_rounded,
                            size: 23,
                            color: Theme.of(context).cardColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.09,
                            width: MediaQuery.of(context).size.height * 0.09,
                            child: AudioArtworkDefiner(
                              id: widget.albumModel.id,
                              imgRadius: 10,
                              type: ArtworkType.ALBUM,
                              isRectangle: true,
                            ),
                          ),
                          SizedBox(width: 15),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.60,
                                child: Text(
                                  widget.albumModel.album,
                                  maxLines: 2,
                                  style: TextStyle(
                                    letterSpacing: 1,
                                    fontFamily: "appollo",
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 20,
                                    color: Theme.of(context).cardColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.60,
                                  child: Text(
                                    widget.albumModel.artist == "<unknown>"
                                        ? "${songs.length} Songs"
                                        : "${widget.albumModel.artist} ${songs.length} songs",
                                    style: const TextStyle(
                                      letterSpacing: 1,
                                      overflow: TextOverflow.ellipsis,
                                      fontFamily: "appollo",
                                      fontSize: 10,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.10,
                            child: SongListViewerForSections(
                              isWidget: false,
                              color: Colors.transparent,
                              fileSize: '',
                              id: songs[index].id,
                              onLongpress: () {},
                              subtitle: artistHelper(
                                  songs[index].artist.toString(),
                                  songs[index].fileExtension),
                              onTap: () {
                                List<SongModel> newlist = [...songs];
                                GetSongs.player.stop();
                                GetSongs.player.setAudioSource(
                                    GetSongs.createSongList(newlist),
                                    initialIndex: index);
                                GetSongs.player.play();
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return NowPlaying(
                                    songModelList: GetSongs.playingSongs,
                                  );
                                }));
                                RecentlyPlayedDB.addRecentlyPlayed(
                                    songs[index].id);
                                GetSongs.player.playerStateStream
                                    .listen((playerState) {
                                  if (playerState.processingState ==
                                      ProcessingState.completed) {
                                    if (GetSongs.player.currentIndex ==
                                        songs.length - 1) {
                                      GetSongs.player
                                          .seek(Duration.zero, index: 0);
                                    }
                                  }
                                });
                              },
                              trailingWidget:
                                  FavoriteButton(songFavorite: songs[index]),
                              trailingOnTap: () {},
                              icon: Icons.delete,
                              title: songs[index].title,
                              child: const SizedBox(),
                            ),
                          ),
                        );
                      },
                      physics: const BouncingScrollPhysics(),
                      itemCount: songs.length,
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
