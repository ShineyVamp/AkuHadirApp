import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickImageFile({
    ImageSource source = ImageSource.gallery,
  }) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (file == null) return null;
      return File(file.path);
    } catch (_) {
      return null;
    }
  }

  static Future<String?> pickImageAsBase64({
    ImageSource source = ImageSource.gallery,
  }) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (file == null) return null;
      final bytes = await file.readAsBytes();
      final ext = file.name.split('.').last.toLowerCase();
      final mime = (ext == 'jpg' || ext == 'jpeg') ? 'jpeg' : 'png';
      return 'data:image/$mime;base64,${base64Encode(bytes)}';
    } catch (_) {
      return null;
    }
  }
}
