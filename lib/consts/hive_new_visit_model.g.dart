// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_new_visit_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VisitModelAdapter extends TypeAdapter<VisitModel> {
  @override
  final int typeId = 0;

  @override
  VisitModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VisitModel(
      farmerName: fields[0] as String,
      villageName: fields[1] as String,
      cropType: fields[6] as String,
      note: fields[2] as String?,
      imagePath: fields[3] as String?,
      latitude: fields[7] as double?,
      longitude: fields[8] as double?,
      isSynced: fields[4] as bool,
      time: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, VisitModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.farmerName)
      ..writeByte(1)
      ..write(obj.villageName)
      ..writeByte(2)
      ..write(obj.note)
      ..writeByte(3)
      ..write(obj.imagePath)
      ..writeByte(4)
      ..write(obj.isSynced)
      ..writeByte(5)
      ..write(obj.time)
      ..writeByte(6)
      ..write(obj.cropType)
      ..writeByte(7)
      ..write(obj.latitude)
      ..writeByte(8)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisitModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
