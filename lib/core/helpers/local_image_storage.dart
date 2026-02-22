import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import 'dart:io';

class ImageStorageHelper {
  static Future<String> saveImageLocally(File imge) async {
    final directory = await getApplicationDocumentsDirectory();
    final String fileName =
        "${DateTime.now().millisecondsSinceEpoch}${path.extension(imge.path)}";

    final File localImage = await imge.copy('${directory.path}/$fileName');
    return localImage.path;
  }
}
