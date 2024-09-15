import 'dart:developer';
import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/DATABASE/most_played.dart';
import 'package:music_player/DATABASE/recently_played.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';

class MozController {
  static AudioPlayer player = AudioPlayer();
  static int currentIndex =
      -1; // Initialize to -1 to indicate no song has played yet
  static List<SongModel> songscopy = [];
  static List<SongModel> playingSongs = [];

  static Future<ConcatenatingAudioSource> createSongList(List<SongModel> songs)async {
    List<AudioSource> sources = [];
    playingSongs = songs;
    for (var song in songs) {
      if (song.uri != null) {
        //   Uri? artUri;

        // // Fetch the artwork URI directly
        // try {
        //   Uint8List? artworkBytes = await ArtworkCache.fetchArtwork(song.id);
        //   if (artworkBytes != null) {
        //     artUri = Uri.dataFromBytes(artworkBytes, mimeType: 'image/jpeg');
        //   }
        // } catch (e) {
        //   // Handle error if artwork fetching fails
        //   print('Error loading artUri: $e');
        // }
        sources.add(AudioSource.uri(
          Uri.parse(song.uri!),
          tag: MediaItem(
            id: song.id.toString(),
            duration: Duration(milliseconds: song.duration!),
            title: song.title ?? '', // Use an empty string if title is null
            album: song.album ?? '', // Use an empty string if album is null
            artist: song.artist ?? '', // Use an empty string if artist is null
            // artUri:artUri
            // artUri: Uri.parse(song.uri ?? ''),
          ),
        ));
      }
    }

    ConcatenatingAudioSource audioSource =
        ConcatenatingAudioSource(children: sources);

    player.currentIndexStream.listen((index) async {
      if (index != null && index >= 0 && index < playingSongs.length) {
        currentIndex = index;
        if (playingSongs[currentIndex].uri != null) {
          await RecentDb.add(playingSongs[currentIndex]);

          Future.delayed(const Duration(milliseconds: 500), () async {
            PlayCountService.addOrUpdatePlayCount(
                playingSongs[currentIndex].id.toString());
          });
        }
      }
    });

    return audioSource;
  }
  static Future<Uri> _fetchAndSaveArtwork(int songId) async {
    Uint8List? artworkBytes = await ArtworkCache.fetchArtwork(songId);
    if (artworkBytes != null) {
      Directory tempDir = await getTemporaryDirectory();
      File tempFile = File('${tempDir.path}/$songId.jpg');
      await tempFile.writeAsBytes(artworkBytes);
      return Uri.file(tempFile.path);
    } else {
      throw Exception('Artwork not found');
    }
  }
}

class ArtworkCache {
  static Future<Uint8List?> fetchArtwork(int songId) async {
    Uint8List? artworkBytes;
    artworkBytes = await OnAudioQuery().queryArtwork(
      songId,
      ArtworkType.AUDIO,
      format: ArtworkFormat.JPEG,
      size: 500,
      quality: 100,
    );
    return artworkBytes;
  }
}