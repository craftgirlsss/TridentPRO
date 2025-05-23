import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tridentpro/src/helpers/variables/global_variables.dart';

class AuthService extends GetxController {
  String? accessToken;
  String? refreshToken;

  final Map<String, String> headers = {
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<bool> init() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    accessToken = preferences.getString('accessToken');
    refreshToken = preferences.getString('refreshToken');

    // accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJUzI1NiJ9.eyJ1c2VyX2lkIjoiMTc0NzcwNjYxMCIsInR5cGUiOiJhY2Nlc3MiLCJleHAiOjE3NDc5NzQ3NTh9.5tn59rtT5tMp9B+23Lb7Lv/ZcJJSG/2WzxuCoehWfTc=";
    // refreshToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMTc0NzcwNjYxMCIsInR5cGUiOiJyZWZyZXNoIiwiZXhwIjoxNzUwNTYzMTU4fQ==.ZNVgbqNSlllMnUFNC0U58P2R9td5uEKkQbwUI/xGW3g=";
  
    return true;
  }

  Future<Map<String, dynamic>> post(String url, Map<String, dynamic> body, {int maxReload = 0}) async {
    try {
      await init();
      headers['Authorization'] = 'Bearer $accessToken';

      http.Response response = await http.post(
        Uri.parse("${GlobalVariable.mainURL}/$url"), 
        headers: headers,
        body: body
      );

      if (response.statusCode == 300) {
        if(maxReload > 3) {
          throw Exception("Telah mencapai max reload, silahkan login kembali");
        }
        
        Map<String, dynamic> refreshTokenResponse = await refreshingToken(body: {
          'refresh_token': refreshToken ?? "",
        });

        // Initialize new access & refresh token from response
        accessToken = refreshTokenResponse['response']['access_token'];
        refreshToken = refreshTokenResponse['response']['refresh_token'];

        // Set new access & refresh token to SharedPreferences
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('accessToken', accessToken!);
        preferences.setString('refreshToken', refreshToken!);

        return await get(url);
      }

      Map<String, dynamic> respBody = jsonDecode(response.body);
      return {
        'status': respBody['status'],
        'statusCode': response.statusCode,
        'message': respBody['message'],
        'response': respBody['response'],
      };

    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> multipart(String url, Map<String, String> body, Map<String, String> file, {int maxReload = 0}) async {
    try {
      await init();
      headers['Authorization'] = 'Bearer $accessToken';

      http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse("${GlobalVariable.mainURL}/$url"));
      request.headers.addAll(headers);
      request.fields.addAll(body);

      
      for(var key in file.keys) {
        if(file[key] != null) {
          request.files.add(await http.MultipartFile.fromPath(key, file[key]!));
        }
      }

      http.StreamedResponse response = await request.send();
      String responseString = await response.stream.bytesToString();
      Map<String, dynamic> respBody = jsonDecode(responseString);
      print(respBody);

      if (response.statusCode == 300) {
        if(maxReload > 3) {
          throw Exception("Telah mencapai max reload, silahkan login kembali");
        }
        
        Map<String, dynamic> refreshTokenResponse = await refreshingToken(body: {
          'refresh_token': refreshToken ?? "",
        });

        // Initialize new access & refresh token from response
        accessToken = refreshTokenResponse['response']['access_token'];
        refreshToken = refreshTokenResponse['response']['refresh_token'];

        // Set new access & refresh token to SharedPreferences
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('accessToken', accessToken!);
        preferences.setString('refreshToken', refreshToken!);

        return await get(url);
      }

      return {
        'status': respBody['status'],
        'statusCode': response.statusCode,
        'message': respBody['message'],
        'response': respBody['response'],
      };

    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> get(String url, {int maxReload = 0}) async {
    try {
      await init();
      headers['Authorization'] = 'Bearer $accessToken';

      http.Response response = await http.get(
        Uri.parse("${GlobalVariable.mainURL}/$url"), 
        headers: headers,
      );

      if (response.statusCode == 300) {
        if(maxReload > 3) {
          throw Exception("Telah mencapai max reload, silahkan login kembali");
        }
        
        Map<String, dynamic> refreshTokenResponse = await refreshingToken(body: {
          'refresh_token': refreshToken ?? "",
        });

        // Initialize new access & refresh token from response
        accessToken = refreshTokenResponse['response']['access_token'];
        refreshToken = refreshTokenResponse['response']['refresh_token'];

        // Set new access & refresh token to SharedPreferences
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('accessToken', accessToken!);
        preferences.setString('refreshToken', refreshToken!);

        return await get(url);
      }

      Map<String, dynamic> respBody = jsonDecode(response.body);
      return {
        'status': respBody['status'],
        'statusCode': response.statusCode,
        'message': respBody['message'],
        'response': respBody['response'],
      };

    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> refreshingToken({required Map<String, dynamic> body}) async {
    try {
      // print("Token expired, refreshing token with: $refreshToken ");
      http.Response response = await http.post(
        Uri.parse("${GlobalVariable.mainURL}/auth/refresh"),
        headers: headers,
        body: body, // Tidak perlu jsonEncode untuk form-urlencoded
      );

      Map<String, dynamic> refreshTokenResponse = jsonDecode(response.body);
      if(refreshTokenResponse['status'] != true) {
        throw Exception("Session Expired, please re-login");
      }

      if(!refreshTokenResponse.containsKey("response")) {
        throw Exception("Invalid Response");
      }

      if(!refreshTokenResponse['response'].containsKey("access_token") || !refreshTokenResponse['response'].containsKey("refresh_token")) {
        throw Exception("Failed to refresh token, please re-login");
      }

      return refreshTokenResponse;

    } catch (e) {
      throw Exception(e);
    }
  }
}
