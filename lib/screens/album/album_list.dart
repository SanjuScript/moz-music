import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/ANIMATION/slide_animation.dart';
import 'package:music_player/PROVIDER/album_provider.dart';
import 'package:music_player/WIDGETS/indicators.dart';
import 'package:music_player/WIDGETS/nuemorphic_button.dart';
import 'package:music_player/Widgets/audio_artwork_definer.dart';
import 'package:music_player/screens/album/album_music_list_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class AlbumList extends StatefulWidget {
  const AlbumList({Key? key}) : super(key: key);

  @override
  State<AlbumList> createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList>
    with AutomaticKeepAliveClientMixin<AlbumList> {
  @override
  bool get wantKeepAlive => true;
  late AlbumProvider _albumProvider;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _albumProvider = Provider.of<AlbumProvider>(context, listen: false);
    _albumProvider.fetchAlbums();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
            const SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 15,
            ),
            InkWell(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
            
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.height * 0.07,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      color: Colors.red[400],
                      borderRadius: BorderRadius.circular(15)),
                  child: Icon(
                    Icons.album,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    size: 35,
                  )),
            ),
            Text(
              'Albums',
              style: TextStyle(
                letterSpacing: 1,
                fontFamily: "appollo",
                fontSize: 23,
                color: Theme.of(context).cardColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
          
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 15,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 15, right: 5),
                child: Icon(
                 Icons.play_circle_rounded,
                      
                  color: Colors.red[400],
                )),
            Text(
              'Albums',
              style: TextStyle(
                letterSpacing: 1,
                fontFamily: "appollo",
                fontSize: 15,
                color: Theme.of(context).cardColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Text(
                '${_albumProvider.albums.length}',
                style: const TextStyle(
                  letterSpacing: 1,
                  fontFamily: "appollo",
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
          Consumer<AlbumProvider>(
            builder: (context, albumProvider, _) {
              if (albumProvider.albums.isEmpty) {
                return songEmpty(context, "NO Albums Found", () {
                  albumProvider.fetchAlbums();
                });
              } else {
                return AnimationLimiter(
                  child: Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemCount: albumProvider.albums.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          delay: const Duration(milliseconds: 100),
                          child: SlideAnimation(
                            duration: const Duration(milliseconds: 2000),
                            curve: Curves.fastLinearToSlowEaseIn,
                            verticalOffset: -250.0,
                            child: ScaleAnimation(
                              duration: const Duration(milliseconds: 1000),
                              curve: Curves.fastLinearToSlowEaseIn,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.10,
                                  child: ListTile(
                                    horizontalTitleGap: 30,
                                    trailing: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Theme.of(context).cardColor,
                                    ),
                                    subtitle: Text(
                                      albumProvider.albums[index].artist
                                          .toString(),
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.038,
                                        fontFamily: 'optica',
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context).cardColor,
                                      ),
                                    ),
                                    leading: Transform.scale(
                                      scale: MediaQuery.of(context).size.width *
                                          0.0045,
                                      child: CircleAvatar(
                                        child: Nuemorphic(
                                          shadowVisibility: false,
                                          child: AudioArtworkDefiner(
                                            isRectangle: true,
                                            imgRadius: 10,
                                            id: albumProvider.albums[index].id,
                                            type: ArtworkType.ALBUM,
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      AlbumModel albumdata =
                                          albumProvider.albums[index];

                                      Navigator.push(
                                          context,
                                          SearchAnimationNavigation(
                                              AlbumMusicListing(
                                                  albumModel: albumdata)));
                                    },
                                    title: Text(
                                      albumProvider.albums[index].album,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).cardColor,
                                        letterSpacing: .7,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
