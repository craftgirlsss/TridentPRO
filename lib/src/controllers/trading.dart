import 'dart:math';
import 'package:deriv_chart/deriv_chart.dart';
import 'package:get/get.dart';
import 'package:tridentpro/src/controllers/two_factory_auth.dart';
import 'package:tridentpro/src/controllers/authentication.dart';
import 'package:tridentpro/src/models/trades/ohlc_models.dart';
import 'package:tridentpro/src/models/trades/open_order_model.dart';
import 'package:tridentpro/src/models/trades/trading_account_models.dart';
import 'package:tridentpro/src/service/auth_service.dart';

import '../models/trades/trading_order_history_model.dart';

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
  RxList<Candle> ohlcDataDeriv = <Candle>[].obs;
  Rxn<TradingAccountModels> tradingAccountModels = Rxn<TradingAccountModels>();
  Rxn<TradingOrderHistoryModel> tradingHistoryModel = Rxn<TradingOrderHistoryModel>();
  Rxn<OpenOrderModel> openOrderModel = Rxn<OpenOrderModel>();
  TwoFactoryAuth twoFactoryAuth = Get.find();
  AuthController authController = Get.find();
  AuthService authService = AuthService();
  RxList<Map<String, dynamic>> accountTrading = <Map<String, dynamic>>[].obs;
  RxList symbols = [].obs;
  RxDouble minPrice = 0.0.obs;
  RxDouble maxPrice = 0.0.obs;
  static final Random _random = Random(42);

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
  
  /// Get Market History SyncFusion
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
      ohlcData.clear();
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


  /// Get Market History for Deriv Chart with real-time updates
  Future<bool> getMarketForDerivChart({String? market, String? timeframe}) async {
    try {
      market = market ?? "GOLDUD";
      timeframe = timeframe ?? "H1";
      
      final Map<String, dynamic> result = await authService.get("market/price-history?symbol=$market&timeframe=$timeframe");
      
      if(result['status'] != true) {
        return false;
      }

      final List<dynamic> json = result['response'].map((e) => e as Map<String, dynamic>).toList();
      List<Candle> newCandles = [];

      for(var i in json) {
        try {
          final candle = Candle(
            epoch: DateTime.parse(i['date']).millisecondsSinceEpoch ~/ 1000,
            open: double.parse(i['open'].toString()),
            high: double.parse(i['high'].toString()),
            low: double.parse(i['low'].toString()),
            close: double.parse(i['close'].toString()),
          );
          newCandles.add(candle);
        } catch (e) {
          continue;
        }
      }
      newCandles.sort((a, b) => a.epoch.compareTo(b.epoch));
      ohlcDataDeriv.clear();
      ohlcDataDeriv.addAll(newCandles);
      
      // print("Current number of candles: ${ohlcDataDeriv.length}");
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Generate a list of sample ticks.
  static List<Tick> generateTicks({int count = 100}) {
    final List<Tick> ticks = [];
    final baseTimestamp = DateTime.now().subtract(Duration(minutes: count)).millisecondsSinceEpoch;
    double lastQuote = 100;

    for (int i = 0; i < count; i++) {
      final timestamp = baseTimestamp + i * 60000; // 1 minute intervals
      // Random walk with some volatility
      lastQuote += (_random.nextDouble() - 0.5) * 2.0;
      ticks.add(Tick(
        epoch: timestamp,
        quote: lastQuote,
      ));
    }

    return ticks;
  }

  // Create Demo Trading API
  Future<bool> getTradingAccount() async {
    try {
      isLoading(true);
      Map<String, dynamic> result = await authService.get("account/info");
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
      (result);
      
      isLoading(false);
      if (result['status']) {
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

  Future<Map<String, dynamic>> addTradingAccount({required String accountId}) async {
    try {
      Map<String, dynamic> result = await authService.post("market/account/add", {
        'account_id': accountId
      });

      return result;
      
    } catch (e) {
      throw Exception("addTradingAccount error: $e");
    }
  }

  Future<Map<String, dynamic>> connectTradingAccount({required String accountId}) async {
    try {
      Map<String, dynamic> result = await authService.post("market/account/connect", {
        'account_id': accountId
      });
      return result;

    } catch (e) {
      throw Exception("addTradingAccount error: $e");
    }
  }

  Future<Map<String, dynamic>> inputPassword({required String accountId, required String password}) async {
    try {
      Map<String, dynamic> result = await authService.post("market/account/update", {
        'account_id': accountId,
        'password': password
      });
      return result;

    } catch (e) {
      throw Exception("addTradingAccount error: $e");
    }
  }

  Future<Map<String, dynamic>> deleteTradingAccount({required String accountId}) async {
    try {
      Map<String, dynamic> result = await authService.post('market/account/delete', {
        'trade_id': accountId
      });

      return result;
      
    } catch (e) {
      throw Exception("deleteTradingAccount error: $e");
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

  Future<Map<String, dynamic>> closedOrder({required String login}) async {
    isLoading(true);
    try {
      Map<String, dynamic> result = await authService.get('market/trade-history?login=$login');
      tradingHistoryModel(TradingOrderHistoryModel.fromJson(result));
      isLoading(false);
      return result;
    } catch (e) {
      throw Exception("executionOrder error: $e");
    }
  }

  Future<Map<String, dynamic>> openOrder({required String login}) async {
    isLoading(true);
    try {
      Map<String, dynamic> result = await authService.get('market/opened-order?login=$login');
      openOrderModel(OpenOrderModel.fromJson(result));
      isLoading(false);
      return result;
    } catch (e) {
      // return {};
      throw Exception("executionOrder error: $e");
    }
  }

  Future<Map<String, dynamic>> closingOrder({required String loginID, required String? ticketID}) async {
    isLoading(true);
    try {
      Map<String, dynamic> result = await authService.post('market/market/execution/close', {
        'login': loginID,
        'ticket': ticketID
      });
      isLoading(false);
      return result;
    } catch (e) {
      throw Exception("executionOrder error: $e");
    }
  }
}