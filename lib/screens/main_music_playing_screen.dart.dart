import 'dart:developer';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/CONTROLLER/song_controllers.dart';
import 'package:music_player/DATABASE/favorite_db.dart';
import 'package:music_player/HELPER/artist_helper.dart';
import 'package:music_player/PROVIDER/color_extraction.dart';
import 'package:music_player/PROVIDER/now_playing_provider.dart';
import 'package:music_player/PROVIDER/theme_class_provider.dart';
import 'package:music_player/WIDGETS/audio_artwork_definer.dart';
import 'package:music_player/WIDGETS/bouncing_widget.dart';
import 'package:music_player/WIDGETS/buttons/home_button.dart';
import 'package:music_player/WIDGETS/buttons/play_pause_button.dart';
import 'package:music_player/WIDGETS/buttons/repeat_button.dart';
import 'package:music_player/WIDGETS/buttons/shuffle_button.dart';
import 'package:music_player/WIDGETS/buttons/theme_button_widget.dart';
import 'package:music_player/WIDGETS/custom_slider.dart';
import 'package:music_player/WIDGETS/dialogues/UTILS/dialogue_utils.dart';
import 'package:music_player/WIDGETS/dialogues/playlist_easy_access.dart';
import 'package:music_player/screens/favoritepage/favorite_music_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../COLORS/colors.dart';
import '../WIDGETS/bottomsheet/song_info_sheet.dart';
import '../WIDGETS/buttons/next_prevoius_button.dart';
import '../WIDGETS/dialogues/speed_dialogue.dart';
import '../WIDGETS/nuemorphic_button.dart';

