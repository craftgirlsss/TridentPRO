import 'package:get/get.dart';
import 'package:tridentpro/src/service/auth_service.dart';

class SettingController extends GetxController{
  RxBool isLoading = false.obs;
  AuthService authService = AuthService();
  RxString responseMessage = "".obs;

  // Create Demo Trading API
  Future<bool> getBankUser() async {
    try {
      isLoading(true);
      Map<String, dynamic> result = await authService.get("profile/user-bank");

      isLoading(false);
      responseMessage(result['message']);
      print(result);
      if (result['statusCode'] != 200) {
        return false;
      }
      return true;
    } catch (e) {
      isLoading(false);
      responseMessage(e.toString());
      return false;
    }
  }
}