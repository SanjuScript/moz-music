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
  required String artist,
  required String title,
  required String composer,
  required SongModel song,
  required String filePath,
  required File file,
  required void Function() onTap,
  required int id,
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
              color: Theme.of(context).dialogBackgroundColor,
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
                    text: artistHelper(artist, 'null'),
                    icon: Icons.person_rounded,
                  ),
                  moreListTile(
                    context: context,
                    text: title,
                    icon: Icons.album,
                  ),
                  moreListTile(
                    context: context,
                    text: composer == 'null' ? 'unknown composer' : composer,
                    icon: Icons.piano_rounded,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/songInfo', arguments: {
                        'title': title,
                        'artist': artist,
                        'id': id,
                        'songs': song
                      });
                    },
                    child: moreListTile(
                      context: context,
                      text: 'Song Info',
                      icon: Icons.info_outline,
                    ),
                  ),
                  if (enableRemoveButton)
                    InkWell(
                      onTap: enableRemoveButton ? remove : null,
                      child: moreListTile(
                        context: context,
                        text: 'Remove from list',
                        icon: Icons.remove_circle_outline_sharp,
                      ),
                    ),
                  if (isPlaylistShown)
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
                      Share.shareFiles([filePath]);
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
                          if (FavoriteDb.isFavor(song)) {
                            FavoriteDb.delete(song.id);
                            Navigator.pop(context);
                          } else {
                            FavoriteDb.add(song);
                          }
                          FavoriteDb.favoriteSongs.notifyListeners();
                        },
                        child: moreListTile(
                          context: context,
                          text: FavoriteDb.isFavor(song)
                              ? 'Added to favorited'
                              : 'Add to favorites',
                          icon: FavoriteDb.isFavor(song)
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
