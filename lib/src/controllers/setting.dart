import 'package:get/get.dart';
import 'package:tridentpro/src/models/settings/user_bank_model.dart';
import 'package:tridentpro/src/service/auth_service.dart';

class SettingController extends GetxController{
  RxBool isLoading = false.obs;
  AuthService authService = AuthService();
  RxString responseMessage = "".obs;
  Rxn<UserBankModel> userBankModel = Rxn<UserBankModel>();


  // Pernataan Pailit
  Future<bool> getUserBank({
    String? annualIncome,
    String? lokasiRumah,
    String? njop,
    String? deposito,
    String? lainnya
  }) async {
    try {
      isLoading(true);
      Map<String, dynamic> result = await authService.get("profile/user-bank");

      isLoading(false);
      print(result);
      responseMessage(result['message']);
      if (result['status'] != true) {
        return false;
      }
      userBankModel(UserBankModel.fromJson(result));
      return true;
    } catch (e) {
      isLoading(false);
      responseMessage(e.toString());
      return false;
    }
  }
}