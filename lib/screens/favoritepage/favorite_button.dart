// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:music_player/DATABASE/favorite_db.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key, required this.songFavorite});
  final SongModel songFavorite;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: FavoriteDb.favoriteSongs,
        builder:
            (BuildContext ctx, List<SongModel> favoriteData, Widget? child) {
          return IconButton(
            onPressed: () {
              if (FavoriteDb.isFavor(widget.songFavorite)) {
                FavoriteDb.delete(widget.songFavorite.id);
              } else {
                FavoriteDb.add(widget.songFavorite);
              }

              // ignore: invalid_use_of_protected_member
              FavoriteDb.favoriteSongs.notifyListeners();
            },
            icon: FavoriteDb.isFavor(widget.songFavorite)
                ? Icon(
                    Icons.favorite,
                    color: Theme.of(context).primaryColorDark,
                    size: 41,
                  )
                : Icon(
                    Icons.favorite,
                    color: Theme.of(context).hintColor,
                    size: 41,
                  ),
          );
        });
  }
}
