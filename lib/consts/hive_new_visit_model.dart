import 'package:hive/hive.dart';

part 'hive_new_visit_model.g.dart';

@HiveType(typeId: 0)
class VisitModel extends HiveObject {
  @HiveField(0)
  String farmerName;

  @HiveField(1)
  String villageName;

  @HiveField(2)
  String? note;

  @HiveField(3)
  String? imagePath;

  @HiveField(4)
  bool isSynced;

  @HiveField(5)
  DateTime time;

  @HiveField(6)
  String cropType;

  @HiveField(7)
  double? latitude;

  @HiveField(8)
  double? longitude;

  VisitModel({
    required this.farmerName,
    required this.villageName,
    required this.cropType,
    this.note,
    this.imagePath,
    this.latitude,
    this.longitude,
    this.isSynced = false,
    required this.time,
  });

  /// Convert to Firebase Map
  Map<String, dynamic> toJson() {
    return {
      'farmerName': farmerName,
      'villageName': villageName,
      'note': note,
      'latitude': latitude,
      'longitude': longitude,
      'imagePath': imagePath,
      'cropType': cropType,
      'isSynced': isSynced,
      'time': time.toIso8601String(),
    };
  }

  /// Create from Firebase Map
  factory VisitModel.fromJson(Map<String, dynamic> json) {
    return VisitModel(
      farmerName: json['farmerName'],
      villageName: json['villageName'],
      note: json['note'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      imagePath: json['imagePath'],
      isSynced: json['isSynced'] ?? false,
      cropType: json['cropType'],
      time: DateTime.parse(json['time']),
    );
  }
}
