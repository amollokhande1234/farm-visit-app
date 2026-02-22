import 'package:hive_flutter/hive_flutter.dart';
import 'hive_new_visit_model.dart';

class HiveStorage {
  static const String visitBox = "visits";

  /// Initialize Hive
  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(VisitModelAdapter());

    await Hive.openBox<VisitModel>(visitBox);
  }

  /// Get Visit Box
  static Box<VisitModel> get getVisitBox => Hive.box<VisitModel>(visitBox);

  /// Add Visit
  static Future<void> addVisit(VisitModel visit) async {
    await getVisitBox.add(visit);
  }

  /// Get All Visits
  static List<VisitModel> getAllVisits() {
    return getVisitBox.values.toList();
  }

  /// Delete Visit
  static Future<void> deleteVisit(int index) async {
    await getVisitBox.deleteAt(index);
  }

  /// Clear All Data
  static Future<void> clearAll() async {
    await getVisitBox.clear();
  }
}
