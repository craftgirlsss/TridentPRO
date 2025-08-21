import 'package:flutter/material.dart';
import 'package:tridentpro/src/views/authentications/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tridentpro/src/components/alerts/default.dart';
import 'package:tridentpro/src/controllers/two_factory_auth.dart';
import 'package:get/get.dart';
import 'package:tridentpro/src/controllers/home.dart';
import 'package:tridentpro/src/helpers/handlers/permissions.dart';
import 'package:tridentpro/src/service/auth_service.dart';
import 'package:tridentpro/src/views/authentications/introductionv2.dart';
import 'package:tridentpro/src/views/mainpage.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {

  TwoFactoryAuth twoFactoryAuth = Get.put(TwoFactoryAuth());
  HomeController homeController = Get.put(HomeController());
  AuthService authService = Get.find();

  Future<bool> getLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool('loggedIn') ?? false;
  }

  @override
  void initState() {
    PermissionHandlers.requestPermissions();
    super.initState();
    getLoggedIn().then((loggedIn) async {
      if(loggedIn){
        Map<String, dynamic> result = await authService.get("profile/info");
        if(result['statusCode'] == 200){
          homeController.profile().then((resultProfile){
            if(!resultProfile){
              CustomAlert.alertError(message: homeController.responseMessage.value, onTap: (){
                // Get.offAll(() => const IntroductionScreen());
                Get.offAll(() => const Introductionv2());
              });
              return;
            }
            Get.offAll(() => const Mainpage());
          });
          return;
        }
        Get.offAll(() => const Introductionv2());
        // Get.offAll(() => const IntroductionScreen());
      }else{
        Get.offAll(() => const Introductionv2());
        // Get.offAll(() => const IntroductionScreen());
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/ic_launcher.png', width: size.width / 2),
          ],
        ),
      ),
    );
  }
}
