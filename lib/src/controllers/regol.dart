import 'package:get/get.dart';
import 'package:tridentpro/src/models/databases/account.dart';
import 'package:tridentpro/src/models/trades/product_models.dart';
import 'package:tridentpro/src/service/auth_service.dart';
import 'package:tridentpro/src/service/database_service.dart';

class RegolController extends GetxController {
  AuthService authService = Get.find();
  RxString responseMessage = "".obs;
  RxBool isLoading = false.obs;
  Rxn<ProductModels> productModels = Rxn<ProductModels>();
  DatabaseService databaseService = DatabaseService.instance;
  Rxn<AccountModel> accountModel = Rxn<AccountModel>();

  // Create Demo Trading API
  Future<bool> getProducts() async {
    try {
      Map<String, dynamic> result = await authService.get("regol/product");
      if (result['statusCode'] != 200) {
        return false;
      }

      // print(result);
      productModels(ProductModels.fromJson(result));
      responseMessage(result['message']);
      return true;
    } catch (e) {
      responseMessage(e.toString());
      return false;
    }
  }

  Future<bool> progressAccount() async {
    try {
      /** Fetch data from api */
      Map<String, dynamic> result = await authService.get("regol/progressAccount");
      if(result['status'] != true) {
        return false;
      }

      /** Convert response api to accountModel */
      AccountModel account = AccountModel.fromJson(result['response']);

      /** Insert account to database update on duplicate key */
      await databaseService.insertAccount(account.toJson());
    
      /** Assign response api to AccountModel value */
      accountModel(account);

      return true;
    
    } catch (e) {
      responseMessage("progressAccount error: $e");
      throw Exception("progressAccount error: $e");
    }
  }

  // Create Demo Trading API
  Future<bool> postStepZero({String? accountType, String? accountSuffix}) async {
    try {
      isLoading(true);
      Map<String, dynamic> result = await authService.post("regol/accountType", {
        'account-type' : accountSuffix
      });

      isLoading(false);
      if (result['statusCode'] != 200) {
        return false;
      }

      /** Assign new value to Database */
      responseMessage(result['message']);
      accountModel.value?.type = accountType;
      accountModel.value?.typeAcc = accountSuffix;
      
      return true;
    } catch (e) {
      isLoading(false);
      responseMessage(e.toString());
      return false;
    }
  }


  Future<bool> postStepOne({String? appFotoTerbaru, String? appFotoIdentitas, required String country, required String idType, required String idTypeNumber}) async {
    try {
      isLoading(true);
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
      isLoading(false);
      return true;
      
    } catch (e) {
      isLoading(false);
      responseMessage(e.toString());
      return false;
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

  // Create Demo Trading API
  Future<bool> postStepFour({String? emergencyName, String? emergencyRelation, String? emergencyContact, String? emergencyAddress, String? postalCode}) async {
    try {
      isLoading(true);
      Map<String, dynamic> result = await authService.post("regol/apr_pihak_darurat", {
        'app_darurat_nama': emergencyName,
        'app_darurat_hubungan': emergencyRelation,
        'app_darurat_telepon': emergencyContact,
        'app_darurat_alamat': emergencyAddress,
        'app_darurat_kodepos': postalCode
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
  Future<bool> postStepFive({String? investmentGoal}) async {
    try {
      isLoading(true);
      Map<String, dynamic> result = await authService.post("regol/apr_tujuan_investasi", {
        'app_tujuan_investasi': investmentGoal
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
  Future<bool> postStepSix({String? experience, String? companyName}) async {
    try {
      isLoading(true);
      Map<String, dynamic> result = await authService.post("regol/apr_pengalaman_investasi", {
        'app_pengalaman_investasi': experience,
        'nama_perusahaan': companyName ?? "-"
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
  Future<bool> postStepSeven({String? experience}) async {
    try {
      isLoading(true);
      Map<String, dynamic> result = await authService.post("regol/apr_pengalaman_investasi", {
        'app_pengalaman_investasi': experience,
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
  Future<bool> postStepEight({
    String? jobName,
    String? companyName,
    String? bidangUsaha,
    String? position,
    String? longTime,
    String? address,
    String? longTimeOldJob
  }) async {
    try {
      isLoading(true);
      Map<String, dynamic> result = await authService.post("regol/apr_informasi_pekerjaan", {
        'nama_pekerjaan': jobName,
        'nama_perusahaan': companyName,
        'bidang_usaha': bidangUsaha,
        'jabatan_pekerjaan': position,
        'lama_bekerja': '${longTime ?? 0} tahun',
        'alamat_kantor': address,
        'lama_bekerja_sebelumnya': '${longTimeOldJob ?? 0} tahun'
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