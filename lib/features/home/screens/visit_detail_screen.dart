import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../consts/hive_new_visit_model.dart';

class VisitDetailScreen extends StatelessWidget {
  final VisitModel visit;

  const VisitDetailScreen({super.key, required this.visit});

  Widget infoContainer(String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Visit Detail',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: visit.imagePath != null
                  ? (visit.isSynced
                        ? Image.network(
                            visit.imagePath!,
                            width: double.infinity,
                            height: 220,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: double.infinity,
                                height: 220,
                                color: Colors.grey.shade300,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          )
                        : Image.file(
                            File(visit.imagePath!),
                            width: double.infinity,
                            height: 220,
                            fit: BoxFit.cover,
                          ))
                  : Container(
                      width: double.infinity,
                      height: 220,
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
            ),
            const SizedBox(height: 20),

            // Info Containers
            infoContainer('Farmer Name', visit.farmerName),
            infoContainer('Village', visit.villageName),
            infoContainer('Crop Type', visit.cropType),
            infoContainer('Notes', visit.note ?? 'No notes'),
            infoContainer(
              'Visit Date',
              DateFormat('dd MMM yyyy, HH:mm').format(visit.time),
            ),
            infoContainer(
              'Latitude',
              visit.latitude?.toString() ?? 'Not available',
            ),
            infoContainer(
              'Longitude',
              visit.longitude?.toString() ?? 'Not available',
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 6)],
        ),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                visit.isSynced ? Icons.check_circle : Icons.pending,
                color: visit.isSynced ? Colors.green : Colors.orange,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                visit.isSynced ? 'Synced' : 'Pending',
                style: TextStyle(
                  color: visit.isSynced ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
