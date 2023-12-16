import 'dart:io';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/CONTROLLER/song_controllers.dart';
import 'package:music_player/HELPER/artist_helper.dart';
import 'package:music_player/PROVIDER/now_playing_provider.dart';
import 'package:music_player/PROVIDER/theme_class_provider.dart';
import 'package:music_player/WIDGETS/buttons/theme_button_widget.dart';
import 'package:music_player/screens/favoritepage/favorite_music_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../COLORS/colors.dart';
import '../Model/music_model.dart';
import '../WIDGETS/bottomsheet/song_info_sheet.dart';
import '../WIDGETS/buttons/next_prevoius_button.dart';
import '../WIDGETS/indicators.dart';
import '../WIDGETS/dialogues/speed_dialogue.dart';
import '../WIDGETS/nuemorphic_button.dart';
import '../Widgets/audio_artwork_definer.dart';
import '../ANIMATION/slide_animation.dart';
import 'playlist/playlist_screen.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({
    super.key,
    required this.songModelList,
  });
  //song model List
  final List<SongModel> songModelList;

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

//Defined Duration State
class _NowPlayingState extends State<NowPlaying>
    with AutomaticKeepAliveClientMixin {
  // late ColorProvider _colorProvider;
  void addSongToPlaylist(
      BuildContext context, SongModel data, datas, int index) {
    if (!datas.isValueIn(data.id)) {
      datas.add(data.id);
    } else {
      datas.deleteData(widget.songModelList[index].id);
    }
  }

  bool _shuffleMode = false;
  //  late BuildContext capturedContext;
  @override
  void initState() {
    super.initState();

    Provider.of<NowPlayingProvider>(context, listen: false).initStateHere();
    Provider.of<NowPlayingProvider>(context, listen: false).playSong();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final nowPlayingProviderFalse =
        Provider.of<NowPlayingProvider>(context, listen: false);
    final nowPlayingProvider = Provider.of<NowPlayingProvider>(context);
    // final _colorProvider = Provider.of<ColorProvider>(context);

    final ht = MediaQuery.of(context).size.height;
    final wt = MediaQuery.of(context).size.width;

    String filePath = widget
        .songModelList[Provider.of<NowPlayingProvider>(context).currentIndex]
        .data;
    File file = File(filePath);

    // double fileSizeInMB = getFileSizeInMB(file);
    // ColorProvider colorProvider = Provider.of<ColorProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDark = themeProvider.gettheme() == darkThemeMode;
    Color? dColor = isDark
        // ? colorProvider.currentColor.withOpacity(.8)
        ? const Color.fromARGB(146, 26, 15, 28)
        : Theme.of(context).scaffoldBackgroundColor;

    return WillPopScope(
        onWillPop: () {
          return nowPlayingProvider.willPopHere();
        },
        child: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: AnimatedContainer(
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
                  dColor.withOpacity(.7),
                  Theme.of(context).scaffoldBackgroundColor,
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
                              fontFamily: 'rounder',
                              fontSize: wt * 0.04,
                              letterSpacing: .6,
                              // color: const Color(0xff333c67),
                              color: Theme.of(context).unselectedWidgetColor),
                        ),
                        const ChangeThemeButtonWidget(),
                      ],
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.all(7),
                      width: wt * 0.85,
                      height: ht * 0.38,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Consumer<NowPlayingProvider>(
                        builder: (context, value, child) {
                          return Stack(
                            fit: StackFit.passthrough,
                            children: [
                              // AudioArtworkDefiner(
                              //   id: widget
                              //       .songModelList[value.currentIndex].id,
                              //   size: 100,
                              //   isRectangle: true,
                              //   enableAnimation: false,
                              //   radius: 30,
                              // ),
                              // Positioned.fill(
                              //   child: ClipRRect(
                              //     borderRadius: BorderRadius.circular(30),
                              //     child: BackdropFilter(
                              //       filter: ImageFilter.blur(
                              //           sigmaX: 8,
                              //           sigmaY:
                              //               8), // Adjust the blur intensity here
                              //       child: Container(
                              //         color: Colors.transparent,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              AudioArtworkDefiner(
                                id: widget.songModelList[value.currentIndex].id,
                                size: 1000,
                                isRectangle: true,
                                enableAnimation: true,
                                radius: 30,
                              ),
                            ],
                          );
                        },
                      )),
                  SizedBox(
                    height: ht * 0.02,
                  ),
                  SizedBox(
                    height: ht * 0.04,
                    width: wt * 0.7,
                    child: Text(
                      widget
                          .songModelList[nowPlayingProvider.currentIndex].title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'rounder',
                          fontSize: ht * 0.03,
                          letterSpacing: .5,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w200,
                          color: Theme.of(context).hintColor),
                    ),
                  ),
                  SizedBox(
                    height: ht * 0.01,
                  ),
                  SizedBox(
                    width: wt * 0.8,
                    height: ht * 0.02,
                    child: Text(
                      artistHelper(
                          widget.songModelList[nowPlayingProvider.currentIndex]
                              .artist
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
                      height: ht * 0.020,
                      child: Nuemorphic(
                        shadowColorVisiblity: true,
                        padding:
                            const EdgeInsets.only(top: 4, left: 5, right: 5),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        child: Consumer<NowPlayingProvider>(
                          builder: (context, value, child) {
                            return ProgressBar(
                              barHeight: ht * 0.012,
                              barCapShape: BarCapShape.round,
                              progressBarColor: Colors.deepPurple[400],
                              bufferedBarColor: Colors.deepPurple[400],
                              thumbGlowColor: Colors.transparent,
                              thumbColor: Colors.deepPurple[400],
                              thumbRadius: ht * 0.005,
                              thumbGlowRadius: wt * 0.07,
                              baseBarColor: Colors.transparent,
                              progress: value.position,
                              total: value.duration,
                              timeLabelTextStyle: TextStyle(
                                  fontSize: wt * 0.03,
                                  fontWeight: FontWeight.normal,
                                  color: const Color(0xff97A4B7)),
                              timeLabelPadding: ht * 0.011,
                              onSeek: (duration) {
                                value.changeToSeconds(
                                    duration.inSeconds.toDouble());
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  //Space

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
                                    id: widget
                                        .songModelList[value.currentIndex].id,
                                    context: context,
                                    artist: widget
                                        .songModelList[value.currentIndex]
                                        .artist
                                        .toString(),
                                    title: widget
                                        .songModelList[value.currentIndex]
                                        .title,
                                    composer: widget
                                        .songModelList[value.currentIndex]
                                        .composer
                                        .toString(),
                                    genre: widget
                                        .songModelList[value.currentIndex].genre
                                        .toString(),
                                    song: widget
                                        .songModelList[value.currentIndex],
                                    filePath: filePath,
                                    file: file,
                                    isPlaylistShown: true,
                                    onTap: () {
                                      showPlaylistdialog(context);
                                    },
                                  );
                                },
                                child: Icon(
                                  Icons.more_vert_rounded,
                                  size: wt * 0.07,
                                  color: const Color(0xff9CADC0),
                                ));
                          }),

                          //Lopp Mode Button here

                          InkWell(
                            radius: 50,
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                            onTap: () {
                              if (GetSongs.player.loopMode == LoopMode.off) {
                                GetSongs.player.setLoopMode(LoopMode.one);
                              } else {
                                GetSongs.player.setLoopMode(LoopMode.off);
                              }
                            },
                            child: StreamBuilder<LoopMode>(
                              stream: GetSongs.player.loopModeStream,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                final loopMode = snapshot.data;
                                if (loopMode == LoopMode.off) {
                                  return Icon(
                                    FontAwesomeIcons.repeat,
                                    size: wt * 0.05,
                                    color: const Color(0xff9CADC0),
                                  );
                                } else {
                                  return Icon(
                                    FontAwesomeIcons.repeat,
                                    size: wt * 0.05,
                                    color: Colors.deepPurple[400],
                                  );
                                }
                              },
                            ),
                          ),

                          //Favorite Button Here

                          FavButMusicPlaying(
                              songFavoriteMusicPlaying: widget.songModelList[
                                  nowPlayingProviderFalse.currentIndex]),

                          //Speed Controll Button Here

                          InkWell(
                            radius: 50,
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                            onTap: () {
                              showSpeedDialogue(context);
                            },
                            child: Icon(
                              Icons.speed,
                              size: wt * 0.07,
                              color: GetSongs.player.speed != 1.0
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
                        InkWell(
                          radius: 50,
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          onTap: () {
                            if (GetSongs.player.shuffleModeEnabled == true) {
                              GetSongs.player.setShuffleModeEnabled(false);
                            } else {
                              GetSongs.player.setShuffleModeEnabled(true);
                            }
                          },
                          child: StreamBuilder<bool>(
                            stream: GetSongs.player.shuffleModeEnabledStream,
                            builder: (context, snapshot) {
                              // Check if the stream has data
                              if (snapshot.hasData) {
                                _shuffleMode = snapshot.data!;
                                if (_shuffleMode) {
                                  return Icon(
                                    FontAwesomeIcons.shuffle,
                                    size: wt * 0.06,
                                    color: Colors.deepPurple[400],
                                  );
                                } else {
                                  return Icon(
                                    FontAwesomeIcons.shuffle,
                                    size: wt * 0.06,
                                    color: const Color(0xff333c67),
                                  );
                                }
                              } else {
                                return const CircularProgressIndicator(); // or any other loading indicator
                              }
                            },
                          ),
                        ),

                        nextPrevoiusIcons(
                          context,
                          () {
                            nowPlayingProviderFalse.previousButtonHere();
                          },
                          FontAwesomeIcons.backward,
                        ),

                        // Play And Pause Song Button

                        SizedBox(
                          height: ht * 0.13,
                          width: wt * 0.13,
                          child: InkWell(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              onTap: () async {
                                nowPlayingProviderFalse.playPauseButtonHere();
                              },
                              child: ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return const LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 148, 101, 228),
                                        Color.fromARGB(255, 112, 64, 194),
                                      ],
                                      tileMode: TileMode.clamp,
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ).createShader(bounds);
                                  },
                                  blendMode: BlendMode.srcATop,
                                  child: GetSongs.player.playing
                                      ? Icon(
                                          FontAwesomeIcons.pause,
                                          size: wt * 0.15,
                                          shadows: const [
                                            BoxShadow(
                                              color: Color.fromARGB(
                                                  80, 170, 140, 221),
                                              offset: Offset(2, 2),
                                              spreadRadius: 5,
                                              blurRadius: 13,
                                            ),
                                            BoxShadow(
                                              color: Color.fromARGB(
                                                  92, 202, 202, 202),
                                              blurRadius: 13,
                                              spreadRadius: 5,
                                              offset: Offset(-2, -2),
                                            ),
                                          ],
                                          color: const Color(0xff9CADC0),
                                        )
                                      : Icon(
                                          FontAwesomeIcons.play,
                                          shadows: const [
                                            BoxShadow(
                                              color: Color.fromARGB(
                                                  80, 170, 140, 221),
                                              offset: Offset(2, 2),
                                              spreadRadius: 5,
                                              blurRadius: 13,
                                            ),
                                            BoxShadow(
                                              color: Color.fromARGB(
                                                  92, 202, 202, 202),
                                              blurRadius: 13,
                                              spreadRadius: 5,
                                              offset: Offset(-2, -2),
                                            ),
                                          ],
                                          size: wt * 0.13,
                                          color: const Color(0xff9CADC0),
                                        ))),
                        ),

                        //Skip To Next Song

                        nextPrevoiusIcons(
                          context,
                          () async {
                            nowPlayingProviderFalse.nextButtonHere();
                          },
                          FontAwesomeIcons.forward,
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              nowPlayingProvider.willPopHere();
                            },
                            child: Icon(
                              Icons.home_rounded,
                              color: const Color(0xff333c67),
                              size: wt * 0.07,
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  showPlaylistdialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: darkThemeMode.copyWith(
            dialogTheme: Theme.of(context).dialogTheme,
          ),
          child: Theme(
            data: darkThemeMode.copyWith(
                dialogTheme: Theme.of(context).dialogTheme),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Playlists",
                      style: TextStyle(
                        fontFamily: 'coolvetica',
                        fontSize: 20,
                        color: Theme.of(context).cardColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    ValueListenableBuilder(
                      valueListenable:
                          Hive.box<MusicModel>('playlistDB').listenable(),
                      builder: (BuildContext context, Box<MusicModel> value,
                          Widget? child) {
                        if (Hive.box<MusicModel>('playlistDB').isEmpty) {
                          return Column(
                            children: [
                              songEmpty(context, "No Playlist Found", () {},
                                  isSetting: false),
                              const SizedBox(height: 16),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    SearchAnimationNavigation(
                                        const PlaylistScreen()),
                                  );
                                },
                                icon: const Icon(
                                  Icons.add_circle,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Consumer<NowPlayingProvider>(
                            builder: (context, nowValue, child) {
                              final itemCount = value.length;
                              return SizedBox(
                                height: itemCount > 8
                                    ? 320
                                    : null, // Set a specific height if itemCount > 8
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: itemCount,
                                      itemBuilder: (context, index) {
                                        final data =
                                            value.values.toList()[index];
                                        return Dismissible(
                                          key: Key(data
                                              .name), // Use a unique key for each playlist
                                          direction:
                                              DismissDirection.startToEnd,
                                          background: Container(
                                            alignment: Alignment.centerLeft,
                                            color: Colors.grey[400],
                                            child: const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 16),
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          onDismissed: (direction) {
                                            value.deleteAt(index);
                                          },
                                          child: ListTile(
                                            title: Text(
                                              data.name.toUpperCase(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    Provider.of<ThemeProvider>(
                                                                    context)
                                                                .gettheme() ==
                                                            darkThemeMode
                                                        ? Colors.white
                                                        : Colors.black,
                                              ),
                                            ),
                                            trailing: IconButton(
                                              icon: data.isValueIn(widget
                                                      .songModelList[
                                                          nowValue.currentIndex]
                                                      .id)
                                                  ? const Icon(Icons.done)
                                                  : const Icon(
                                                      Icons.add_circle),
                                              onPressed: () {
                                                addSongToPlaylist(
                                                  context,
                                                  widget.songModelList[
                                                      nowValue.currentIndex],
                                                  data,
                                                  nowValue.currentIndex,
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
