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
import 'package:tridentpro/src/components/painters/loading_water.dart';
import 'package:tridentpro/src/components/textfields/email_textfield.dart';
import 'package:tridentpro/src/components/textfields/password_textfield.dart';
import 'package:tridentpro/src/controllers/authentication.dart';
import 'package:tridentpro/src/views/accounts/test_page.dart';
import 'package:tridentpro/src/views/authentications/forgot.dart';
import 'package:tridentpro/src/views/authentications/onboarding.dart';
import 'package:tridentpro/src/views/authentications/passcode.dart';
import 'package:tridentpro/src/views/authentications/signup.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  List<IconData> imageURL = [CupertinoIcons.phone, CupertinoIcons.add_circled_solid];
  PageController pageController = PageController();
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  AuthController authController = Get.put(AuthController());

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
                    child: PageView.builder(
                      controller: pageController,
                      physics: const BouncingScrollPhysics(),
                      pageSnapping: true,
                      itemCount: imageURL.length,
                      itemBuilder: (context, index) => Container(
                        width: size.width,
                        height: size.height / 2.8,
                        color: CustomColor.backgroundIcon,
                        child: Center(
                          child: Icon(imageURL[index]),
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
                                child: DefaultButton.defaultElevatedButton(
                                  onPressed: (){
                                    if(_formKey.currentState!.validate()){
                                      authController.login(email: emailController.text, password: passwordController.text).then((result){
                                        if(result){
                                          Get.offAll(() => Onboarding());
                                        }else{
                                          CustomAlert.alertError(message: authController.responseMessage.value);
                                        }
                                      });
                                    }
                                  },
                                  title: LanguageGlobalVar.MASUK.tr
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
                                    onPressed: (){
                                      Get.to(() => const TestPage());
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
      Obx(() => authController.isLoading.value ? LoadingWater() : const SizedBox())
      ],
    );
  }
}
