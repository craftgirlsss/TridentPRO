import 'package:get/get.dart';
import 'package:tridentpro/src/service/auth_service.dart';

class RegolController extends GetxController {
  AuthService authService = Get.find();

  Future<bool> verifikasiIdentitas({String? appFotoTerbaru, String? appFotoIdentitas, required String country, required String idType, required String idTypeNumber}) async {
    try {
      Map<String, String> body = {
        'country': country,
        'id_type': idType,
        'number': idTypeNumber,
      };

      Map<String, String> file = {};
      if(appFotoTerbaru != null) {
        file['app_foto_terbaru'] = appFotoTerbaru;
      }

      if(appFotoIdentitas != null) {
        file['app_foto_identitas'] = appFotoIdentitas;
      }

      Map<String, dynamic> result = await authService.multipart("regol/verifikasiIdentitas", body, file);

      return true;

    } catch (e) {
      throw e;
    }
  }
}