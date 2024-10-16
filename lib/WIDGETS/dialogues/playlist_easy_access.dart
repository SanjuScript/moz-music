import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/Model/music_model.dart';
import 'package:music_player/PROVIDER/now_playing_provider.dart';
import 'package:music_player/screens/playlist/playlist_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

 void showPlaylistEasyAccessDialogue({
    required BuildContext context,
    required List<SongModel> getList,
  }) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return _PlaylistDialog(getList: getList);
      },
    );
  }
  

class _PlaylistDialog extends StatefulWidget {
  final List<SongModel> getList;
  const _PlaylistDialog({super.key, required this.getList});

  @override
  State<_PlaylistDialog> createState() => __PlaylistDialogState();
}

class __PlaylistDialogState extends State<_PlaylistDialog> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 18).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _sigma => _animation.value;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: _sigma, sigmaY: _sigma),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).dialogBackgroundColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDialogTitle(context),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    _buildPlaylistContent(context),
                    const SizedBox(height: 20),
                    _buildCloseButton(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDialogTitle(BuildContext context) {
    return Text(
      "Playlists",
      style: TextStyle(
        fontFamily: 'coolvetica',
        color: Theme.of(context).disabledColor,
        fontSize: 18,
      ),
    );
  }

  Widget _buildPlaylistContent(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<MusicModel>('playlistDB').listenable(),
      builder: (BuildContext context, Box<MusicModel> value, Widget? child) {
        if (value.isEmpty) {
          return Column(
            children: [
              _emptyPlaylistMessage(context),
              const SizedBox(height: 16),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PlaylistScreen()),
                  );
                },
                icon: const Icon(
                  Icons.add_circle,
                  color: Colors.green,
                ),
              ),
            ],
          );
        } else {
          return Consumer<NowPlayingProvider>(
            builder: (context, nowValue, child) {
              final itemCount = value.length;
              return SizedBox(
                height: itemCount > 6 ? 320 : null, // Set a max height for the dialog
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(), // Disable scroll inside ListView
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        final data = value.values.toList()[index];
                        return _buildPlaylistItem(context, data, nowValue);
                      },
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _emptyPlaylistMessage(BuildContext context) {
    return Center(
      child: Text(
        "No Playlist Found",
        style: TextStyle(
          fontFamily: 'coolvetica',
          fontSize: 18,
          color: Theme.of(context).unselectedWidgetColor,
        ),
      ),
    );
  }

  Widget _buildPlaylistItem(
      BuildContext context, MusicModel data, NowPlayingProvider nowValue) {
    return ListTile(
      title: Text(
        data.name.toUpperCase(),
        style: TextStyle(
          fontFamily: 'coolvetica',
          fontSize: 18,
          color: Theme.of(context).unselectedWidgetColor,
        ),
      ),
      trailing: IconButton(
        icon: data.isValueIn(widget.getList[nowValue.currentIndex].id)
            ? const Icon(Icons.done, color: Colors.purple)
            : const Icon(Icons.add_circle, color: Colors.purple),
        onPressed: () {
          if (!data.isValueIn(widget.getList[nowValue.currentIndex].id)) {
            data.add(widget.getList[nowValue.currentIndex].id);
          } else {
            data.deleteData(widget.getList[nowValue.currentIndex].id);
          }
        },
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Close",
            style: TextStyle(
              fontFamily: 'coolvetica',
              fontSize: 16,
              color: Theme.of(context).disabledColor,
            ),
          ),
        ),
      ],
    );
  }
}
