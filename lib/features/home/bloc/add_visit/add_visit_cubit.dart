import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:feild_visit_app/consts/hive_new_visit_model.dart';
import 'package:feild_visit_app/consts/hive_storage.dart';
import 'package:feild_visit_app/features/home/bloc/add_visit/add_visit_state.dart';
import 'package:feild_visit_app/features/home/controllers/firebase_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/local_image_storage.dart';

class AddVisitCubit extends Cubit<AddVisitState> {
  AddVisitCubit() : super(AddVisitInitial());

  final Connectivity _connectivity = Connectivity();
  final visitBox = HiveStorage.visitBox;

  // Data form the firebase;
  Future<void> addVisit(VisitModel visit, File image) async {
    emit(AddVisitLoading());
    final result = await _connectivity.checkConnectivity();

    try {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        /// INTERNET AVAILABLE → Upload to Firebase
        var data = await FirebaseService().uploadVisit(visit, image);

        emit(AddVisitLoaded(data: data));
      } else {
        String imagePath = await ImageStorageHelper.saveImageLocally(image);

        visit.imagePath = imagePath;
        visit.isSynced = false;
        HiveStorage.addVisit(visit);
        final visits = HiveStorage.getAllVisits();

        for (var visit in visits) {
          debugPrint(visit.toJson().toString());
        }

        emit(AddVisitLoaded(data: visit));
      }
    } catch (e) {
      debugPrint(' ${e.toString()}');
      emit(AddVisitFailure(message: e.toString()));
    }
  }
}
