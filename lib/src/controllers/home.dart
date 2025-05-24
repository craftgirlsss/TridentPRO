import 'package:get/get.dart';
import 'package:tridentpro/src/models/auth/profile.dart';
import 'package:tridentpro/src/service/auth_service.dart';

class HomeController extends GetxController {
  AuthService authService = AuthService();
  Rxn<ProfileModel> profileModel = Rxn<ProfileModel>();

  Future<bool> profile() async {
    try {
      Map<String, dynamic> response = await authService.get("profile/info");
      if(response['success'] != true) {
        // return false;
      }

      /** Coba access token disalahkan agar terdeteksi token expired */
      // authService.accessToken = "abogoboga";

      profileModel(ProfileModel.fromJson(response['response']));
      return response['success'] ?? false;

    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}