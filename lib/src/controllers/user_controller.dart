import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tridentpro/src/models/auth/profile.dart';
import 'package:tridentpro/src/models/settings/history_withdraw_deposit_model.dart';
import 'package:tridentpro/src/models/settings/transaction_detail_model.dart';
import 'package:tridentpro/src/service/auth_service.dart';

class UserController extends GetxController {
  RxBool isLoading = false.obs;
  RxString responseMessage = "".obs;
  AuthService authService = AuthService();
  Rxn<ProfileModel> profileModel = Rxn<ProfileModel>();
  Rxn<HistoryWithdrawDepositModel> historyDepoWd = Rxn<HistoryWithdrawDepositModel>();
  Rxn<TransactionDetailModel> transactionDetail = Rxn<TransactionDetailModel>();

  Future<bool> getProfile() async {
    isLoading(true);
    try {
      Map<String, dynamic> response = await authService.get("/profile/info");
      isLoading(false);
      print(response);
      responseMessage(response['message']);
      if(response['status'] != true) {
        return false;
      }
      profileModel(ProfileModel.fromJson(response['response']));
      return true;

    } catch (e) {
      debugPrint(e.toString());
      isLoading(false);
      return false;
    }
  }

  Future<bool> updateProfile({
    String? fullname,
    String? gender,
    String? dateOfBirth,
    String? placeOfBirth,
    String? address,
    String? country,
    String? zipcode
  }) async {
    isLoading(true);
    try {
      Map<String, dynamic> response = await authService.post("/profile/updateInfo",
        {
          'fullname': fullname,
          'gender': gender,
          'date_of_birth': dateOfBirth,
          'place_of_birth': placeOfBirth,
          'address': address,
          'country': country,
          'zipcode': zipcode
        }
      );
      isLoading(false);
      responseMessage(response['message']);
      if(response['status'] != true) {
        return false;
      }
      return true;

    } catch (e) {
      debugPrint(e.toString());
      isLoading(false);
      return false;
    }
  }

  Future<bool> updateAvatar({String? urlImage}) async {
    try {
      isLoading(true);
      Map<String, String> file = {};
      if(urlImage != null) {
        file['image'] = urlImage;
      }
      Map<String, dynamic> result = await authService.multipart("profile/updateAvatar", {}, file);
      isLoading(false);
      responseMessage(result['message']);
      if(result['status'] != true) {
        return false;
      }
      return true;
    } catch (e) {
      isLoading(false);
      responseMessage(e.toString());
      return false;
    }
  }

  Future<bool> historyWithdrawAndDeposit() async {
    try {
      isLoading(true);
      Map<String, dynamic> result = await authService.get("transaction/history");
      isLoading(false);

      // ✅ Parsing langsung dari List
      var model = HistoryWithdrawDepositModel.fromJson(result['response']);
      historyDepoWd(model); // Pastikan ini menerima tipe yang sesuai

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

  Future<bool> historyTransactionDetail({String? id}) async {
    try {
      isLoading(true);
      Map<String, dynamic> result = await authService.get("transaction/historyDetail?id=$id");
      isLoading(false);
      transactionDetail(TransactionDetailModel.fromJson(result['response']));
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

  Future<bool> addBank({String? currency, String? bankName, String? bankBranch, String? bankHolder, String? type, String? account}) async {
    try {
      isLoading(true);
      Map<String, dynamic> result = await authService.post("bank/create", {
        'currency': currency,
        'bank_name': bankName,
        'bank_branch': bankBranch,
        'bank_holder': bankHolder,
        'type': type,
        'account': account
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
}