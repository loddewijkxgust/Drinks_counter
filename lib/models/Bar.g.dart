// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Bar.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BarAdapter extends TypeAdapter<Bar> {
  @override
  final int typeId = 2;

  @override
  Bar read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bar(
      name: fields[0] as String,
      menu: (fields[1] as List).cast<Drink>(),
    )..history = (fields[2] as Map).map((dynamic k, dynamic v) =>
        MapEntry(k as DateTime, (v as List).cast<Drink>()));
  }

  @override
  void write(BinaryWriter writer, Bar obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.menu)
      ..writeByte(2)
      ..write(obj.history);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BarAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
