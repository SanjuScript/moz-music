import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:music_player/DATABASE/favorite_db.dart';
import 'package:on_audio_query/on_audio_query.dart';

class BouncableEffect extends StatefulWidget {
  final Widget child;
  final bool onDoubletap;
  final SongModel songModel;
  const BouncableEffect({
    super.key,
    required this.child,
    required this.onDoubletap,
    required this.songModel,
  });

  @override
  State<BouncableEffect> createState() => _BouncableEffectState();
}

class _BouncableEffectState extends State<BouncableEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        }
      });
    _animation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void onTap() {
    _controller.forward();
  }
void onLongpress() {
    _controller.forward();
  }
  void onLongPressEnd(LongPressEndDetails details) {
    _controller.reverse();
  }


  void onDoubleTap() {
    _controller.forward();
    if (FavoriteDb.isFavor(widget.songModel)) {
      FavoriteDb.delete(widget.songModel.id);
    } else {
      FavoriteDb.add(widget.songModel);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onLongPress: onLongpress,
      // onLongPressEnd: onLongPressEnd,
      onTap: widget.onDoubletap ? null : onTap,
      onDoubleTap: widget.onDoubletap ? onDoubleTap : null,
      child: ScaleTransition(
        scale: _animation,
        child: widget.child,
      ),
    );
  }
}
