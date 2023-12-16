import 'package:flutter/material.dart';
import 'package:music_player/PROVIDER/artist_song_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../WIDGETS/audio_artwork_definer.dart';
import '../../WIDGETS/song_list_maker.dart';

class ArtistMusicListing extends StatefulWidget {
  const ArtistMusicListing({Key? key, required this.artistModel})
      : super(key: key);
  final ArtistModel artistModel;

  @override
  State<ArtistMusicListing> createState() => _AlbumMusicListingState();
}

class _AlbumMusicListingState extends State<ArtistMusicListing> {
  @override
  void initState() {
    super.initState();
    Provider.of<ArtistSongListProvider>(context, listen: false)
        .fetchSongs(widget.artistModel.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ArtistSongListProvider>(
        builder: (context, artistSongListProvider, _) {
          final songs = artistSongListProvider.songs;

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
                            child: AudioArtworkDefiner(
                              id: widget.artistModel.id,
                              imgRadius: 10,
                              type: ArtworkType.ARTIST,
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
                                  widget.artistModel.artist,
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
                                    widget.artistModel.artist == "<unknown>"
                                        ? "${songs.length} Songs"
                                        : "${widget.artistModel.artist} ${songs.length} songs",
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
