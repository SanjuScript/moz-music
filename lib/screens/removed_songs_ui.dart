import 'package:flutter/material.dart';
import 'package:music_player/PROVIDER/homepage_provider.dart';
import 'package:music_player/WIDGETS/dialogues/UTILS/dialogue_utils.dart';
import 'package:music_player/WIDGETS/song_list_maker.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class RemovedSongsPage extends StatelessWidget {
  const RemovedSongsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the HomePageSongProvider
    final homePageProvider = Provider.of<HomePageSongProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Removed Songs'),
        backgroundColor: Colors.redAccent,
        actions: [
          if (homePageProvider.getRemovedSongs().isNotEmpty)
            IconButton(
              icon: const Icon(Icons.restore),
              onPressed: () {
                DialogueUtils.getDialogue(context, 'srestore', arguments: [
                  () {
                    homePageProvider.restoreAllSongs();
                    Navigator.pop(context); // Close the dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All songs restored!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                ]);
              },
            ),
        ],
      ),
      body: homePageProvider.getRemovedSongs().isNotEmpty
          ? ListView.builder(
              itemCount: homePageProvider.getRemovedSongs().length,
              itemBuilder: (context, index) {
                SongModel song = homePageProvider.getRemovedSongs()[index];

                return SongDisplay(
                  song: song,
                  songs: homePageProvider.getRemovedSongs(),
                  isTrailingChange: true,
                  index: index,
                  trailing: IconButton(
                      onPressed: () {
                        homePageProvider.restoreSong(song);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Song restored: ${song.displayNameWOExt}'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.restore_from_trash_outlined)),
                );
              },
            )
          : const Center(
              child: Text(
                'No removed songs found!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
    );
  }
}
