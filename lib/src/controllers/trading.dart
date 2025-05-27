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
  RxList symbols = [].obs;
  RxDouble minPrice = 0.0.obs;
  RxDouble maxPrice = 0.0.obs;

  Future<List<dynamic>> getSymbols({String? market}) async {
    try {
      Map<String, dynamic> result = await authService.get("market/symbols");
      if(result['status'] != true) {
        return [];
        // symbols(result['response']);
      }

      List<dynamic> json = result['response'].map((e) => e as Map<String, dynamic>).toList();
      symbols(json);
      return symbols;

    } catch (e) {
      throw Exception("getSymbols error: $e");
    }
  }
  
  // Status Order API Driver
  Future<bool> getMarket({String? market, String? timeframe}) async {
    try {
      market = market ?? "-";
      timeframe = timeframe ?? "H1";
      Map<String, dynamic> result = await authService.get("market/price-history?symbol=$market&timeframe=$timeframe");
      if(result['status'] != true) {
        return false;
      }

      List<dynamic> json = result['response'].map((e) => e as Map<String, dynamic>).toList();
      minPrice.value = 0.0;
      maxPrice.value = 0.0;
      for(var i in json) {
        minPrice.value = (minPrice.value < double.parse(i['open'].toString()) && minPrice.value != 0.0) ? minPrice.value : double.parse(i['open'].toString());
        maxPrice.value = maxPrice.value > double.parse(i['open'].toString()) ? maxPrice.value : double.parse(i['open'].toString());

        ohlcData.add(OHLCDataModel(
          date: DateTime.parse(i['date']), 
          open: double.parse(i['open'].toString()), 
          high: double.parse(i['high'].toString()), 
          low: double.parse(i['low'].toString()), 
          close: double.parse(i['close'].toString())
        ));
      }

      return true;

    } catch (e) {
      throw Exception("getMarket error: $e");
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

  Future<List<Map<String, dynamic>>> getTradingAccountV2() async {
    try {
      Map<String, dynamic> result = await authService.get("market/account/list");
      if (result['status'] != true) {
        return [];
      }

      List<dynamic> rawList = result['response'];
      List<Map<String, dynamic>> json = rawList.map((e) => Map<String, dynamic>.from(e)).toList();
      return json;

    } catch (e) {
      throw Exception("getTradingAccount error: $e");
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

  Future<Map<String, dynamic>> executionOrder({required String symbol, required String type, required String login, required String lot, String? price = "0.00"}) async {
    try {
      Map<String, dynamic> result = await authService.post('market/execution/open', {
        'login': login.toString(),
        'symbol': symbol,
        'operation': type,
        'volume': lot,
        'price': price
      });

      return result;
      
    } catch (e) {
      throw Exception("executionOrder error: $e");
    }
  }
}