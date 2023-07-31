import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../DATABASE/favorite_db.dart';

class FavButMusicPlaying extends StatefulWidget {
  const FavButMusicPlaying({Key? key, required this.songFavoriteMusicPlaying})
      : super(key: key);
  final SongModel songFavoriteMusicPlaying;

  @override
  State<FavButMusicPlaying> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavButMusicPlaying>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _animation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: FavoriteDb.favoriteSongs,
      builder: (BuildContext ctx, List<SongModel> favoriteData, Widget? child) {
        return GestureDetector(
          onTap: () {
            if (FavoriteDb.isFavor(widget.songFavoriteMusicPlaying)) {
              FavoriteDb.delete(widget.songFavoriteMusicPlaying.id);
            } else {
              FavoriteDb.add(widget.songFavoriteMusicPlaying);
            }

            // Trigger the animation when the favorite button is tapped
            _animationController.forward();

            // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
            FavoriteDb.favoriteSongs.notifyListeners();
          },
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (BuildContext context, Widget? child) {
              return ScaleTransition(
                scale: _animation,
                child: Icon(
                  FavoriteDb.isFavor(widget.songFavoriteMusicPlaying)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  size: 23.0,
                  color: FavoriteDb.isFavor(widget.songFavoriteMusicPlaying)
                      ? Colors.deepPurple[400]
                      : Color(0xff9CADC0),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
