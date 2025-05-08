import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tridentpro/src/components/languages/languages.dart';
import 'package:tridentpro/src/components/themes/default.dart';
import 'package:tridentpro/src/views/authentications/onboarding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TridentPRO',
      defaultTransition: Transition.cupertino,
      debugShowCheckedModeBanner: false,
      translations: Languages(),
      locale: Get.deviceLocale,
      theme: CustomTheme.defaultLightTheme(),
      darkTheme: CustomTheme.defaultDarkTheme(),
      themeMode: ThemeMode.system,
      home: Onboarding(),
    );
  }
}

/*
Get.updateLocale(Locale(“en”, “US”))
 */