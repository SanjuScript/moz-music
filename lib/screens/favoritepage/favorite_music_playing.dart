import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../DATABASE/favorite_db.dart';

class FavButMusicPlaying extends StatefulWidget {
  const FavButMusicPlaying({super.key, required this.songFavoriteMusicPlaying});
  final SongModel songFavoriteMusicPlaying;

  @override
  State<FavButMusicPlaying> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavButMusicPlaying> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: FavoriteDb.favoriteSongs,
        builder:
            (BuildContext ctx, List<SongModel> favoriteData, Widget? child) {
          return 
          InkWell(
            radius: 50,
              overlayColor:MaterialStateProperty.all(Colors.transparent),
            onTap: () {
              if (FavoriteDb.isFavor(widget.songFavoriteMusicPlaying)) {
                
                FavoriteDb.delete(widget.songFavoriteMusicPlaying.id);
              } else {
                FavoriteDb.add(widget.songFavoriteMusicPlaying);
              }

              // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
              FavoriteDb.favoriteSongs.notifyListeners();
            },
            child: FavoriteDb.isFavor(widget.songFavoriteMusicPlaying)
                ?   Icon(
                        Icons.favorite,
                        size: 23.0,
                        color:Colors.deepPurple[400],
                      )
                : const Icon(
                        Icons.favorite_border,
                        size: 23.0,
                        color: Color(0xff9CADC0),
                      ),
          );
        });
  }
}
