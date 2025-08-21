import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/alerts/default.dart';
import 'package:tridentpro/src/components/buttons/elevated_button.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/components/textfields/email_textfield.dart';
import 'package:tridentpro/src/components/textfields/password_textfield.dart';
import 'package:tridentpro/src/controllers/authentication.dart';
import 'package:tridentpro/src/controllers/google_auth_controller.dart';
import 'package:tridentpro/src/controllers/utilities.dart';
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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome", style: GoogleFonts.inter(fontSize: 50, fontWeight: FontWeight.w700, color: CustomColor.secondaryColor, height: 1.0,)),
                    Text("back!", style: GoogleFonts.inter(fontSize: 50, fontWeight: FontWeight.w700, color: Colors.black)),
                    const SizedBox(height: 5.0),
                    Text("Lihat pergerakan harga pasar global secara langsung, dengan chart interaktif dan analisis teknikal lengkap.", style: TextStyle(color: CustomColor.textThemeLightSoftColor, fontSize: 15)),
                    const SizedBox(height: 30.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EmailTextField(
                            readOnly: false,
                            useValidator: true,
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
                              color: CustomColor.secondaryColor
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
                          SizedBox(
                            width: size.width,
                            child: Obx(
                              () => DefaultButton.defaultElevatedButtonIcon(
                                urlIcon: 'assets/images/icon-google.png',
                                onPressed: authController.isLoading.value ? null : (){
                                  googleSignInController.signInWithGoogle();
                                },
                                title: authController.isLoading.value ? "Processing..." : LanguageGlobalVar.SIGN_IN_WITH_GOOGLE.tr
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(LanguageGlobalVar.NOT_HAVE_ACCOUNT.tr, style: GoogleFonts.inter(color: CustomColor.textThemeLightSoftColor)),
                                TextButton(
                                  onPressed: (){
                                      Get.to(() => const Signup());
                                    },
                                  style: TextButton.styleFrom(padding: EdgeInsets.only(left: 5)),
                                  child: Text(LanguageGlobalVar.REGIST_NOW.tr, style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    color: CustomColor.secondaryColor
                                  ))
                                ),
                              ],
                            ),
                          ),
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
    );
  }
}
