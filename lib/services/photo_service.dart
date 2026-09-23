import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class PhotoService {
  final _picker = ImagePicker();
  late final Directory _photosDir;

  Future<void> init() async {
    final docs = await getApplicationDocumentsDirectory();
    _photosDir = Directory('${docs.path}/photos');
    await _photosDir.create(recursive: true);
  }

  File fileFor(String fileName) => File('${_photosDir.path}/$fileName');

  Future<String?> takePhoto() async {
    final XFile? shot;
    try {
      shot = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1600,
        imageQuality: 80,
      );
    } on PlatformException {
      return null;
    }
    if (shot == null) return null;

    final fileName = 'car_${DateTime.now().millisecondsSinceEpoch}.jpg';
    await File(shot.path).copy(fileFor(fileName).path);
    return fileName;
  }

  Future<void> delete(String fileName) async {
    final file = fileFor(fileName);
    if (await file.exists()) await file.delete();
  }
}
