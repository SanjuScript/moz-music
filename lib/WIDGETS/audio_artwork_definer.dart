import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/COLORS/colors.dart';
import 'package:music_player/PROVIDER/color_extraction.dart';
import 'package:music_player/PROVIDER/theme_class_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'dart:typed_data';

import 'package:provider/provider.dart';

class AudioArtworkDefiner extends StatefulWidget {
  final int id;
  final int size;
  final double imgRadius;
  final bool enableAnimation;
  final double iconSize;
  const AudioArtworkDefiner({
    Key? key,
    required this.id,
    this.size = 250,
    this.iconSize = 70,
    this.imgRadius = 30,
    this.enableAnimation = false,
  }) : super(key: key);

  @override
  _AudioArtworkDefinerState createState() => _AudioArtworkDefinerState();
}

class _AudioArtworkDefinerState extends State<AudioArtworkDefiner>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late Future<Uint8List?> _artworkFuture;
  late int _currentId;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late ThemeProvider _themeProvider;

  @override
  void initState() {
    super.initState();
    _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _currentId = widget.id;
    _loadArtwork();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    if (widget.enableAnimation) {
      _animationController.forward();
    }
    if (_themeProvider.getTheme() == CustomThemes.darkThemeMode) {
      extractArtworkColors();
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
      if (_themeProvider.getTheme() == CustomThemes.darkThemeMode) {
        extractArtworkColors();
      }
    }
  }

  void _loadArtwork() {
    _artworkFuture = OnAudioQuery().queryArtwork(
      widget.id,
      ArtworkType.AUDIO,
      format: ArtworkFormat.JPEG,
      size: widget.size,
      quality: 100,
    );
  }

  void extractArtworkColors() {
    final colorProvider =
        Provider.of<ArtworkColorProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _artworkFuture.then((artworkData) {
      colorProvider.extractArtworkColors(
          artworkData, themeProvider.getTheme() == CustomThemes.darkThemeMode);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<Uint8List?>(
      future: _artworkFuture,
      builder: (context, snapshot) {
        if (widget.enableAnimation) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: _buildArtworkWidget(snapshot),
          );
        } else {
          return _buildArtworkWidget(snapshot);
        }
      },
    );
  }

  Widget _buildArtworkWidget(AsyncSnapshot<Uint8List?> snapshot) {
    if (snapshot.data != null && snapshot.data!.isNotEmpty) {
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
        ),
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
