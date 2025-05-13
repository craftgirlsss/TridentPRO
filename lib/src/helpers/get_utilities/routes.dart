import 'package:get/get.dart';
import 'package:tridentpro/src/views/authentications/forgot.dart';
import 'package:tridentpro/src/views/authentications/onboarding.dart';
import 'package:tridentpro/src/views/authentications/passcode.dart';
import 'package:tridentpro/src/views/authentications/signin.dart';
import 'package:tridentpro/src/views/authentications/signup.dart';
import 'package:tridentpro/src/views/mainpage.dart';

class GetUtilities {
  static final routes = [
    GetPage(name: '/', page: () => const Onboarding()),

    GetPage(name: '/login', page: () => const SignIn()),
    GetPage(name: '/login/signup', page: () => const Signup()),
    GetPage(name: '/login/forgot', page: () => const Forgot()),
    GetPage(name: '/login/forgot', page: () => const Forgot()),

    GetPage(name: '/login/passcode', page: () => const Passcode()),
    GetPage(name: '/login/passcode/mainpage', page: () => const Mainpage()),
  ];
}
