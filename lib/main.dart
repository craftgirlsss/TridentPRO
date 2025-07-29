import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tridentpro/src/views/authentications/splashscreen.dart';

import 'firebase_options.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling background message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final authService = Get.put(AuthService());
  final authController = Get.put(AuthController());
  final homeController = Get.put(HomeController());
  late AppLinks _appLinks;
  StreamSubscription<Uri>? uriSubscription;

  Future<void> initDeepLinks() async {
    // Handle the initial deep link if the app was launched by one
    final appLink = await _appLinks.getInitialLink();
    if (appLink != null) {
      _handleDeepLink(appLink);
    }

    // Handle subsequent deep links while the app is running
    uriSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });
  }

  void _handleDeepLink(Uri uri) {
    // Example: If your deep link is https://tridentprofutures.com/products/123
    // You might want to navigate to a product detail page in your app.
    if (uri.pathSegments.contains('products') && uri.pathSegments.length > 1) {
      final productId = uri.pathSegments[uri.pathSegments.indexOf('products') + 1];
      Get.toNamed('/product/$productId'); // Navigate using GetX
    } else if (uri.path == '/') {
      Get.toNamed('/home'); // Navigate to home page
    }
    // Add more logic here to handle different deep link paths
    print('Deep link received: $uri');
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked!');
    });
  }

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