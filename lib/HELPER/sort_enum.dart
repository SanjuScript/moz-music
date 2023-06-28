import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SortOption {
  adate,
  zdate,
  atitle,
  ztitle,
  aartist,
  zartist,
  aduration,
  zduaration,
  afileSize,
  zfileSize
}

  SortOption defaultSort = SortOption.adate;
  SongSortType getSortType(SortOption sortOption) {
    switch (sortOption) {
      case SortOption.atitle:
        return SongSortType.TITLE;
      case SortOption.aartist:
        return SongSortType.ARTIST;
      case SortOption.aduration:
        return SongSortType.DURATION;
      case SortOption.adate:
        return SongSortType.DATE_ADDED;
      case SortOption.afileSize:
        return SongSortType.SIZE;
      default:
        return SongSortType.DATE_ADDED;
    }
  }
    List<SongModel> sortSongs(List<SongModel> songs, SortOption sortOption) {
    switch (sortOption) {
      case SortOption.atitle:
        songs.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortOption.ztitle:
        songs.sort((a, b) => b.title.compareTo(a.title));
        break;
      case SortOption.aartist:
        songs
            .sort((a, b) => a.artist.toString().compareTo(b.artist.toString()));
        break;
      case SortOption.zartist:
        songs
            .sort((a, b) => b.artist.toString().compareTo(a.artist.toString()));
        break;
      case SortOption.aduration:
        songs.sort((a, b) => a.duration!.compareTo(b.duration!));
        break;
      case SortOption.zduaration:
        songs.sort((a, b) => b.duration!.compareTo(a.duration!));
        break;
      case SortOption.adate:
        songs.sort((a, b) => b.dateAdded!.compareTo(a.dateAdded!));
        break;
      case SortOption.zdate:
        songs.sort((a, b) => a.dateAdded!.compareTo(b.dateAdded!));
        break;
      case SortOption.afileSize:
        songs.sort((a, b) => b.size.compareTo(a.size));
        break;
      case SortOption.zfileSize:
        songs.sort((a, b) => a.size.compareTo(b.size));
        break;
    }
    return songs;
  }
  Future<void> saveSortOption(SortOption value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('sortOption', value.index);
  }

  Future<SortOption> getSortOption() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt('sortOption');
    return SortOption.values[index ?? 0];
  }