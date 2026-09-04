import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<String?> pickImageAsBase64({ImageSource source = ImageSource.gallery}) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (file == null) return null;

      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);
      return 'data:image/png;base64,$base64String';
    } catch (_) {
      return null;
    }
  }
}
