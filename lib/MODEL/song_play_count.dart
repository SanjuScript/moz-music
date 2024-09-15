import 'package:hive/hive.dart';

part 'song_play_count.g.dart';

@HiveType(typeId: 0)
class SongPlayCount extends HiveObject {
  @HiveField(0)
  final String songId;

  @HiveField(1)
  int playCount;

  SongPlayCount({required this.songId, this.playCount = 0});
}
