import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CustomImagePicker {
  static Future<String> pickImageFromCameraAndReturnUrl({String? fileName}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? imagePicked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
      
      if(imagePicked == null) {
        throw Exception("Pengambilan gambar dibatalkan oleh pengguna.");
      }

      final File imageFile = File(imagePicked.path);
      if (await imageFile.exists() == false) {
        throw Exception("Gambar tidak ditemukan di path: ${imagePicked.path}");
      }

      return imageFile.path;
     
    } catch (e) {
      throw Exception("Terjadi kesalahan saat mengambil gambar: $e");
    }
  }
}
