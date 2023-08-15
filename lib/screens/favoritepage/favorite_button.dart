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

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller with a duration of 300 milliseconds
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Define the tween for the animation (size of the heart icon)
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
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _playAnimation() {
    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: FavoriteDb.favoriteSongs,
      builder: (context, value, child) {
        return GestureDetector(
          onTap: () {
            if (FavoriteDb.isFavor(widget.songFavorite)) {
              FavoriteDb.delete(widget.songFavorite.id);
            } else {
              FavoriteDb.add(widget.songFavorite);
            }

            // Trigger the animation when the favorite button is tapped
            _playAnimation();

            // ignore: invalid_use_of_protected_member
            FavoriteDb.favoriteSongs.notifyListeners();
          },
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (BuildContext context, Widget? child) {
              return ScaleTransition(
                scale: _animation,
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: FavoriteDb.isFavor(widget.songFavorite)
                          ? [
                              const Color.fromARGB(255, 148, 101, 228),
                              const Color.fromARGB(255, 112, 64, 194),
                            ]
                          : [
                             
                               Theme.of(context).highlightColor,
                                 Theme.of(context).canvasColor,
                            
                            ],
                      tileMode: TileMode.clamp,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.srcATop,
                  child: const Icon(
                    Icons.favorite,
                    shadows: [
                      BoxShadow(
                        color: Color.fromARGB(80, 170, 140, 221),
                        offset: Offset(2, 2),
                        spreadRadius: 5,
                        blurRadius: 13,
                      ),
                      BoxShadow(
                        color: Color.fromARGB(92, 202, 202, 202),
                        blurRadius: 13,
                        spreadRadius: 5,
                        offset: Offset(-2, -2),
                      ),
                    ],
                    color: Colors.white, // Icon color for the mask
                    size: 41.0,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
