import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feild_visit_app/consts/hive_new_visit_model.dart';
import 'package:flutter/cupertino.dart';

import 'package:uuid/uuid.dart';

import 'cloudinary_services.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = "visits";

  Future<VisitModel> uploadVisit(VisitModel visitModel, File image) async {
    try {
      final id = const Uuid().v4();

      final imageUrl = await CloudinaryService().uploadImage(image);

      visitModel.imagePath = imageUrl;
      visitModel.isSynced = true;

      await _firestore
          .collection(collectionName)
          .doc(id)
          .set(visitModel.toJson());

      return visitModel;
    } catch (e) {
      debugPrint(' Firebase Exception  ${e.toString()}');
      throw Exception(e);
    }
  }

  Future<List<VisitModel>> fetchVisits() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(collectionName)
          .orderBy('time', descending: true)
          .get();

      List<VisitModel> visits = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Add doc id
        data['id'] = doc.id;
        return VisitModel.fromJson(data);
      }).toList();

      return visits;
    } catch (e) {
      throw Exception('Failed to fetch visits from Firebase: $e');
    }
  }
}