class NowPlaying extends StatefulWidget {
  final List<SongModel> songModelList;
  const NowPlaying({
    super.key,
    required this.songModelList,
  });

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _initStateLogic();
  }

  void _initStateLogic() {
    final nowPlayingProvider =
        Provider.of<NowPlayingProvider>(context, listen: false);
    nowPlayingProvider.initStateHere();
    nowPlayingProvider.playSong();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    log('Main music player rebuilds');
    super.build(context);
    final ht = MediaQuery.of(context).size.height;
    final wt = MediaQuery.of(context).size.width;
    final artworkColor =
        Provider.of<ArtworkColorProvider>(context).dominantColor;
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDark = themeProvider.getTheme() == CustomThemes.darkThemeMode;

    return PopScope(
      onPopInvoked: (didPop) {
        context.read<NowPlayingProvider>().willPopHere();
      },
      child: Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.primaryDelta != null && details.primaryDelta! < -10) {
              bottomDetailsSheet(
                context: context,
                song: widget.songModelList,
                index: MozController.currentIndex,
                isPlaylistShown: true,
                onTap: () {
                  DialogueUtils.getDialogue(context, 'peasy',
                      arguments: widget.songModelList);
                },
              );
            }
          },
          child: AnimatedContainer(
            duration: const Duration(seconds: 1),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                stops: const [
                  .2,
                  .8,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  isDark
                      ? artworkColor as Color
                      : Theme.of(context).hoverColor.withOpacity(.7),
                  // artworkColor!,
                  Theme.of(context).scaffoldBackgroundColor
                ],
              ),
            ),
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: ht * 0.05,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        const Icon(
                          Icons.abc,
                          color: Colors.transparent,
                        ),
                        Text(
                          "PLAYING NOW",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'hando',
                            fontSize: wt * 0.04,
                            letterSpacing: 3.6,
                            // color: const Color(0xff333c67),
                            color: Theme.of(context)
                                .unselectedWidgetColor
                                .withOpacity(.7),
                          ),
                        ),
                        const ChangeThemeButtonWidget(),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    padding: const EdgeInsets.all(3),
                    width: wt * 0.87,
                    height: ht * 0.38,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: !isDark
                          ? [
                              BoxShadow(
                                color: artworkColor!.withOpacity(.8),
                                blurRadius: 20,
                          
                                spreadRadius: 1,
                                offset:const Offset(0, 10),
                              ),
                            ]
                          : [],
                    ),
                    child: Consumer<NowPlayingProvider>(
                      builder: (context, value, child) {
                        return BouncableEffect(
                          onDoubletap: true,
                          songModel: widget.songModelList[value.currentIndex],
                          child: AudioArtworkDefiner(
                            id: widget.songModelList[value.currentIndex].id,
                            size: 500,
                            // enableAnimation: true,

                            imgRadius: 15,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: ht * 0.02,
                  ),
                  SizedBox(
                    height: ht * 0.04,
                    width: wt * 0.7,
                    child: Consumer<NowPlayingProvider>(
                      builder: (context, value, child) {
                        return Text(
                          widget.songModelList[value.currentIndex].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'rounder',
                              fontSize: ht * 0.03,
                              letterSpacing: .5,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w200,
                              color: Theme.of(context).hintColor),
                        );
                      },
                    ),
                  ),

                  SizedBox(
                    width: wt * 0.8,
                    height: ht * 0.02,
                    child: Consumer<NowPlayingProvider>(
                      builder: (context, value, child) {
                        return Text(
                          artistHelper(
                              widget.songModelList[value.currentIndex].artist
                                  .toString(),
                              ''),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: TextStyle(
                              fontFamily: 'rounder',
                              fontSize: ht * 0.0165,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context)
                                  .unselectedWidgetColor
                                  .withOpacity(.5)),
                        );
                      },
                    ),
                  ),

                  // Progress Bar Here
                  Padding(
                    padding: EdgeInsets.only(
                      top: ht * 0.03,
                      bottom: ht * 0.01,
                      left: wt * 0.01,
                      right: wt * 0.01,
                    ),
                    child: SizedBox(
                      width: wt * 0.9,
                      height: ht * 0.060,
                      child: Consumer<NowPlayingProvider>(
                        builder: (context, value, child) {
                          return MozSlider(
                              currentPosition: value.position,
                              totalDuration: value.duration,
                              onChanged: (newValue) {
                                value.changeToSeconds(
                                    newValue * value.duration.inSeconds);
                              },
                              sliderColor: Colors.deepPurple[400]!,
                              thumbColor: Colors.deepPurple[400]!,
                              backgroundColor:
                                  Colors.deepPurple[400]!.withOpacity(.1));
                        },
                      ),
                    ),
                  ),

                  SizedBox(
                    height: ht * 0.02,
                  ),

                  SizedBox(
                      height: ht * 0.11,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Shuffle Button here
                          Consumer<NowPlayingProvider>(
                              builder: (context, value, child) {
                            return InkWell(
                                onTap: () {
                                  bottomDetailsSheet(
                                    song: widget.songModelList,
                                    index: value.currentIndex,
                                    isPlaylistShown: true,
                                    onTap: () {
                                      DialogueUtils.getDialogue(
                                          context, 'peasy',
                                          arguments: widget.songModelList);
                                    },
                                    context: context,
                                  );
                                },
                                child: Icon(
                                  Icons.more_vert_rounded,
                                  size: wt * 0.07,
                                  color: const Color(0xff9CADC0),
                                ));
                          }),

                          StreamBuilder<LoopMode>(
                            stream: MozController.player.loopModeStream,
                            builder: (context, snapshot) {
                              return repeatButton(
                                  context, snapshot.data ?? LoopMode.off, wt);
                            },
                          ),

                          Consumer<NowPlayingProvider>(
                            builder: (context, value, child) {
                              return FavButMusicPlaying(
                                  songFavoriteMusicPlaying:
                                      widget.songModelList[value.currentIndex]);
                            },
                          ),

                          InkWell(
                            radius: 50,
                            overlayColor:
                                WidgetStateProperty.all(Colors.transparent),
                            onTap: () {
                              DialogueUtils.getDialogue(context, 'speed',
                                  arguments: isDark
                                      ? Colors.transparent
                                      : Colors.black.withOpacity(.3));
                            },
                            child: Icon(
                              Icons.speed,
                              size: wt * 0.07,
                              color: MozController.player.speed != 1.0
                                  ? Colors.deepPurple[400]
                                  : const Color(0xff9CADC0),
                            ),
                          ),
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        //Skip TO Previous Song
                        StreamBuilder<bool>(
                          stream: MozController.player.shuffleModeEnabledStream,
                          builder: (context, snapshot) {
                            bool isEnabled = snapshot.data ?? false;
                            return shuffleButton(context, isEnabled, wt);
                          },
                        ),

                        nextPrevoiusIcons(
                          context,
                          () {
                            context
                                .read<NowPlayingProvider>()
                                .previousButtonHere();
                          },
                          FontAwesomeIcons.backward,
                        ),

                        StreamBuilder<PlayerState>(
                          stream: MozController.player.playerStateStream,
                          builder: (_, snapshot) {
                            return SizedBox(
                                height: ht * 0.13,
                                width: wt * 0.13,
                                child: playPauseButton(
                                    context, MozController.player.playing, wt));
                          },
                        ),

                        nextPrevoiusIcons(
                          context,
                          () async {
                            context.read<NowPlayingProvider>().nextButtonHere();
                          },
                          FontAwesomeIcons.forward,
                        ),
                        homeButton(context, wt),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
