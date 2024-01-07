import 'dart:io';
import 'package:flutter/material.dart';
import 'package:music_player/DATABASE/most_played.dart';
import 'package:music_player/HELPER/artist_helper.dart';
import 'package:music_player/SCREENS/main_music_playing_screen.dart.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../CONTROLLER/song_controllers.dart';
import '../screens/favoritepage/favorite_button.dart';
import 'bottomsheet/song_info_sheet.dart';
import 'nuemorphic_button.dart';
import 'audio_artwork_definer.dart';

class SongListViewer extends StatelessWidget {
  final Widget child;
  final BorderRadiusGeometry borderradius;
  final Gradient? gradient;
  final bool shadowVisibility;
  final Color color;
  final EdgeInsetsGeometry margin;
  const SongListViewer({
    super.key,
    required this.child,
    this.gradient,
    this.shadowVisibility = true,
    required this.borderradius,
    required this.color,
    required this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: margin,
      height: MediaQuery.of(context).size.height * 0.13,
      width: MediaQuery.of(context).size.height * 0.10,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderradius,
        boxShadow: shadowVisibility
            ? [
                BoxShadow(
                  color: Theme.of(context).shadowColor,
                  blurRadius: 3,
                  offset: const Offset(2, 2),
                ),
                BoxShadow(
                  color: Theme.of(context).dividerColor,
                  blurRadius: 3,
                  offset: const Offset(-2, -2),
                ),
              ]
            : [],
        gradient: gradient,
      ),
      child: child,
    );
  }
}

// ignore: must_be_immutable
class SongListViewerForSections extends StatelessWidget {
  double radius;
  Widget child;
  int id;
  String title;
  String subtitle;
  IconData icon;
  Color color;
  String fileSize;
  bool isWidget;
  void Function() onLongpress;
  void Function() onTap;
  void Function() trailingOnTap;
  bool isBoxshadowYes;
  Widget trailingWidget;
  ArtworkType artwork;
  SongListViewerForSections(
      {super.key,
      this.radius = 15,
      required this.child,
      required this.id,
      required this.subtitle,
      this.isWidget = false,
      this.trailingWidget = const SizedBox(),
      required this.onTap,
      required this.icon,
      this.isBoxshadowYes = true,
      this.artwork = ArtworkType.AUDIO,
      required this.fileSize,
      this.color = Colors.black45,
      required this.trailingOnTap,
      required this.title,
      required this.onLongpress});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 2, top: 1),
          height: MediaQuery.of(context).size.height * 0.13,
          width: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: isBoxshadowYes
                ? [
                    BoxShadow(
                      color: Theme.of(context).shadowColor,
                      blurRadius: 3,
                      offset: const Offset(2, 2),
                    ),
                    BoxShadow(
                      color: Theme.of(context).dividerColor,
                      blurRadius: 3,
                      offset: const Offset(-2, -2),
                    ),
                  ]
                : [],
          ),
          child: ListTile(
            tileColor: Theme.of(context).scaffoldBackgroundColor,
            leading: Transform.scale(
              scale: MediaQuery.of(context).size.width * 0.0050,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                child: CircleAvatar(
                  child: Nuemorphic(
                    shadowVisibility: false,
                    child: AudioArtworkDefiner(
                      id: id,
                      type: artwork,
                      isRectangle: true,
                      radius: 5,
                      imgRadius: 5,
                      iconSize: 25,
                    ),
                  ),
                ),
              ),
            ),
            onLongPress: onLongpress,
            title: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.06),
              child: Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).cardColor,
                  fontFamily: "bold",
                  letterSpacing: .6,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.06),
              child: Text(
                subtitle,
                maxLines: 1,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.038,
                  fontFamily: 'optica',
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).cardColor,
                ),
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.1),
            ),
            onTap: onTap,
            trailing: isWidget
                ? IconButton(
                    color: Colors.red,
                    onPressed: trailingOnTap,
                    icon: Icon(
                      icon,
                      color: color,
                    ),
                  )
                : trailingWidget,
          ),
        ),
        Positioned(
          right: 20,
          bottom: 5,
          child: Text(
            fileSize,
            maxLines: 1,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.038,
              fontFamily: 'optica',
              fontWeight: FontWeight.w400,
              color: Theme.of(context).cardColor,
            ),
          ),
        ),
      ],
    );
  }
}

Widget songDisplay(BuildContext context,
    {required SongModel song,
    required List<SongModel> songs,
    bool isTrailingChange = false,
    bool disableOnTap = false,
    Widget? trailing,
    void Function()? remove,
    required int index}) {
  // String filePath = song.data;
  // File file = File(filePath);

// log('File Path: $filePath');
// log('File Size: $fileSizeInMB MB');
  return ListTile(
      tileColor: Theme.of(context).scaffoldBackgroundColor,
      leading: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.25,
        width: MediaQuery.sizeOf(context).width * 0.16,
        child: AudioArtworkDefiner(
          id: song.id,
          imgRadius: 8,
          iconSize: 30,
        ),
      ),
      title: Text(
        // item.data![index].title.toUpperCase(),
        song.title,
        maxLines: 1,
        style: TextStyle(
          fontWeight: FontWeight.w300,
          color: Theme.of(context).disabledColor,
          letterSpacing: .6,
          // fontWeight: FontWeight.bold,
          fontFamily: 'rounder',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      onLongPress: () {
        bottomDetailsSheet(
          context: context,
          enableRemoveButon: true,
          remove: remove,
          artist: song.artist.toString(),
          title: song.title,
          composer: song.composer.toString(),
          genre: song.genre.toString(),
          song: song,
          filePath: song.data,
          file: File(song.data),
          onTap: () {},
          id: song.id,
        );
      },
      selectedTileColor: Theme.of(context).scaffoldBackgroundColor,
      selectedColor: Theme.of(context).scaffoldBackgroundColor,
      focusColor: Theme.of(context).scaffoldBackgroundColor,
      hoverColor: Theme.of(context).scaffoldBackgroundColor,
      subtitle: Text(
        artistHelper(song.artist.toString(), song.fileExtension),
        maxLines: 1,
        style:  TextStyle(
            fontSize: 13,
            fontFamily: 'rounder',
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.normal,
            color:Theme.of(context).cardColor.withOpacity(.4)),
      ),
      onTap: disableOnTap
          ? null
          : () {
              if (GetSongs.player.playing != true) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NowPlaying(
                              songModelList: songs,
                            )));
              }
              //   print("object");
              // }
              GetSongs.player.setAudioSource(GetSongs.createSongList(songs),
                  //item.data
                  initialIndex: index);
              //index
              // RecentlyPlayedDB.addRecentlyPlayed(song);
              MostlyPlayedDB.incrementPlayCount(song);
              GetSongs.player.play();
              // RecentlyPlayedDB.intialize(songs);
              GetSongs.playingSongs = songs;
            },
      trailing:
          isTrailingChange ? trailing : FavoriteButton(songFavorite: song));
}
