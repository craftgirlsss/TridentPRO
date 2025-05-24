import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tridentpro/src/controllers/2_factory_auth.dart';
import 'package:tridentpro/src/controllers/authentication.dart';
import 'package:tridentpro/src/models/trades/ohlc_models.dart';
import 'package:tridentpro/src/models/trades/trading_account_models.dart';
import 'package:tridentpro/src/service/auth_service.dart';

class OHLCDataModel {
  DateTime? date;
  double? open;
  double? high;
  double? low;
  double? close;
  OHLCDataModel({this.date, this.open, this.high, this.low, this.close});
}

class TradingController extends GetxController {
  RxBool isLoading = false.obs;
  RxString responseMessage = "".obs;
  Rxn<OHLCModels> ohlcModels = Rxn<OHLCModels>();
  RxList<OHLCDataModel> ohlcData = <OHLCDataModel>[].obs;
  Rxn<TradingAccountModels> tradingAccountModels = Rxn<TradingAccountModels>();
  TwoFactoryAuth twoFactoryAuth = Get.find();
  AuthController authController = Get.find();
  AuthService authService = AuthService();

  // Status Order API Driver
  Future<bool> getMarket({String? market}) async {
    try {
      isLoading(true);
      http.Response response = await http.get(
        Uri.tryParse("https://api-tridentprofutures.techcrm.net/market/price-history?symbol=${market?.toUpperCase()}")!,
        headers: {
          'x-api-key': "fewAHdSkx28301294cKSnczdAs",
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );
      var result = jsonDecode(response.body);
      isLoading(false);
      if (response.statusCode == 200) {
        ohlcModels(OHLCModels.fromJson(result));
        for(int i = 0; i < ohlcModels.value!.response.length; i++){
          ohlcData.add(OHLCDataModel(
            close: ohlcModels.value!.response[i].close,
            open: ohlcModels.value!.response[i].open,
            high: ohlcModels.value!.response[i].high,
            low: ohlcModels.value!.response[i].low,
            date: DateTime.parse(ohlcModels.value!.response[i].date!),
          ));
        }
        responseMessage(result['message']);
        return true;
      }

      responseMessage(result['message']);
      return false;
    } catch (e) {
      isLoading(false);
      responseMessage(e.toString());
      return false;
    }
  }

  // Create Demo Trading API
  Future<bool> getTradingAccount() async {
    try {
      isLoading(true);
      Map<String, dynamic> result = await authService.post("account/info", {});
      isLoading(false);
      if (result['statusCode'] == 200) {
        tradingAccountModels(TradingAccountModels.fromJson(result['response']));
        return true;
      }

      responseMessage(result['message']);
      return false;

    } catch (e) {
      isLoading(false);
      responseMessage(e.toString());
      return false;
    }
  }

  // Create Demo Trading API
  Future<bool> createDemo() async {
    try {
      isLoading(true);
      Map<String, dynamic> result = await authService.post("regol/createDemo", {});
      
      isLoading(false);
      if (result['statusCode'] == 200) {
        return true;
      }
      responseMessage(result['message']);
      return false;
    } catch (e) {
      isLoading(false);
      responseMessage(e.toString());
      return false;
    }
  }
}