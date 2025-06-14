import 'package:get/get.dart';
import 'package:tridentpro/src/models/auth/pending_model.dart';
import 'package:tridentpro/src/models/auth/profile.dart';
import 'package:tridentpro/src/service/auth_service.dart';

class HomeController extends GetxController {
  AuthService authService = AuthService();
  RxString responseMessage = "".obs;
  RxBool isLoading = false.obs;
  Rxn<ProfileModel> profileModel = Rxn<ProfileModel>();
  Rxn<PendingModel> pendingModel = Rxn<PendingModel>();

  Future<bool> profile() async {
    try {
      Map<String, dynamic> response = await authService.get("profile/info");
      print("ini response profile => $response");
      responseMessage(response['message']);
      if(response['status'] != true) {
        return false;
      }

      /** Coba access token disalahkan agar terdeteksi token expired */
      // authService.accessToken = "abogoboga";

      profileModel(ProfileModel.fromJson(response['response']));
      return true;

    } catch (e) {
      print(e.toString());
      return false;
    }
  }


  Future<bool> getPendingAccount() async {
    isLoading(true);
    try {
      Map<String, dynamic> response = await authService.get("account/pending");
      print(response);
      isLoading(false);
      responseMessage(response['message']);
      if(response['status'] != true) {
        return false;
      }
      pendingModel(PendingModel.fromJson(response));
      return true;

    } catch (e) {
      print(e.toString());
      isLoading(false);
      return false;
    }
  }
}