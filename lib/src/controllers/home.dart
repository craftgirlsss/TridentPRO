import 'package:get/get.dart';
import 'package:tridentpro/src/models/auth/profile.dart';
import 'package:tridentpro/src/service/auth_service.dart';

class HomeController extends GetxController {
  AuthService authService = AuthService();
  RxString responseMessage = "".obs;
  Rxn<ProfileModel> profileModel = Rxn<ProfileModel>();

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
}