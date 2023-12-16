import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
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
      sources.add(AudioSource.uri(
        Uri.parse(song.uri!),
        tag: MediaItem(
            id: song.id.toString(),
            title: song.title,
            album: song.album,
            artist: song.artist),
      ));
    }

   

    return ConcatenatingAudioSource(children: sources);
  }
}
