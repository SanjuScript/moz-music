import 'dart:io';
import 'dart:ui';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/DATABASE/recently_played.dart';
import 'package:music_player/CONTROLLER/song_controllers.dart';
import 'package:music_player/HELPER/artist_helper.dart';
import 'package:music_player/PROVIDER/now_playing_provider.dart';
import 'package:music_player/PROVIDER/theme_class_provider.dart';
import 'package:music_player/WIDGETS/dialogues/song_delete_dialogue.dart';
import 'package:music_player/screens/favoritepage/favorite_music_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../COLORS/colors.dart';
import '../Model/music_model.dart';
import '../WIDGETS/bottomsheet/song_info_sheet.dart';
import '../WIDGETS/buttons/icon_buttons.dart';
import '../WIDGETS/buttons/next_prevoius_button.dart';
import '../WIDGETS/indicators.dart';
import '../WIDGETS/dialogues/speed_dialogue.dart';
import '../WIDGETS/nuemorphic_button.dart';
import '../WIDGETS/playlist_card.dart';
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
//Back Arrow

  void addSongToPlaylist(
      BuildContext context, SongModel data, datas, int index) {
    if (!datas.isValueIn(data.id)) {
      datas.add(data.id);
    } else {
      datas.deleteData(widget.songModelList[index].id);
    }
  }

  bool _shuffleMode = false;
  @override
  void initState() {
    super.initState();
    Provider.of<NowPlayingProvider>(context, listen: false).initStateHere();
    Provider.of<NowPlayingProvider>(context, listen: false).playSong();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final nowPlayingProviderFalse =
        Provider.of<NowPlayingProvider>(context, listen: false);
    final nowPlayingProvider = Provider.of<NowPlayingProvider>(context);
    final ht = MediaQuery.of(context).size.height;
    final wt = MediaQuery.of(context).size.width;

    String filePath = widget
        .songModelList[Provider.of<NowPlayingProvider>(context).currentIndex]
        .data;
    File file = File(filePath);

    // double fileSizeInMB = getFileSizeInMB(file);
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return WillPopScope(
      onWillPop: () {
        return nowPlayingProvider.willPopHere();
      },
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: ht * 0.02,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      //Back Arrow Here
                      iconConatiner(
                          InkWell(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              onTap: () {
                                nowPlayingProviderFalse.backButtonHere(context);
                              },
                              child: Icon(
                                FontAwesomeIcons.arrowLeft,
                                size: wt * 0.05,
                                color: const Color(0xff97A4B7),
                              )),
                          context),
                      Text(
                        "PLAYING NOW",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: wt * 0.04,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff97A4B7)),
                      ),
                      iconConatiner(Consumer<NowPlayingProvider>(
                        builder: (context, value, child) {
                          return IconButton(
                              onPressed: () {
                                bottomDetailsSheet(
                                  id: widget
                                      .songModelList[value.currentIndex].id,
                                  context: context,
                                  artist: widget
                                      .songModelList[value.currentIndex].artist
                                      .toString(),
                                  title: widget
                                      .songModelList[value.currentIndex].title,
                                  composer: widget
                                      .songModelList[value.currentIndex]
                                      .composer
                                      .toString(),
                                  genre: widget
                                      .songModelList[value.currentIndex].genre
                                      .toString(),
                                  song:
                                      widget.songModelList[value.currentIndex],
                                  filePath: filePath,
                                  file: file,
                                  isPlaylistShown: true,
                                  onTap: () {
                                    showPlaylistdialog(context);
                                  },
                                  delete: () async {
                                    showSongDeleteDialogue(
                                        context,
                                        widget
                                            .songModelList[value.currentIndex]);
                                    widget.songModelList.removeAt(widget
                                        .songModelList[value.currentIndex].id);
                                    if (GetSongs.player.hasNext) {
                                      await GetSongs.player.seekToNext();
                                      await GetSongs.player.play();
                                    } else if (GetSongs.player.hasPrevious) {
                                      await GetSongs.player.play();
                                    }
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.more_vert_rounded,
                                color: Color(0xff97A4B7),
                              ));
                        },
                      ), context)
                    ],
                  ),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    padding: const EdgeInsets.all(7),
                    width: wt * 0.8,
                    height: ht * 0.36,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      shape: BoxShape.rectangle,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor,
                          blurRadius: 5,
                          offset: const Offset(2, 2),
                        ),
                        BoxShadow(
                          color: Theme.of(context).dividerColor,
                          blurRadius: 5,
                          offset: const Offset(-2, -2),
                        ),
                      ],
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Consumer<NowPlayingProvider>(
                      builder: (context, value, child) {
                        return Stack(
                          fit: StackFit.passthrough,
                          children: [
                            AudioArtworkDefiner(
                              id: widget.songModelList[value.currentIndex].id,
                              size: 100,
                              isRectangle: true,
                              enableAnimation: false,
                              radius: 30,
                            ),
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 8,
                                      sigmaY:
                                          8), // Adjust the blur intensity here
                                  child: Container(
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                            AudioArtworkDefiner(
                              id: widget.songModelList[value.currentIndex].id,
                              size: 500,
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
                  width: wt * 0.6,
                  child: Text(
                    widget.songModelList[nowPlayingProvider.currentIndex].title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'beauty',
                        fontSize: ht * 0.03,
                        letterSpacing: .5,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff97A4B7)),
                  ),
                ),
                SizedBox(
                  height: ht * 0.01,
                ),
                SizedBox(
                  width: wt * 0.7,
                  height: ht * 0.02,
                  child: Text(
                    artistHelper(
                        widget.songModelList[nowPlayingProvider.currentIndex]
                            .artist
                            .toString(),
                        'null'),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                        fontFamily: 'optica',
                        fontSize: ht * 0.0165,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xff97A4B7)),
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
                    height: ht * 0.02,
                    child: Nuemorphic(
                      padding: const EdgeInsets.only(top: 4, left: 5, right: 5),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: Consumer<NowPlayingProvider>(
                        builder: (context, value, child) {
                          return ProgressBar(
                            barHeight: ht * 0.011,
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
                                  color: const Color(0xff9CADC0),
                                );
                              }
                            },
                          ),
                        ),

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
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              final loopMode = snapshot.data;
                              if (loopMode == LoopMode.off) {
                                return Icon(
                                  Icons.loop,
                                  size: wt * 0.07,
                                  color: const Color(0xff9CADC0),
                                );
                              } else {
                                return Icon(
                                  Icons.loop,
                                  size: wt * 0.07,
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
                            color: const Color(0xff9CADC0),
                          ),
                        ),
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    //Skip TO Previous Song

                    nextPrevoiusIcons(
                      context,
                      () async {
                        RecentlyPlayedDB.addRecentlyPlayed(GetSongs
                            .playingSongs[nowPlayingProviderFalse.currentIndex]
                            .id);
                        nowPlayingProviderFalse.previousButtonHere();
                      },
                      FontAwesomeIcons.backward,
                    ),

                    // Play And Pause Song Button

                    Container(
                      height: ht * 0.13,
                      width: wt * 0.26,
                      decoration: BoxDecoration(
                          // color: Color.fromARGB(255, 91, 123, 176),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).shadowColor,
                              blurRadius: 6,
                              offset: const Offset(2, 2),
                            ),
                            BoxShadow(
                              color: Theme.of(context).dividerColor,
                              blurRadius: 6,
                              offset: const Offset(-2, -2),
                            ),
                          ]),
                      child: InkWell(
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          onTap: () async {
                            nowPlayingProviderFalse.playPauseButtonHere();
                          },
                          child: GetSongs.player.playing
                              ? Icon(
                                  Icons.pause_rounded,
                                  size: wt * 0.13,
                                  color: const Color(0xff9CADC0),
                                )
                              : Icon(
                                  Icons.play_arrow_rounded,
                                  size: wt * 0.13,
                                  color: const Color(0xff9CADC0),
                                )),
                    ),

                    //Skip To Next Song

                    nextPrevoiusIcons(
                      context,
                      () async {
                        RecentlyPlayedDB.addRecentlyPlayed(GetSongs
                            .playingSongs[nowPlayingProviderFalse.currentIndex]
                            .id);
                        nowPlayingProviderFalse.nextButtonHere();
                      },
                      FontAwesomeIcons.forward,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
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
                    Divider(),
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
                                            color: Colors.red,
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
