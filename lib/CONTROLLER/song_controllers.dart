import 'dart:developer';

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/DATABASE/most_played.dart';
import 'package:music_player/DATABASE/recently_played.dart';
import 'package:on_audio_query/on_audio_query.dart';

class GetSongs {
  static AudioPlayer player = AudioPlayer();
  static int currentIndex =
      -1; // Initialize to -1 to indicate no song has played yet
  static List<SongModel> songscopy = [];
  static List<SongModel> playingSongs = [];

  static ConcatenatingAudioSource createSongList(List<SongModel> songs) {
    List<AudioSource> sources = [];
    playingSongs = songs;
    for (var song in songs) {
      if (song.uri != null) {
        sources.add(AudioSource.uri(
          Uri.parse(song.uri!),
          tag: MediaItem(
            id: song.id.toString(),
            title: song.title ?? '', // Use an empty string if title is null
            album: song.album ?? '', // Use an empty string if album is null
            artist: song.artist ?? '', // Use an empty string if artist is null
          ),
        ));
      }
    }

    ConcatenatingAudioSource audioSource =
        ConcatenatingAudioSource(children: sources);

    player.currentIndexStream.listen((index) async{
      if (index != null && index >= 0 && index < playingSongs.length) {
        currentIndex = index;
        if (playingSongs[currentIndex].uri != null) {
          // Add the currently playing song to the recently played database
        await RecentlyPlayedDB.addRecentlyPlayed(playingSongs[currentIndex]);
          // NewmosDb.addPlayCount(playingSongs[currentIndex]);
          // MostlyPlayedDB.incrementPlayCount(playingSongs[currentIndex]);
          log('${playingSongs[currentIndex].title} Added Succesfully');
        }
      }
    });

    return audioSource;
  }
}
