import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CustomImagePicker {
  static Future<String> pickImageFromCameraAndReturnUrl({String? fileName}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? imagePicked = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );

      if (imagePicked != null) {
        final File imageFile = File(imagePicked.path);
        if (await imageFile.exists()) {
          return imageFile.path;
        } else {
          throw Exception("Gambar tidak ditemukan di path: ${imagePicked.path}");
        }
      } else {
        throw Exception("Pengambilan gambar dibatalkan oleh pengguna.");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan saat mengambil gambar: $e");
    }
  }
}
