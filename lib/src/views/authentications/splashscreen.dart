import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tridentpro/src/components/alerts/default.dart';
import 'package:tridentpro/src/controllers/2_factory_auth.dart';
import 'package:get/get.dart';
import 'package:tridentpro/src/controllers/home.dart';
import 'package:tridentpro/src/service/auth_service.dart';
import 'package:tridentpro/src/views/authentications/onboarding.dart';
import 'package:tridentpro/src/views/authentications/signin.dart';
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
    super.initState();
    getLoggedIn().then((loggedIn) async {
      print(loggedIn);
      if(loggedIn){
        Map<String, dynamic> result = await authService.get("profile/info");
        print(result);
        if(result['statusCode'] == 200){
          homeController.profile().then((resultProfile){
            print(resultProfile);
            if(!resultProfile){
              CustomAlert.alertError(message: homeController.responseMessage.value, onTap: (){
                Get.offAll(() => const SignIn());
              });
              return;
            }
            Get.offAll(() => const Mainpage());
          });
          return;
        }
        Get.offAll(() => const SignIn());
      }else{
        Get.offAll(() => const SignIn());
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
            Image.asset('assets/icons/ic_launcher.png', width: size.width / 2),
          ],
        ),
      ),
    );
  }
}
