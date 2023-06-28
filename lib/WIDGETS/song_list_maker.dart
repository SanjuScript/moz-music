import 'dart:io';
import 'package:flutter/material.dart';
import 'package:music_player/WIDGETS/dialogues/song_delete_dialogue.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../CONTROLLER/song_controllers.dart';
import '../DATABASE/recently_played.dart';
import '../HELPER/toast.dart';
import '../screens/favoritepage/favorite_button.dart';
import '../screens/home_page.dart';
import '../screens/main_musicPlaying_screen.dart';
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
      this.artwork =  ArtworkType.AUDIO,
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
    {required int id,
    required String title,
    required String artist,
    required String exten,
    required String duration,
    required int inittialIndex,
    required String genre,
    required String composer,
    required List<SongModel> songs}) {
  String filePath = songs[inittialIndex].data;
  File file = File(filePath);

  // double fileSizeInMB = getFileSizeInMB(file);
// log('File Path: $filePath');
// log('File Size: $fileSizeInMB MB');
  return SongListViewer(
    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 5),
    color: Theme.of(context).scaffoldBackgroundColor,
    shadowVisibility: false,
    borderradius: const BorderRadius.all(Radius.circular(20)),
    child: ListTile(
        tileColor: Theme.of(context).scaffoldBackgroundColor,
        leading: Transform.scale(
          scale: MediaQuery.of(context).size.width * 0.0045,
          child: Padding(
            padding: const EdgeInsets.only(left: 7),
            child: CircleAvatar(
              child: Nuemorphic(
                padding: const EdgeInsets.all(2),
                borderRadius: BorderRadius.circular(100),
                child: AudioArtworkDefiner(
                  id: id,
                  isRectangle: false,
                ),
              ),
            ),
          ),
        ),
        title: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.06,
          ),
          child: Text(
            // item.data![index].title.toUpperCase(),
            title,
            maxLines: 1,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).cardColor,
              letterSpacing: .7,
              // fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        onLongPress: () {
          bottomDetailsSheet(
            delete: () {
              print(filePath);
              showSongDeleteDialogue(context, songs[inittialIndex]);
            },
            context: context,
            artist: artist,
            title: title,
            composer: composer,
            genre: genre,
            song: songs[inittialIndex],
            filePath: filePath,
            file: file,
            onTap: () {},
            id: songs[inittialIndex].id,
          );
        },
        selectedTileColor: Theme.of(context).scaffoldBackgroundColor,
        selectedColor: Theme.of(context).scaffoldBackgroundColor,
        focusColor: Theme.of(context).scaffoldBackgroundColor,
        hoverColor: Theme.of(context).scaffoldBackgroundColor,
        subtitle: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.06,
          ),
          child: Text(
            artist == '<unknown>' ? "Unknown Artist.$exten" : "$artist.$exten",
            maxLines: 1,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.038,
                fontFamily: 'optica',
                fontWeight: FontWeight.w400,
                color: Theme.of(context).cardColor),
          ),
        ),
        onTap: () {
          if (file.existsSync()) {
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
                initialIndex: inittialIndex);
            //index
            RecentlyPlayedDB.addRecentlyPlayed(songs[inittialIndex].id);

            GetSongs.player.play();
          } else {
            customToast("The song file does not exist anymore", context);
          }
        },
        trailing: FavoriteButton(songFavorite: startSong[inittialIndex])),
  );
}
