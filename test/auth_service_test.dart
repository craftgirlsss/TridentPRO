import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:tridentpro/src/helpers/variables/global_variables.dart';
import '../lib/src/service/auth_service.dart';
import 'auth_service_test.mocks.dart';

@GenerateMocks([AuthService])
void main() {
  group('AuthService Tests', () {
    test('should send correct login data', () async {
      final authService = AuthService();
      
      // Data yang akan dikirim
      final body = {
        'email': 'bomba1@yopmail.com',
        'password': 'YW1GdVoyRnVJRzVoYTJGcw',
      };

      // Act - Melakukan request sebenarnya
      final result = await authService.post("auth/login", body);
      
      // Memastikan response memiliki format yang benar
      expect(result, isA<Map<String, dynamic>>());
      expect(result.containsKey("response"), true);
      expect(result['response'].containsKey("access_token"), true);
      expect(result['response'].containsKey("refresh_token"), true);
    });

    test('should return new access & refresh token', () async {
      final authService = AuthService();
      final body = {
        'refresh_token': 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMTc0NzcwNjYxMCIsInR5cGUiOiJyZWZyZXNoIiwiZXhwIjoxNzUwNTYyMTYwfQ==.+jPquEmgd7pC8HbvItlaE9QqBNH6y2YKbJ1yi8/FGWg=',
      };

      final result = await authService.refreshingToken("auth/refresh", body);

      print(result);
      expect(result, isA<Map<String, dynamic>>());
      expect(result['status'], true);
    });


    test('should return new access & refresh token if response code 300', () async {
      final authService = AuthService();
      await authService.init();

      final fetchProfile = await authService.get("profile/info");
      print(fetchProfile);

      expect(fetchProfile, isA<Map<String, dynamic>>());
      expect(fetchProfile.containsKey("success"), true);
    });
  });
}
