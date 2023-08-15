import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:music_player/PROVIDER/artist_provider.dart';
import 'package:music_player/SCREENS/artists/artist_song_listing.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ANIMATION/slide_animation.dart';
import '../../HELPER/artist_helper.dart';
import '../../WIDGETS/audio_artwork_definer.dart';
import '../../WIDGETS/indicators.dart';

class ArtistList extends StatefulWidget {
  const ArtistList({Key? key}) : super(key: key);

  @override
  State<ArtistList> createState() => _ArtistListState();
}

class _ArtistListState extends State<ArtistList>
    with AutomaticKeepAliveClientMixin<ArtistList> {

  @override
  bool get wantKeepAlive => true;

    Future<void> _setCrossAxisCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('crossAxisCount', count);
  }

  Future<int> _getCrossAxisCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('crossAxisCount') ?? 2; // Default to 2 columns
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
  late ArtistProvider _artistprovider;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _artistprovider = Provider.of<ArtistProvider>(context, listen: false);
    _artistprovider.fetchArtists();
    //  print('\x1B[31mThis text will be printed in red.\x1B[0m');
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
                    "Artist",
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
                const Spacer(),
                IconButton(
                    onPressed: () => changeCrossAxisCount(),
                    icon: iconWidget[selectedCrossAxisOption])
              ],
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.82,
              width: double.infinity,
              child: Consumer<ArtistProvider>(
                builder: (context, albumProvider, _) {
                  if (albumProvider.artists.isEmpty) {
                    return songEmpty(context, "NO Albums Found", () {
                      albumProvider.fetchArtists();
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
                        itemCount: albumProvider.artists.length,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredGrid(
                            duration: const Duration(milliseconds: 500),
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
                                            ArtistMusicListing(
                                                artistModel: albumProvider
                                                    .artists[index])));
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
                                                .artists[index].id,
                                            imgRadius: 15,
                                            size: 1000,
                                            type: ArtworkType.ARTIST,
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
                                            albumProvider.artists[index].artist,
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
                                                    .artists[index].artist
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
