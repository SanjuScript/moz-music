import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:music_player/HELPER/artist_helper.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../DATABASE/favorite_db.dart';

Widget moreListTile({
  required BuildContext context,
  required String text,
  required IconData icon,
  Widget widget = const SizedBox(),
  bool isWidget = false,
}) {
  return ListTile(
    leading: isWidget ? widget : Icon(icon),
    title: Text(
      text,
      style: TextStyle(
        color: Theme.of(context).cardColor,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}

void bottomDetailsSheet({
  required BuildContext context,
  required int index,
  required List<SongModel> song,
  required void Function() onTap,
  void Function()? remove,
  bool enableRemoveButton = false,
  bool isPlaylistShown = false,
}) async {
  await showModalBottomSheet<void>(
    backgroundColor: Colors.transparent,
    isDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).splashColor.withOpacity(.9),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  moreListTile(
                    context: context,
                    text: artistHelper(song[index].artist.toString(), 'null'),
                    icon: Icons.person_rounded,
                  ),
                  moreListTile(
                    context: context,
                    text: song[index].title,
                    icon: Icons.album,
                  ),
                  moreListTile(
                    context: context,
                    text: song[index].composer.toString() == 'null'
                        ? 'unknown composer'
                        : song[index].composer.toString(),
                    icon: Icons.piano_rounded,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/songInfo',
                          arguments: {'songs': song[index]});
                    },
                    child: moreListTile(
                      context: context,
                      text: 'Song Info',
                      icon: Icons.info_outline,
                    ),
                  ),
                  InkWell(
                    onTap: onTap,
                    child: moreListTile(
                      context: context,
                      text: 'Add to Playlist',
                      icon: Icons.playlist_add_rounded,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      final songPath = song[index].data;

                      final xFile = XFile(songPath);
                      Share.shareXFiles([xFile]);
                    },
                    child: moreListTile(
                      context: context,
                      text: 'Share song file',
                      icon: Icons.share_rounded,
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: FavoriteDb.favoriteSongs,
                    builder: (BuildContext ctx, List<SongModel> favoriteData,
                        Widget? child) {
                      return InkWell(
                        onTap: () {
                          if (FavoriteDb.isFavor(song[index])) {
                            FavoriteDb.delete(song[index].id);
                            Navigator.pop(context);
                          } else {
                            FavoriteDb.add(song[index]);
                          }
                          FavoriteDb.favoriteSongs.notifyListeners();
                        },
                        child: moreListTile(
                          context: context,
                          text: FavoriteDb.isFavor(song[index])
                              ? 'Added to favorited'
                              : 'Add to favorites',
                          icon: FavoriteDb.isFavor(song[index])
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                        ),
                      );
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
