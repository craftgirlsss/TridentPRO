import 'package:get/get.dart';
import 'package:tridentpro/src/models/trades/product_models.dart';
import 'package:tridentpro/src/service/auth_service.dart';

class RegolController extends GetxController {
  AuthService authService = Get.find();
  RxString responseMessage = "".obs;
  RxBool isLoading = false.obs;
  Rxn<ProductModels> productModels = Rxn<ProductModels>();

  // Create Demo Trading API
  Future<bool> getProducts() async {
    try {
      isLoading(true);
      Map<String, dynamic> result = await authService.get("regol/product");
      isLoading(false);
      if (result['statusCode'] != 200) {
        return false;
      }
      productModels(ProductModels.fromJson(result['response']));
      responseMessage(result['message']);
      return true;
    } catch (e) {
      isLoading(false);
      responseMessage(e.toString());
      return false;
    }
  }

  // Create Demo Trading API
  Future<bool> postStepZero({String? accountType}) async {
    try {
      isLoading(true);
      Map<String, dynamic> result = await authService.post("regol/accountType", {
        'account-type' : accountType
      });

      isLoading(false);
      if (result['statusCode'] != 200) {
        return false;
      }
      responseMessage(result['message']);
      return true;
    } catch (e) {
      isLoading(false);
      responseMessage(e.toString());
      return false;
    }
  }


  Future<bool> postStepOne({String? appFotoTerbaru, String? appFotoIdentitas, required String country, required String idType, required String idTypeNumber}) async {
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

      await authService.multipart("regol/verifikasiIdentitas", body, file);
      return true;
    } catch (e) {
      rethrow;
    }
  }


  // Create Demo Trading API
  Future<bool> postStepTwo({String? birthPlace, String? dateOfBirth, String? gender, String? taxNumber, String? name, String? phone, String? phoneCode}) async {
    try {
      isLoading(true);
      Map<String, dynamic> result = await authService.post("regol/apr_pengumpulan_data", {
        'app_fullname': name,
        'app_phone_code': phoneCode,
        'app_phone': phone,
        'app_npwp': taxNumber,
        'app_date_of_birth': dateOfBirth,
        'app_place_of_birth': birthPlace,
        'app_gender': gender
      });

      isLoading(false);
      if (result['statusCode'] != 200) {
        return false;
      }
      responseMessage(result['message']);
      return true;
    } catch (e) {
      isLoading(false);
      responseMessage(e.toString());
      return false;
    }
  }

  // Create Demo Trading API
  Future<bool> postStepThree({String? maritalStatus, String? wifeName, String? motherName, String? faxNumber, String? phoneHome}) async {
    try {
      isLoading(true);
      Map<String, dynamic> result = await authService.post("regol/apr_status_perkawinan", {
        'app_status_perkawinan': maritalStatus,
        'app_nama_istri': wifeName,
        'app_nama_ibu': motherName,
        'app_nomor_tlp_rumah': phoneHome,
        'app_nomor_fax': faxNumber
      });

      isLoading(false);
      if (result['statusCode'] != 200) {
        return false;
      }
      responseMessage(result['message']);
      return true;
    } catch (e) {
      isLoading(false);
      responseMessage(e.toString());
      return false;
    }
  }
}