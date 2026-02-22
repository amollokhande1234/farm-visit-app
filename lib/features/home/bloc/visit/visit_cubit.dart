import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:feild_visit_app/features/home/bloc/visit/visit_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../consts/hive_new_visit_model.dart';
import '../../../../consts/hive_storage.dart';
import '../../controllers/firebase_services.dart';

class VisitCubit extends Cubit<VisitState> {
  VisitCubit() : super(VisitInitial());

  Future<List<VisitModel>> fetchAllVisits() async {
    emit(VisitLoading());

    try {
      // 1️⃣ Get local visits from Hive
      List<VisitModel> localVisits = HiveStorage.getAllVisits();

      // 2️⃣ Check connectivity
      final connectivity = await Connectivity().checkConnectivity();

      // 3️⃣ If internet is on, sync local visits first
      if (connectivity == ConnectivityResult.mobile ||
          connectivity == ConnectivityResult.wifi) {
        HiveStorage.clearAll();
        for (var localVisit in localVisits.where((v) => !v.isSynced)) {
          try {
            // Upload to Firebase
            await FirebaseService().uploadVisit(
              localVisit,
              File(localVisit.imagePath!),
            );

            // After successful upload, mark as synced
            localVisit.isSynced = true;

            // Remove from local Hive
            int index = HiveStorage.getAllVisits().indexOf(localVisit);
            await HiveStorage.deleteVisit(index);
          } catch (e) {
            debugPrint("Failed to sync visit ${localVisit.farmerName}: $e");
          }
        }

        // After syncing, fetch latest Firebase visits
        List<VisitModel> firebaseVisits = await FirebaseService().fetchVisits();
        // Optional: save Firebase visits locally if needed
        for (var fbVisit in firebaseVisits) {
          bool exists = HiveStorage.getAllVisits().any(
            (local) =>
                local.farmerName == fbVisit.farmerName &&
                local.time == fbVisit.time,
          ); // or use unique ID
          if (!exists) {
            await HiveStorage.addVisit(fbVisit);
          }
        }

        // Reload local visits after sync
        localVisits = HiveStorage.getAllVisits();
      }

      // 4️⃣ Emit final visits list (local + synced Firebase)
      localVisits.sort((a, b) => b.time.compareTo(a.time));
      emit(VisitLoaded(visits: localVisits));

      return localVisits;
    } catch (e) {
      emit(VisitFailure(message: e.toString()));
      throw Exception(e);
    }
  }
}
