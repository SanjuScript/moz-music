import 'dart:developer';
import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_player/CONTROLLER/fetch_song.dart';
import 'package:music_player/CONTROLLER/playerpa.dart';
import 'package:music_player/HANDLER/audio_handler.dart';

class NewHoma extends StatefulWidget {
  // Instance of MyAudioHandler for managing audio playback
  final MozMusicHandler audioHandler;

  // Constructor to initialise with an instance of MyAudioHandler
  const NewHoma({Key? key, required this.audioHandler}) : super(key: key);

  @override
  State<NewHoma> createState() => _NewHomaState();
}

class _NewHomaState extends State<NewHoma> {
  // List to store MediaItems representing songs
  List<MediaItem> songs = [];

  @override
  void initState() {
    // Execute FetchSongs to retrieve and set the list of songs
    FetchSongs.execute().then(
      (value) {
        setState(() {
          songs = value;
        });

        // Initialize songs in the audio handler
        widget.audioHandler.initSongs(songs: value);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log(songs.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music App"),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SizedBox(
        height: MediaQuery.of(context).size.height - 40,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: songs.length,
          itemBuilder: (context, index) {
            MediaItem item = songs[index];
            log(item.toString());
            return ListTile(
              title: Text(item.title),
            );
          },
        ),
      ),
    );
  }
}

class SongWidget extends StatelessWidget {
  // MyAudioHandler for managing audio playback
  final MozMusicHandler audioHandler;

  // MediaItem representing the current song
  final MediaItem item;

  // Index of the song in the list
  final int index;

  const SongWidget({
    Key? key,
    required this.audioHandler,
    required this.item,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.amber,
      onTap: () {
        audioHandler.skipToQueueItem(index);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerPage(audioHandler: audioHandler),
          ),
        );
      },
      leading: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: item.artUri == null
            ? const Icon(Icons.music_note)
            : FutureBuilder<Uint8List?>(
                future: toImage(uri: item.artUri!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Image.memory(
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
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
      ),
      title: Text(
        item.title ?? 'Unknown Title',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(item.artist ?? 'Unknown Artist'),
    );
  }
}
