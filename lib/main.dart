import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:deriv_chart/generated/l10n.dart' as chart_l10n;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tridentpro/src/components/languages/languages.dart';
import 'package:tridentpro/src/components/themes/default.dart';
import 'package:tridentpro/src/controllers/authentication.dart';
import 'package:tridentpro/src/controllers/home.dart';
import 'package:tridentpro/src/helpers/get_utilities/routes.dart';
import 'package:tridentpro/src/service/auth_service.dart';
import 'package:tridentpro/src/views/authentications/splashscreen.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  
  final authService = Get.put(AuthService());
  final authController = Get.put(AuthController());
  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      title: 'TridentPRO',
      getPages: GetUtilities.routes,
      defaultTransition: Transition.cupertino,
      debugShowCheckedModeBanner: false,
      translations: Languages(),
      locale: Get.deviceLocale,
      theme: CustomTheme.defaultLightTheme(),
      // darkTheme: CustomTheme.defaultDarkTheme(),
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        chart_l10n.ChartLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
      ],
      home: const Splashscreen(),
    );
  }
}

/*
Get.updateLocale(Locale(“en”, “US”))
 */