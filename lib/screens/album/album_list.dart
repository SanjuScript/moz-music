import 'package:flutter/material.dart';
import 'package:music_player/ANIMATION/slide_animation.dart';
import 'package:music_player/HELPER/artist_helper.dart';
import 'package:music_player/PROVIDER/album_provider.dart';
import 'package:music_player/WIDGETS/indicators.dart';
import 'package:music_player/Widgets/audio_artwork_definer.dart';
import 'package:music_player/SCREENS/album/album_music_list_screen.dart';
import 'package:music_player/Widgets/song_list_maker.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlbumList extends StatefulWidget {
  const AlbumList({Key? key}) : super(key: key);

  @override
  State<AlbumList> createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList>
    with AutomaticKeepAliveClientMixin<AlbumList> {
  Future<void> _setCrossAxisCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('albumCount', count);
  }

  Future<int> _getCrossAxisCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('albumCount') ?? 2; // Default to 2 columns
  }

  List<int> crossAxisOptions = [1, 2, 3, 4];
  void changeCrossAxisCount() {
    setState(() {
      selectedCrossAxisOption =
          (selectedCrossAxisOption + 1) % crossAxisOptions.length;
      _setCrossAxisCount(crossAxisOptions[selectedCrossAxisOption]);
    });
  }

  int selectedCrossAxisOption = 2;
  List<Widget> iconWidget = const [
    Icon(Icons.square_rounded),
    Icon(Icons.view_agenda_rounded),
    Icon(Icons.view_module_rounded),
    Icon(Icons.calendar_view_week_rounded),
    
  ];

  @override
  bool get wantKeepAlive => true;

  late AlbumProvider _albumProvider;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _albumProvider = Provider.of<AlbumProvider>(context, listen: false);
    _albumProvider.fetchAlbums();
    _getCrossAxisCount().then((value) {
      setState(() {
        selectedCrossAxisOption = crossAxisOptions.indexOf(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Album",
                    style: TextStyle(
                        shadows: const [
                          BoxShadow(
                            color: Color.fromARGB(90, 63, 63, 63),
                            blurRadius: 15,
                            offset: Offset(-2, 2),
                          ),
                        ],
                        fontSize: 25,
                        fontFamily: 'rounder',
                        letterSpacing: 1,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).cardColor),
                  ),
                ),
                Spacer(),
                IconButton(
                    onPressed: () => changeCrossAxisCount(),
                    icon: iconWidget[selectedCrossAxisOption])
              ],
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.82,
              width: double.infinity,
              child: Consumer<AlbumProvider>(
                builder: (context, albumProvider, _) {
                  if (albumProvider.albums.isEmpty) {
                    return songEmpty(context, "NO Albums Found", () {
                      albumProvider.fetchAlbums();
                    });
                  } else {
                    return AnimationLimiter(
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisOptions[
                                selectedCrossAxisOption] // Use the selected value
                            ,
                            childAspectRatio: .8),
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        itemCount: albumProvider.albums.length,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredGrid(
                            duration: Duration(milliseconds: 500),
                            position: index,
                            columnCount: selectedCrossAxisOption,
                            child: ScaleAnimation(
                              duration: const Duration(milliseconds: 900),
                              curve: Curves.fastLinearToSlowEaseIn,
                              child: FadeInAnimation(
                                child: InkWell(
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        SearchAnimationNavigation(
                                            AlbumMusicListing(
                                                albumModel: albumProvider
                                                    .albums[index])));
                                  },
                                  child: FittedBox(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.25,
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.55,
                                          child: AudioArtworkDefiner(
                                            id: albumProvider
                                                .albums[index].id,
                                            imgRadius: 15,
                                            size: 1000,
                                            type: ArtworkType.ALBUM,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.06,
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.45,
                                          child: Text(
                                            albumProvider.albums[index].album,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                shadows: const [
                                                  BoxShadow(
                                                    color: Color.fromARGB(
                                                        90, 89, 89, 89),
                                                    blurRadius: 15,
                                                    offset: Offset(-2, 2),
                                                  ),
                                                ],
                                                fontSize: 18,
                                                fontFamily: 'rounder',
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.w400,
                                                color: Theme.of(context)
                                                    .cardColor),
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.05,
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.45,
                                          child: Text(
                                            artistHelper(
                                                albumProvider
                                                    .albums[index].artist
                                                    .toString(),
                                                ''),
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                shadows: const [
                                                  BoxShadow(
                                                    color: Color.fromARGB(
                                                        90, 89, 89, 89),
                                                    blurRadius: 15,
                                                    offset: Offset(-2, 2),
                                                  ),
                                                ],
                                                fontSize: 13,
                                                fontFamily: 'rounder',
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.w400,
                                                color: Theme.of(context)
                                                    .cardColor),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
