// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../Drink.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DrinkAdapter extends TypeAdapter<Drink> {
  @override
  final int typeId = 1;

  @override
  Drink read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Drink(
      name: fields[0] as String,
      price: fields[1] as double,
      amount: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Drink obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.price)
      ..writeByte(2)
      ..write(obj.amount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DrinkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
