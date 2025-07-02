import 'package:get/get.dart';
import 'package:tridentpro/src/service/auth_service.dart';

class CompanyController extends GetxController {
  RxBool isLoading = false.obs;
  RxString responseMessage = "".obs;
  AuthService authService = AuthService();

  Future<bool> profilePerusahaan({String? acc}) async {
    isLoading(true);
    try {
      Map<String, dynamic> response = await authService.getCustomURL("https://cabinet-tridentprofutures.techcrm.net/export/profile-perusahaan?acc=$acc");
      print(response);
      isLoading(false);
      responseMessage(response['message']);
      if(response['status'] != true) {
        return false;
      }
      return true;
    } catch (e) {
      isLoading(false);
      return false;
    }
  }

  Future<bool> pernyataanSimulasi({String? acc}) async {
    isLoading(true);
    try {
      Map<String, dynamic> response = await authService.getCustomURL("https://cabinet-tridentprofutures.techcrm.net/export/pernyataan-simulasi?acc=$acc");
      print(response);
      isLoading(false);
      responseMessage(response['message']);
      if(response['status'] != true) {
        return false;
      }
      return true;
    } catch (e) {
      isLoading(false);
      return false;
    }
  }

  Future<bool> pernyataanPengalaman({String? acc}) async {
    isLoading(true);
    try {
      Map<String, dynamic> response = await authService.getCustomURL("https://cabinet-tridentprofutures.techcrm.net/export/pernyataan-pengalaman?acc=$acc");
      print(response);
      isLoading(false);
      responseMessage(response['message']);
      if(response['status'] != true) {
        return false;
      }
      return true;
    } catch (e) {
      isLoading(false);
      return false;
    }
  }
}