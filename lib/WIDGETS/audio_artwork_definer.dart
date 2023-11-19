import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/COLORS/colors.dart';
import 'package:music_player/PROVIDER/color_provider.dart';
import 'package:music_player/PROVIDER/theme_class_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'dart:typed_data';

import 'package:provider/provider.dart';

class AudioArtworkDefiner extends StatefulWidget {
  final int id;
  final int size;
  final bool isRectangle;
  final double radius;
  final double imgRadius;
  final bool enableAnimation;
  final ArtworkType type;
  final bool visibleShadow;
  final double iconSize;
  const AudioArtworkDefiner({
    Key? key,
    required this.id,
    this.size = 250,
    this.iconSize = 70,
    this.imgRadius = 30,
    this.isRectangle = false,
    this.radius = 0,
    this.enableAnimation = false,
    this.visibleShadow = false,
    this.type = ArtworkType.AUDIO,
  }) : super(key: key);

  @override
  _AudioArtworkDefinerState createState() => _AudioArtworkDefinerState();
}

class _AudioArtworkDefinerState extends State<AudioArtworkDefiner>
    with SingleTickerProviderStateMixin {
  late Future<Uint8List?> _artworkFuture;
  late int _currentId;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  @override
  void initState() {
    super.initState();
    _currentId = widget.id;
    _loadArtwork();
    _animationController = AnimationController(
      vsync: this,
      value: widget.enableAnimation ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    if (widget.enableAnimation) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant AudioArtworkDefiner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.id != _currentId) {
      _currentId = widget.id;
      _loadArtwork();
      if (widget.enableAnimation) {
        _animationController.forward(from: 0.0);
      }
    }
  }

  void _loadArtwork() {
    _artworkFuture = OnAudioQuery().queryArtwork(
      widget.id,
      widget.type,
      format: ArtworkFormat.JPEG,
      size: widget.size,
      quality: 100,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final _colorProvider = Provider.of<ColorProvider>(context); 
       return FutureBuilder<Uint8List?>(
      future: _artworkFuture,
      builder: (context, snapshot) {
        return AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: widget.enableAnimation ? _scaleAnimation.value : 1.0,
              child: child,
            );
          },
          child: _buildArtworkWidget(snapshot),
        );
      },
    );
  }

  Widget _buildArtworkWidget(AsyncSnapshot<Uint8List?> snapshot) {
    if (snapshot.data != null && snapshot.data!.isNotEmpty) {
      // Provider.of<ColorProvider>(context, listen: false)
      //     .extractArtworkColors(snapshot.data!);
  return ClipRRect(
    borderRadius: BorderRadius.circular(widget.imgRadius),
    clipBehavior: Clip.antiAlias,
    child: Image.memory(
      snapshot.data!,
      gaplessPlayback: true,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
      errorBuilder: (context, exception, stackTrace) {
        return const Icon(
          Icons.image_not_supported,
          size: 50,
        );
      },
    ),
  );
    } else {
  return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).indicatorColor,
        borderRadius: BorderRadius.circular(widget.imgRadius),
      ),
      child: Icon(
        Icons.music_note_rounded,
        size: widget.iconSize,
        color: Theme.of(context).secondaryHeaderColor,
      ));
    }
  }
}
 