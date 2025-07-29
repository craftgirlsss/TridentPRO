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
  Future<bool> editBank(
    {
      String? bankID,
      String? currencyType,
      String? bankName,
      String? owner,
      String? city,
      String? branch,
      String? type,
      String? number
    }
  ) async {
    try {
      isLoading(true);
      Map<String, dynamic> result = await authService.post("bank/update", {
        'bank_id': bankID,
        'currency': currencyType,
        'bank_name': bankName,
        'bank_branch': branch,
        'bank_holder': owner,
        'type': type,
        'account': number
      });

      isLoading(false);
      print(result);
      responseMessage(result['message']);
      if (result['status'] != true) {
        return false;
      }
      getUserBank();
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
  Future<bool> withdrawal({
    String? bankUserID,
    String? tradingID,
    String? amount
  }) async {
    try {
      isLoading(true);
      Map<String, dynamic> result = await authService.post("transaction/withdrawal", {
        'account': tradingID,
        'amount': amount,
        'bank_user': bankUserID
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
  Future<bool> internalTransfer({
    String? tradingIDReceiver,
    String? tradingIDSender,
    String? amount
  }) async {
    try {
      isLoading(true);
      Map<String, dynamic> result = await authService.post("transaction/internal-transfer", {
        'acc_from': tradingIDSender,
        'acc_to': tradingIDReceiver,
        'amount': amount
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
}