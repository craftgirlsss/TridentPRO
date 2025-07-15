import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tridentpro/src/models/auth/image_login_model.dart';
import 'package:tridentpro/src/models/trades/market_model.dart';
import 'package:tridentpro/src/models/utilities/chat_model_list.dart';
import 'package:tridentpro/src/models/utilities/messages_model.dart';
import 'package:tridentpro/src/models/utilities/city_models.dart';
import 'package:tridentpro/src/models/utilities/country_models.dart';
import 'package:tridentpro/src/models/utilities/desa_models_api.dart';
import 'package:tridentpro/src/models/utilities/kabupaten_models_api.dart';
import 'package:tridentpro/src/models/utilities/kabupaten_raja_models.dart';
import 'package:tridentpro/src/models/utilities/kecamatan_models_api.dart';
import 'package:tridentpro/src/models/utilities/kecamatan_raja_models.dart';
import 'package:tridentpro/src/models/utilities/news_detail.dart';
import 'package:tridentpro/src/models/utilities/news_model.dart';
import 'package:tridentpro/src/models/utilities/province_models.dart';
import 'package:tridentpro/src/models/utilities/province_models_api.dart';
import 'package:tridentpro/src/models/utilities/province_raja_models.dart';
import 'package:tridentpro/src/models/utilities/slide_model.dart';
import 'package:tridentpro/src/models/utilities/trading_signals_model.dart';
import 'package:tridentpro/src/service/auth_service.dart';

