// import 'package:music_player/DATABASE/most_played.dart';
// import 'package:music_player/DATABASE/recently_played.dart';
// import 'package:on_audio_query/on_audio_query.dart';

// class SongSuggestor {
//   static List<SongModel> suggestSongs() {
//     List<SongModel> suggestedSongs = [];

//     // Get most played songs
//     List<SongModel> mostPlayedSongs = MostlyPlayedDB.mostlyPlayedSongNotifier.value;

//     // Get recently played songs
//     // List<SongModel> recentlyPlayedSongs = RecentDb.recentlyplayedSongNotifier.value;

//     // Combine and deduplicate the lists
//     List<SongModel> allPlayedSongs = [...mostPlayedSongs, ...recentlyPlayedSongs];
//     allPlayedSongs = allPlayedSongs.toSet().toList();

//     // Implement logic to prioritize songs from the same artist or genre
//     SongModel? lastPlayedSong = allPlayedSongs.isNotEmpty ? allPlayedSongs.last : null;

//     if (lastPlayedSong != null) {
//       // Suggest songs from the same artist
//       suggestedSongs.addAll(
//         allPlayedSongs.where((song) => song.artist == lastPlayedSong.artist).take(2),
//       );
//  suggestedSongs.addAll(
//         allPlayedSongs.where((song) => song.album == lastPlayedSong.album).take(2),
//       );
//        suggestedSongs.addAll(
//         allPlayedSongs.where((song) => song.track == lastPlayedSong.track).take(2),
//       );
//       // Suggest songs from the same genre
//       suggestedSongs.addAll(
//         allPlayedSongs.where((song) => song.genre == lastPlayedSong.genre).take(2),
//       );
//     }

//     // Shuffle the list of suggested songs
//     suggestedSongs.shuffle();

//     // Take a random subset of songs (e.g., first 5)
//     suggestedSongs = suggestedSongs.take(5).toList();

//     return suggestedSongs;
//   }
// }
