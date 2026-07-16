// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_steps_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyStepsModelAdapter extends TypeAdapter<DailyStepsModel> {
  @override
  final typeId = 0;

  @override
  DailyStepsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyStepsModel(
      date: fields[0] as DateTime,
      steps: (fields[1] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, DailyStepsModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.steps);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyStepsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
