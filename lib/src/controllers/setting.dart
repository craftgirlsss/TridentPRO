import 'package:get/get.dart';
import 'package:tridentpro/src/models/settings/admin_bank_model.dart';
import 'package:tridentpro/src/models/settings/user_bank_model.dart';
import 'package:tridentpro/src/service/auth_service.dart';

class SettingController extends GetxController{
  RxBool isLoading = false.obs;
  AuthService authService = AuthService();
  RxString responseMessage = "".obs;
  Rxn<UserBankModel> userBankModel = Rxn<UserBankModel>();
  Rxn<BankAdminModel> adminBankModel = Rxn<BankAdminModel>();


  // Pernataan Pailit
  Future<bool> getUserBank() async {
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

  // Pernataan Pailit
  Future<bool> getAdminBank() async {
    try {
      isLoading(true);
      Map<String, dynamic> result = await authService.get("transaction/bank-admin?type_news");
      isLoading(false);
      print(result);
      responseMessage(result['message']);
      if (result['status'] != true) {
        return false;
      }
      adminBankModel(BankAdminModel.fromJson(result));
      return true;
    } catch (e) {
      isLoading(false);
      responseMessage(e.toString());
      return false;
    }
  }

  // Pernataan Pailit
  Future<bool> deposit({
    String? bankAdminID,
    String? bankUserID,
    String? accountID,
    String? amount,
    String? imageURL
}) async {
    try {
      isLoading(true);
      Map<String, String> body = {
        'account': accountID!,
        'amount': amount!,
        'bank_user': bankUserID!,
        'bank_admin': bankAdminID!
      };
      Map<String, String> file = {
        'image': imageURL!
      };
      Map<String, dynamic> result = await authService.multipart("transaction/deposit", body, file);
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
  Future<bool> withdrawal() async {
    try {
      isLoading(true);
      Map<String, dynamic> result = await authService.get("transaction/deposit");
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
}