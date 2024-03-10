import 'package:flutter/material.dart';
import 'package:music_player/WIDGETS/audio_artwork_definer.dart';
import 'package:music_player/WIDGETS/audio_for_others.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../PROVIDER/album_song_list_provider.dart';
import '../../WIDGETS/song_list_maker.dart';

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
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 15),
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
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.09,
                            width: MediaQuery.of(context).size.height * 0.09,
                            child: AudioArtworkDefinerForOthers(
                              id: widget.albumModel.id,
                              imgRadius: 10,
                              type: ArtworkType.ALBUM,
                              isRectangle: true,
                            ),
                          ),
                          const SizedBox(width: 15),
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
                        return songDisplay(context,
                            song: songs[index], songs: songs, index: index);
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
