import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/controllers/2_factory_auth.dart';
import 'package:get/get.dart';
import 'package:tridentpro/src/views/authentications/onboarding.dart';
import 'package:tridentpro/src/views/mainpage.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {

  TwoFactoryAuth twoFactoryAuth = Get.put(TwoFactoryAuth());

  Future<bool> getLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? accessToken = preferences.getString('accessToken');
    print(accessToken);
    return preferences.getBool('loggedIn') ?? false;
  }

  @override
  void initState() {
    super.initState();
    getLoggedIn().then((loggedIn){
      if(loggedIn){
        twoFactoryAuth.refreshTokenizer().then((result){
          if(result){
            Get.offAll(() => const Mainpage());
          }else{
            Get.off(() => const Onboarding());
          }
        });
      }else{
        Get.off(() => const Onboarding());
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColor.defaultColor,
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
