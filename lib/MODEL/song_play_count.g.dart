// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_play_count.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongPlayCountAdapter extends TypeAdapter<SongPlayCount> {
  @override
  final int typeId = 0;

  @override
  SongPlayCount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SongPlayCount(
      songId: fields[0] as String,
    )..playCount = fields[1] as int;
  }

  @override
  void write(BinaryWriter writer, SongPlayCount obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.songId)
      ..writeByte(1)
      ..write(obj.playCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongPlayCountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