class UtilitiesController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingProvince = false.obs;
  RxBool isLoadingCity = false.obs;
  RxString responseMessage = "".obs;
  RxString selectedCountry = "".obs;
  RxString selectedProvince = "".obs;
  RxString selectedCity = "".obs;
  RxBool loadingPrice = false.obs;

  AuthService authService = Get.find();

  Rxn<CountryModels> countryModels = Rxn<CountryModels>();
  Rxn<ProvinceModels> provinceModels = Rxn<ProvinceModels>();
  Rxn<CityModels> cityModels = Rxn<CityModels>();
  Rxn<NewsModel> newsModel = Rxn<NewsModel>();
  Rxn<NewsDetail> newsDetail = Rxn<NewsDetail>();
  Rxn<MarketModel> marketModel = Rxn<MarketModel>();
  Rxn<SlideListModel> slideModel = Rxn<SlideListModel>();
  Rxn<ImageLoginModel> imageLoginModel = Rxn<ImageLoginModel>();
  Rxn<TradingSignalsModel> tradingSignal = Rxn<TradingSignalsModel>();

  // Ticket
  Rxn<ListOfTicketsModel> listTicketModel = Rxn<ListOfTicketsModel>();
  Rxn<MessagesModel> messagesModel = Rxn<MessagesModel>();

  //Raja Class Models
  Rxn<ProvinceRajaModels> provinceRajaModels = Rxn<ProvinceRajaModels>();
  Rxn<KabupatenRajaModels> kabupatenRajaModels = Rxn<KabupatenRajaModels>();
  Rxn<KecamatanRajaModels> kecamatanRajaModels = Rxn<KecamatanRajaModels>();


  Rxn<ProvinceModelsAPI> provinceModelAPI = Rxn<ProvinceModelsAPI>();
  Rxn<KabupatenModelsAPI> kabupatenModelAPI = Rxn<KabupatenModelsAPI>();
  Rxn<KecamatanModelsAPI> kecamatanModelAPI = Rxn<KecamatanModelsAPI>();
  Rxn<DesaModelsAPI> desaModelAPI = Rxn<DesaModelsAPI>();
  RxString selectedProvinceID = "".obs;
  RxString selectedKabupatenID = "".obs;
  RxString selectedKecamatanID = "".obs;
  RxString selectedDesaID = "".obs;

  Future<bool> getCountry() async {
    try {
      isLoading(true);
      http.Response response = await http.get(
        Uri.tryParse("https://countriesnow.space/api/v0.1/countries/capital")!,
        headers: {
          'Content-Type': 'application/json'
        },
      );
      var result = jsonDecode(response.body);
      isLoading(false);
      if (response.statusCode == 200) {
        countryModels.value = CountryModels.fromJson(result);
        return true;
      } else {
        responseMessage.value = result['msg'];
        return false;
      }
    } catch (e) {
      isLoading(false);
      responseMessage.value = e.toString();
      return false;
    }
  }

  Future<bool> getProvince({String? countryName}) async {
    try {
      isLoadingProvince(true);
      http.Response response = await http.get(
        Uri.tryParse("https://countriesnow.space/api/v0.1/countries/states/q?country=$countryName")!,
        headers: {
          'Content-Type': 'application/json'
      },
      );
      var result = jsonDecode(response.body);
      isLoadingProvince(false);
      if (response.statusCode == 200) {
        provinceModels.value = ProvinceModels.fromJson(result);
        return true;
      } else {
        responseMessage.value = result['msg'];
        return false;
      }
    } catch (e) {
      isLoadingProvince(false);
      responseMessage.value = e.toString();
      return false;
    }
  }

  Future<bool> getCity({String? provinceName}) async {
    try {
      isLoadingCity(true);
      http.Response response = await http.get(
        Uri.tryParse("https://countriesnow.space/api/v0.1/countries/state/cities/q?country=${selectedCountry.value}&state=${selectedProvince.value}")!,
        headers: {
          'Content-Type': 'application/json'
        },
      );
      var result = jsonDecode(response.body);
      isLoadingCity(false);
      if (response.statusCode == 200) {
        cityModels.value = CityModels.fromJson(result);
        return true;
      } else {
        responseMessage.value = result['msg'];
        return false;
      }
    } catch (e) {
      isLoadingCity(false);
      responseMessage.value = e.toString();
      return false;
    }
  }

  // Province Raja Controller API
  Future<bool> getProvinceRaja() async {
    try {
      isLoadingProvince(true);
      http.Response response = await http.get(
        Uri.tryParse("https://pro.rajaongkir.com/api/province")!,
        headers: {
          'key': 'e049d10db2bd7fc4d5ec3cb4035633be'
        },
      );
      var result = jsonDecode(response.body);
      isLoadingProvince(false);
      if (response.statusCode == 200) {
        provinceRajaModels.value = ProvinceRajaModels.fromJson(result);
        return true;
      } else {
        responseMessage.value = "Failed to get Province";
        return false;
      }
    } catch (e) {
      isLoadingProvince(false);
      responseMessage.value = e.toString();
      return false;
    }
  }

  Future<bool> getCityRaja() async {
    try {
      isLoadingCity(true);
      http.Response response = await http.get(
        Uri.tryParse("https://pro.rajaongkir.com/api/city?province=$selectedProvince")!,
        headers: {
          'key': 'e049d10db2bd7fc4d5ec3cb4035633be'
        },
      );
      var result = jsonDecode(response.body);
      isLoadingCity(false);
      if (response.statusCode == 200) {
        kabupatenRajaModels.value = KabupatenRajaModels.fromJson(result);
        return true;
      } else {
        responseMessage.value = "Failed to get Kabupaten";
        return false;
      }
    } catch (e) {
      isLoadingCity(false);
      responseMessage.value = e.toString();
      return false;
    }
  }

  Future<bool> getVillageRaja() async {
    try {
      isLoadingCity(true);
      http.Response response = await http.get(
        Uri.tryParse("https://pro.rajaongkir.com/api/subdistrict?city=409")!,
        headers: {
          'key': 'e049d10db2bd7fc4d5ec3cb4035633be'
        },
      );
      var result = jsonDecode(response.body);
      isLoadingCity(false);
      if (response.statusCode == 200) {
        cityModels.value = CityModels.fromJson(result);
        return true;
      } else {
        responseMessage.value = "Failed to get Kecamatan";
        return false;
      }
    } catch (e) {
      isLoadingCity(false);
      responseMessage.value = e.toString();
      return false;
    }
  }

  // Province API
  Future<bool> getProvinceAPI() async {
    try {
      Map<String, dynamic> result = await authService.get("regol/getProvince");

      isLoading(false);
      if (result['status'] != true) {
        return false;
      }
      provinceModelAPI(ProvinceModelsAPI.fromJson(result));
      responseMessage(result['message']);
      return true;
    } catch (e) {
      isLoading(false);
      responseMessage(e.toString());
      return false;
    }
  }

  // Kabupaten API
  Future<bool> getKabupatenAPI() async {
    try {
      Map<String, dynamic> result = await authService.post("regol/getRegency", {
        "province" : selectedProvinceID.value
      });

      if (result['status'] != true) {
        return false;
      }
      kabupatenModelAPI(KabupatenModelsAPI.fromJson(result));
      responseMessage(result['message']);
      return true;
    } catch (e) {
      responseMessage(e.toString());
      return false;
    }
  }

  // Kecamatan API
  Future<bool> getKecamatanAPI() async {
    try {
      Map<String, dynamic> result = await authService.post("regol/getDistrict", {
        "regency" : selectedKabupatenID.value
      });

      print(result);

      if (result['status'] != true) {
        return false;
      }
      kecamatanModelAPI(KecamatanModelsAPI.fromJson(result));
      responseMessage(result['message']);
      return true;
    } catch (e) {
      responseMessage(e.toString());
      return false;
    }
  }

  // Desa API
  Future<bool> getDesaAPI() async {
    try {
      Map<String, dynamic> result = await authService.post("regol/getVillages", {
        "district" : selectedKecamatanID.value
      });

      if (result['status'] != true) {
        return false;
      }
      desaModelAPI(DesaModelsAPI.fromJson(result));
      responseMessage(result['message']);
      return true;
    } catch (e) {
      responseMessage(e.toString());
      return false;
    }
  }


  // Desa API
  Future<bool> getNewsList() async {
    try {
      Map<String, dynamic> result = await authService.get("public/news");

      if (result['status'] != true) {
        return false;
      }
      newsModel(NewsModel.fromJson(result));
      responseMessage(result['message']);
      return true;
    } catch (e) {
      responseMessage(e.toString());
      return false;
    }
  }

  // Desa API
  Future<bool> getSlideImageHome() async {
    try {
      Map<String, dynamic> result = await authService.get("public/slide");

      if (result['status'] != true) {
        return false;
      }
      slideModel(SlideListModel.fromJson(result));
      responseMessage(result['message']);
      return true;
    } catch (e) {
      responseMessage(e.toString());
      return false;
    }
  }


  // Daftar Tickets API
  Future<bool> ticketList() async {
    try {
      Map<String, dynamic> result = await authService.get("ticket/list");

      if (result['status'] != true) {
        return false;
      }
      print(result);
      responseMessage(result['message']);
      listTicketModel(ListOfTicketsModel.fromJson(result));
      return true;
    } catch (e) {
      responseMessage(e.toString());
      return false;
    }
  }

  // Create Tickets API
  Future<bool> createTicket({String? subject}) async {
    try {
      Map<String, dynamic> result = await authService.post("ticket/create", {
        "subject" : subject
      });

      if (result['status'] != true) {
        return false;
      }
      responseMessage(result['message']);
      return true;
    } catch (e) {
      responseMessage(e.toString());
      return false;
    }
  }


  // Create Tickets API
  Future<bool> closeTicket({String? code}) async {
    try {
      Map<String, dynamic> result = await authService.post("ticket/close", {
        "code" : code
      });
      print(result);

      if (result['status'] != true) {
        return false;
      }
      responseMessage(result['message']);
      return true;
    } catch (e) {
      responseMessage(e.toString());
      return false;
    }
  }

  // List Message of Ticket API
  Future<bool> listMessageOfTicket({String? code}) async {
    try {
      Map<String, dynamic> result = await authService.get("ticket/chats?code=$code");

      if (result['status'] != true) {
        return false;
      }
      print(result);
      responseMessage(result['message']);
      messagesModel(MessagesModel.fromJson(result));
      return true;
    } catch (e) {
      responseMessage(e.toString());
      return false;
    }
  }

  // Send Ticket Message API
  Future<bool> sendMessage({String? code, String? message}) async {
    try {
      Map<String, dynamic> result = await authService.post("ticket/sendMessage", {
        'code': code,
        'message': message
      });
      print(code);
      print(message);
      print(result);

      if (result['status'] != true) {
        return false;
      }
      responseMessage(result['message']);
      return true;
    } catch (e) {
      responseMessage(e.toString());
      return false;
    }
  }

  // Desa API
  Future<bool> getSlideImageLogin() async {
    try {
      Map<String, dynamic> result = await authService.get("public/slide-home");

      if (result['status'] != true) {
        return false;
      }
      imageLoginModel(ImageLoginModel.fromJson(result));
      responseMessage(result['message']);
      return true;
    } catch (e) {
      responseMessage(e.toString());
      return false;
    }
  }

  // Desa API
  Future<bool> getNewsDetail({String? newsID}) async {
    try {
      Map<String, dynamic> result = await authService.post("public/news-detail", {
        "id" : newsID
      });

      if (result['status'] != true) {
        return false;
      }
      newsDetail(NewsDetail.fromJson(result));
      responseMessage(result['message']);
      return true;
    } catch (e) {
      responseMessage(e.toString());
      return false;
    }
  }


  Future<bool> getTradingSignals({String? timeFrame}) async {
    try {
      isLoading(true);
      http.Response response = await http.get(
        Uri.tryParse("https://api-mt5.techcrm.net/v5-terminal-analis/analysis_main?timeframe=${timeFrame ?? "H1"}")!,
        headers: {
          'Content-Type': 'application/json'
        },
      );
      var result = jsonDecode(response.body);
      print("INI RESULT TRADING SIGNAL $result");
      isLoading(false);
      if (response.statusCode == 200) {
        tradingSignal(TradingSignalsModel.fromJson(result));
        return true;
      }
      responseMessage.value = result['result'];
      return false;
    } catch (e) {
      isLoading(false);
      responseMessage.value = e.toString();
      return false;
    }
  }

  Future<bool> getMarketPrice() async {
    print("fungsi get market price dijalankan");
    try {
      loadingPrice(true);
      http.Response response = await http.get(
        Uri.tryParse("https://api-mt5.techcrm.net/v5-terminal-analis/prices")!,
        headers: {
          'Content-Type': 'application/json'
        },
      );
      var result = jsonDecode(response.body);

      loadingPrice(false);
      print("ini result price list => $result");
      if (response.statusCode == 200) {
        marketModel(MarketModel.fromJson(result));
        return true;
      }
      responseMessage.value = result['result'];
      return false;
    } catch (e) {
      loadingPrice(false);
      print(e.toString());
      responseMessage.value = e.toString();
      return false;
    }
  }
}