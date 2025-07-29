import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tridentpro/src/components/alerts/default.dart';
import 'package:tridentpro/src/components/buttons/elevated_button.dart';
import 'package:tridentpro/src/components/buttons/iconbuttons.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/components/textfields/email_textfield.dart';
import 'package:tridentpro/src/components/textfields/password_textfield.dart';
import 'package:tridentpro/src/controllers/authentication.dart';
import 'package:tridentpro/src/controllers/google_auth_controller.dart';
import 'package:tridentpro/src/controllers/utilities.dart';
import 'package:tridentpro/src/helpers/handlers/sound_handler.dart';
import 'package:tridentpro/src/views/authentications/forgot.dart';
import 'package:tridentpro/src/views/authentications/signup.dart';
import 'package:tridentpro/src/views/mainpage.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  List<IconData> imageURL = [CupertinoIcons.phone, CupertinoIcons.add_circled_solid];
  PageController pageController = PageController();
  GoogleSignInController googleSignInController = Get.put(GoogleSignInController());
  final _formKey = GlobalKey<FormState>();
  final AudioPlayer _audioPlayer = AudioPlayer();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  UtilitiesController utilitiesController = Get.put(UtilitiesController());
  AuthController authController = Get.put(AuthController());
  
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      utilitiesController.getSlideImageLogin().then((result){
        if(!result){}
      });
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: size.width,
                    height: size.height / 2.8,
                    child: Obx(
                      () => PageView.builder(
                        controller: pageController,
                        physics: const BouncingScrollPhysics(),
                        pageSnapping: true,
                        itemCount: utilitiesController.imageLoginModel.value?.response?.length ?? imageURL.length,
                        itemBuilder: (context, index) => Container(
                          width: size.width,
                          height: size.height / 2.8,
                          decoration: BoxDecoration(
                            color: CustomColor.backgroundIcon,
                            image: utilitiesController.imageLoginModel.value?.response?.length != null ? DecorationImage(image: NetworkImage(utilitiesController.imageLoginModel.value!.response![index].picture!), fit: BoxFit.cover) : null
                          ),
                          child: utilitiesController.imageLoginModel.value?.response?.length != null ? null : Center(
                            child: Icon(imageURL[index]),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SmoothPageIndicator(
                              controller: pageController,
                              count: imageURL.length,
                              effect: WormEffect(
                                dotHeight: 8,
                                dotWidth: 8,
                                dotColor: CustomColor.backgroundIcon,
                                type: WormType.thinUnderground,
                                activeDotColor: CustomColor.defaultColor,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Text(LanguageGlobalVar.WELCOME_TEXT.tr, style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold)),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              EmailTextField(
                                readOnly: false,
                                fieldName: LanguageGlobalVar.EMAIL_ADDRESS.tr,
                                hintText: LanguageGlobalVar.EMAIL_ADDRESS.tr,
                                controller: emailController,
                              ),
                              PasswordTextField(
                                fieldName: LanguageGlobalVar.PASSWORD.tr,
                                controller: passwordController,
                                hintText: LanguageGlobalVar.PASSWORD.tr,
                              ),
                              TextButton(
                                onPressed: () => Get.to(() => const Forgot()),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.only(
                                    bottom: 24,
                                  )
                                ),
                                child: Text(LanguageGlobalVar.LUPA.tr, style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  color: CustomColor.defaultColor
                                ))
                              ),
                              SizedBox(
                                width: size.width,
                                child: Obx(
                                  () => DefaultButton.defaultElevatedButton(
                                    onPressed: authController.isLoading.value ? null : (){
                                      if(_formKey.currentState!.validate()){
                                        authController.login(email: emailController.text, password: passwordController.text).then((result){
                                          if(result){
                                            Get.offAll(() => Mainpage());
                                          }else{
                                            CustomAlert.alertError(message: authController.responseMessage.value);
                                          }
                                        });
                                      }
                                    },
                                    title: authController.isLoading.value ? "Processing..." : LanguageGlobalVar.MASUK.tr
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(LanguageGlobalVar.NOT_HAVE_ACCOUNT.tr, style: GoogleFonts.inter(color: CustomColor.textThemeDarkSoftColor)),
                                    TextButton(
                                      onPressed: (){
                                          Get.to(() => const Signup());
                                        },
                                      style: TextButton.styleFrom(padding: EdgeInsets.only(left: 5)),
                                      child: Text(LanguageGlobalVar.REGIST_NOW.tr, style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        color: CustomColor.defaultColor
                                      ))
                                    ),
                                  ],
                                ),
                              ),
                              Center(
                                child: Text(LanguageGlobalVar.OR_REGIST_WITH.tr, style: GoogleFonts.inter(color: CustomColor.textThemeDarkSoftColor))
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: IconButtons.defaultIconButton(
                                    onPressed: () async {
                                      try {
                                        final userCredential = await googleSignInController.signInWithGoogle();
                                        if (userCredential.user != null) {
                                          print("Berhasil login dengan nama akun ${userCredential.user?.email}");
                                          SoundHandler.playSuccessSound(audioPlayer: _audioPlayer);
                                        }
                                      } catch (e) {
                                        debugPrint('Login gagal: $e');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("Login gagal. Silakan coba lagi.")),
                                        );
                                      }
                                    },
                                    icon: Bootstrap.google
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      // Obx(() => authController.isLoading.value ? LoadingWater() : const SizedBox())
      ],
    );
  }
}
