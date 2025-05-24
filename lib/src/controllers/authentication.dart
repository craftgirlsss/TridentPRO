import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tridentpro/src/controllers/2_factory_auth.dart';
import 'package:tridentpro/src/helpers/variables/global_variables.dart';
import 'package:tridentpro/src/models/auth/personal_model.dart';

class AuthController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingOTP = false.obs;
  RxString responseMessage = "".obs;
  Rxn<PersonalModels> personalModel = Rxn<PersonalModels>();
  TwoFactoryAuth twoFactoryAuth = Get.put(TwoFactoryAuth());

  /// Login API
  Future<bool> login({String? email, String? password}) async {
    try {
      isLoading(true);
      http.Response response = await http.post(
        Uri.tryParse("${GlobalVariable.mainURL}/auth/login")!,
        headers: {
          'x-api-key': GlobalVariable.x_api_key,
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {
          'email': email,
          'password': password
        },
      );
      var result = jsonDecode(response.body);
      print(result);
      isLoading(false);
      if (response.statusCode == 200) {
        personalModel(PersonalModels.fromJson(result));
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setBool('loggedIn', true);
        preferences.setString('refreshToken', personalModel.value!.response.refreshToken);
        preferences.setString('accessToken', personalModel.value!.response.accessToken);
        twoFactoryAuth.refreshToken(personalModel.value!.response.refreshToken);
        twoFactoryAuth.accessToken(personalModel.value!.response.accessToken);
        responseMessage.value = result['message'];
        return true;
      }
      responseMessage.value = result['message'];
      return false;
    } catch (e) {
      isLoading(false);
      responseMessage.value = e.toString();
      return false;
    }
  }

  /// Register API
  Future<bool> register({String? email, String? password, String? name, String? ibCode, String? phone, String? phoneCode, String? otp}) async {
    try {
      isLoading(true);
      http.Response response = await http.post(
        Uri.tryParse("${GlobalVariable.mainURL}/auth/register")!,
        headers: {
          'x-api-key': GlobalVariable.x_api_key,
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {
          'email': email,
          'password': password,
          'name': name,
          'ibcode': ibCode ?? '',
          'phone': phone,
          'phone_code': phoneCode ?? '62',
          'otp': otp
        },
      );
      var result = jsonDecode(response.body);
      isLoading(false);
      if (response.statusCode == 200) {
        responseMessage.value = result['message'];
        return true;
      }
      responseMessage.value = result['message']['data']['id'];
      return false;
    } catch (e) {
      isLoading(false);
      responseMessage.value = e.toString();
      return false;
    }
  }

  /// Send OTP API
  Future<bool> sendOTPSMS({String? phone, String? phoneCode}) async {
    try {
      isLoadingOTP(true);
      http.Response response = await http.post(
        Uri.tryParse("${GlobalVariable.mainURL}/auth/send-otp")!,
        headers: {
          'x-api-key': GlobalVariable.x_api_key,
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {
          'phone': phone,
          'phone_code': phoneCode ?? '62',
        },
      );
      var result = jsonDecode(response.body);
      isLoadingOTP(false);
      if (response.statusCode == 200) {
        responseMessage.value = result['message'];
        return true;
      }
      responseMessage.value = result['message'];
      return false;
    } catch (e) {
      isLoadingOTP(false);
      responseMessage.value = e.toString();
      return false;
    }
  }

  /// Send OTP WhatsApp API
  Future<bool> sendOTPWA({String? phone, String? phoneCode}) async {
    try {
      isLoadingOTP(true);
      http.Response response = await http.post(
        Uri.tryParse("${GlobalVariable.mainURL}/auth/send-otp-wa")!,
        headers: {
          'x-api-key': GlobalVariable.x_api_key,
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {
          'phone': phone,
          'phone_code': phoneCode ?? '62',
        },
      );
      var result = jsonDecode(response.body);
      isLoadingOTP(false);
      if (response.statusCode == 200) {
        responseMessage.value = result['message'];
        return true;
      }
      responseMessage.value = result['message'];
      return false;
    } catch (e) {
      isLoadingOTP(false);
      responseMessage.value = e.toString();
      return false;
    }
  }
}