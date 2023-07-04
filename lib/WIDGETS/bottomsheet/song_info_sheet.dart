import 'dart:io';
import 'package:flutter/material.dart';
import 'package:music_player/HELPER/artist_helper.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:share_plus/share_plus.dart';

import '../../DATABASE/favorite_db.dart';

Widget moreListSheet(
    {required BuildContext context,
    required String text,
    required IconData icon,
    widget = const SizedBox(),
    bool isWidget = false}) {
  return ListTile(
      leading: isWidget ? widget : Icon(icon),
      title: Text(
        text,
        style: TextStyle(
            color: Theme.of(context).cardColor,
            overflow: TextOverflow.ellipsis),
      ));
}

void bottomDetailsSheet({
  required BuildContext context,
  required String artist,
  required String title,
  required String composer,
  required String genre,
  required SongModel song,
  required String filePath,
  required File file,
  required void Function() onTap,
  required int id,
  void Function()? remove,
  bool enableRemoveButon = false,
  bool isPlaylistShown = false,
  required void Function() delete,
}) async {
  await showModalBottomSheet<void>(
    backgroundColor: Colors.transparent,
    isDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Bottom sheet content
              moreListSheet(
                context: context,
                text: artistHelper(artist, 'null'),
                icon: Icons.person_rounded,
              ),
              moreListSheet(
                context: context,
                text: title,
                icon: Icons.album,
              ),
              moreListSheet(
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
                child: moreListSheet(
                  context: context,
                  text: 'Song Info',
                  icon: Icons.info_outline,
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
                      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                      FavoriteDb.favoriteSongs.notifyListeners();
                    },
                    child: moreListSheet(
                      context: context,
                      text: 'Add to favorites',
                      icon: FavoriteDb.isFavor(song)
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                    ),
                  );
                },
              ),
              enableRemoveButon ?  InkWell(
                      onTap: enableRemoveButon ? remove : null,
                      child: moreListSheet(
                        context: context,
                        text: 'Remove from list',
                        icon: Icons.remove_circle_outline_sharp,
                      ),
                    )
                  : const SizedBox(),
              isPlaylistShown
                  ? InkWell(
                      onTap: onTap,
                      child: moreListSheet(
                        context: context,
                        text: 'Add to Playlist',
                        icon: Icons.playlist_add_rounded,
                      ),
                    )
                  : const SizedBox(),
              InkWell(
                onTap: () {
                  Share.shareFiles([filePath]);
                },
                child: moreListSheet(
                  context: context,
                  text: 'Share song file',
                  icon: Icons.share_rounded,
                ),
              ),
              InkWell(
                onTap: delete,
                child: moreListSheet(
                  context: context,
                  text: 'Delete',
                  icon: Icons.delete_rounded,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
