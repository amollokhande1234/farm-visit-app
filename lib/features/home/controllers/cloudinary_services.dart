import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class CloudinaryService {
  final String cloudName = "doldqo1ot";
  final String uploadPreset = "ktjqccyw";

  Future<String> uploadImage(File imageFile) async {
    try {
      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
      );

      var request = http.MultipartRequest('POST', url);
      request.fields['upload_preset'] = uploadPreset;
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      var response = await request.send();
      var resBody = await response.stream.bytesToString();

      var data = json.decode(resBody);

      if (data['secure_url'] != null && data['secure_url'].isNotEmpty) {
        return data['secure_url'];
      } else {
        debugPrint(' Cloudinary upload failed: ${data['error'] ?? data}');
        throw Exception("Cloudinary upload failed");
      }
    } catch (e) {
      debugPrint(' Cloudinary Exception ::> ${e.toString()}');
      throw Exception(e);
    }
  }
}
