import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class VisitCard extends StatelessWidget {
  final String farmerName;
  final String village;
  final String cropType;
  final DateTime visitDate;
  final String photoUrl;
  final bool isSynced;
  final Position? location;

  const VisitCard({
    super.key,
    required this.farmerName,
    required this.village,
    required this.cropType,
    required this.visitDate,
    required this.photoUrl,
    required this.isSynced,
    this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [BoxShadow(color: Colors.grey.shade200)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Visit Photo Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: photoUrl.isNotEmpty
                ? photoUrl.isNotEmpty && File(photoUrl).existsSync()
                      ? Image.file(
                          File(photoUrl),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Text('Image Not Found');
                          },
                        )
                      : Image.network(
                          photoUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // If image fails to load from network
                            return Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                              ),
                            );
                          },
                        )
                : Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Farmer: $farmerName',
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Village: $village',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  'Crop: $cropType',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text(
                  'Visited: ${DateFormat('dd MMM yy  HH:mm').format(visitDate)}',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 6),
                // Sync Status
                Row(
                  children: [
                    Icon(
                      isSynced ? Icons.check_circle : Icons.pending,
                      color: isSynced ? Colors.green : Colors.orange,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isSynced ? 'Synced' : 'Pending',
                      style: TextStyle(
                        color: isSynced ? Colors.green : Colors.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
