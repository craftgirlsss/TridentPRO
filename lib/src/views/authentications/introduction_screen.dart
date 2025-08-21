import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tridentpro/src/components/buttons/custom_buttons.dart';
import 'package:tridentpro/src/components/colors/background.dart';
import 'package:tridentpro/src/components/utilities/utilities.dart';
import 'package:tridentpro/src/controllers/firebase_api_controller.dart';
import 'package:tridentpro/src/controllers/google_auth_controller.dart';
import 'package:tridentpro/src/helpers/handlers/permissions.dart';
import 'package:tridentpro/src/views/authentications/signin.dart';
import 'package:tridentpro/src/views/authentications/signup.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  GoogleSignInController googleController = Get.put(GoogleSignInController());
  double opacity = 1.0;

  @override
  void initState() {
    super.initState();
    FirebaseAPI.getToken();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await PermissionHandlers.requestPermissions();
    });
  }

  @override
  void dispose() {
    // _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          BackgroundColor.defaultBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UtilitiesComponents.titlePage(context),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size.width,
                        child: CustomButtons.buildFilledButton(
                          text: "Masuk",
                          onPressed: (){
                            Get.to(() => const SignIn());
                          }
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      SizedBox(
                        width: size.width,
                        child: CustomButtons.buildOutlinedButton(
                          text: "Daftar",
                          onPressed: () {
                            Get.to(() => const Signup());
                          }
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      const SizedBox(height: 20.0),
                      UtilitiesComponents.privacyPolicy(context),
                      const SizedBox(height: 9.0),
                      UtilitiesComponents.rrfx(context)
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}