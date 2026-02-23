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
      List<VisitModel> localVisits = HiveStorage.getAllVisits();

      final connectivity = await Connectivity().checkConnectivity();

      if (connectivity == ConnectivityResult.mobile ||
          connectivity == ConnectivityResult.wifi) {
        HiveStorage.clearAll();
        for (var localVisit in localVisits.where((v) => !v.isSynced)) {
          try {
            localVisit.isSynced = true;
            await FirebaseService().uploadVisit(
              localVisit,
              File(localVisit.imagePath!),
            );

            localVisit.isSynced = true;

            int index = HiveStorage.getAllVisits().indexOf(localVisit);
            await HiveStorage.deleteVisit(index);
          } catch (e) {
            debugPrint("Failed to sync visit ${localVisit.farmerName}: $e");
          }
        }

        List<VisitModel> firebaseVisits = await FirebaseService().fetchVisits();

        for (var fbVisit in firebaseVisits) {
          bool exists = HiveStorage.getAllVisits().any(
            (local) =>
                local.farmerName == fbVisit.farmerName &&
                local.time == fbVisit.time,
          );
          if (!exists) {
            await HiveStorage.addVisit(fbVisit);
          }
        }

        localVisits = HiveStorage.getAllVisits();
      }

      localVisits.sort((a, b) => b.time.compareTo(a.time));
      emit(VisitLoaded(visits: localVisits));

      return localVisits;
    } catch (e) {
      emit(VisitFailure(message: e.toString()));
      throw Exception(e);
    }
  }
}
