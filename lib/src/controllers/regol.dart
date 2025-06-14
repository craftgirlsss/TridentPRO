import 'package:get/get.dart';
import 'package:tridentpro/src/models/databases/account.dart';
import 'package:tridentpro/src/models/trades/product_models.dart';
import 'package:tridentpro/src/service/auth_service.dart';

class RegolController extends GetxController {
  AuthService authService = Get.find();
  RxString responseMessage = "".obs;
  RxBool isLoading = false.obs;
  Rxn<ProductModels> productModels = Rxn<ProductModels>();
  // DatabaseService databaseService = DatabaseService.instance;
  Rxn<AccountModel> accountModel = Rxn<AccountModel>();

  // Create Demo Trading API
  Future<bool> getProducts() async {
    try {
      Map<String, dynamic> result = await authService.get("regol/product");
      responseMessage(result['message']);
      print("INI RESULT GET PRODUCT REGOL $result");
      // print(result);
      productModels(ProductModels.fromJson(result));
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
      print("INI RESULT GET PROGRESS REGOL $result");
      responseMessage(result['message']);

      if(result['status'] != true) {
        return false;
      }

      /** Convert response api to accountModel */
      AccountModel account = AccountModel.fromJson(result['response']);

      // /** Insert account to database update on duplicate key */
      // await databaseService.insertAccount(account.toJson());
    
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
      print("INI RESULT POST STEP ZERO $result");

      isLoading(false);
      responseMessage(result['message']);
      if (result['status'] != true) {
        return false;
      }

      /** Assign new value to Database */
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

      Map<String, dynamic> result = await authService.multipart("regol/verifikasiIdentitas", body, file);
      isLoading(false);
      responseMessage(result['message']);
      if(result['status'] != true) {
        return false;
      }

      accountModel.value?.idType = idType;
      accountModel.value?.idNumber = idTypeNumber;
      accountModel.value?.country = country;

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
      responseMessage(result['message']);
      if (result['status'] != true) {
        return false;
      }
      print(result);
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

      print(result);

      isLoading(false);
      responseMessage(result['message']);
      if (result['status'] != true) {
        return false;
      }
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
      responseMessage(result['message']);
      if (result['status'] != true) {
        return false;
      }
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
      responseMessage(result['message']);
      if (result['status'] != true) {
        return false;
      }
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
        'app_nama_perusahaan': companyName
      });

      isLoading(false);
      print(result);
      responseMessage(result['message']);
      if (result['status'] != true) {
        return false;
      }
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
      responseMessage(result['message']);
      if (result['status'] != true) {
        return false;
      }
      return true;
    } catch (e) {
      isLoading(false);
      responseMessage(e.toString());
      return false;
    }
  }

  // Create Demo Trading API
  Future<bool> postStepEight({
    String? namaPekerjaan,
    String? namaPerusahaan,
    String? bidangUsaha,
    String? jabatanPekerjaan,
    String? lamaBekerja,
    String? alamatKantor,
    String? lamaBekerjaSebelumnya
  }) async {
    try {
      isLoading(true);
      Map<String, dynamic> result = await authService.post("regol/apr_informasi_pekerjaan", {
        'nama_pekerjaan': namaPekerjaan,
        'nama_perusahaan': namaPerusahaan,
        'bidang_usaha': bidangUsaha,
        'jabatan_pekerjaan': jabatanPekerjaan,
        'lama_bekerja': '${lamaBekerja ?? 0} tahun',
        'alamat_kantor': alamatKantor,
        'lama_bekerja_sebelumnya': '${lamaBekerjaSebelumnya ?? 0} tahun'
      });

      isLoading(false);
      print(result);
      responseMessage(result['message']);
      if (result['status'] != true) {
        return false;
      }
      return true;
    } catch (e) {
      isLoading(false);
      responseMessage(e.toString());
      return false;
    }
  }


  Future<bool> postStepNinePernyataanSimulasi({
    String? appProvince,
    String? appCity,
    String? appDistrict,
    String? appVillage,
    String? appZipcode,
    String? appRT,
    String? appRW,
    String? appAddress,
    String? appAgree,
    String? urlPhoto
    }) async {
    try {
      Map<String, String> file = {};
      isLoading(true);
      Map<String, String> body = {
        'app_province': appProvince!,
        'app_city': appCity!,
        'app_district': appDistrict!,
        'app_village': appVillage!,
        'app_zipcode': appZipcode!,
        'app_rt': appRT!,
        'app_rw': appRW!,
        'app_address': appAddress!,
        'app_agree': appAgree!,
      };

      if(urlPhoto != null) {
        file['app_demofile'] = urlPhoto;
      }


      var result = await authService.multipart("regol/pernyataan_simulasi", body, file);
      isLoading(false);
      responseMessage(result['message']);
      if(result['status'] == false){
        return false;
      }
      print(result);
      return true;

    } catch (e) {
      isLoading(false);
      responseMessage(e.toString());
      return false;
    }
  }


  // Pernataan Pailit
  Future<bool> postPernytaanPailit({
    String? keluargaBappebti,
    String? pailit
  }) async {
    try {
      isLoading(true);
      Map<String, dynamic> result = await authService.post("regol/apr_keterangan_pailit", {
        'app_keterangan_pailit': pailit,
        'app_keluarga_bursa': keluargaBappebti
      });

      isLoading(false);
      print(result);
      responseMessage(result['message']);
      if (result['status'] != true) {
        return false;
      }
      return true;
    } catch (e) {
      isLoading(false);
      responseMessage(e.toString());
      return false;
    }
  }

  // Pernataan Pailit
  Future<bool> postKekayaan({
    String? annualIncome,
    String? lokasiRumah,
    String? njop,
    String? deposito,
    String? lainnya
  }) async {
    try {
      isLoading(true);
      Map<String, dynamic> result = await authService.post("regol/apr_daftar_kekayaan", {
        'annual_income': annualIncome,
        'lokasi_rumah': lokasiRumah,
        'njop': njop,
        'deposito': deposito,
        'lainnya': lainnya
      });

      isLoading(false);
      print(result);
      responseMessage(result['message']);
      if (result['status'] != true) {
        return false;
      }
      return true;
    } catch (e) {
      isLoading(false);
      responseMessage(e.toString());
      return false;
    }
  }

  Future<bool> stepDokumenPendukung({String? dokumenPendukung1, String? dokumenPendukung2, String? jenisDokumen}) async {
    print("Fungsi dokumen pendukung dijalankan");
    try {
      Map<String, String> file = {};
      isLoading(true);
      Map<String, String> body = {'tipe': jenisDokumen!};

      if(dokumenPendukung1 != null) {
        file['dokumen'] = dokumenPendukung1;
      }

      if(dokumenPendukung2 != null) {
        file['dokumen_lainnya'] = dokumenPendukung2;
      }

      var result = await authService.multipart("regol/apr_dokumen_pendukung", body, file);
      isLoading(false);
      print(result);
      responseMessage(result['message']);
      if(result['status'] == false){
        return false;
      }
      print(result);
      return true;

    } catch (e) {
      isLoading(false);
      responseMessage(e.toString());
      return false;
    }
  }
}