import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tridentpro/src/components/buttons/default.dart';
import 'package:tridentpro/src/components/buttons/iconbuttons.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/components/textfields/email_textfield.dart';
import 'package:tridentpro/src/components/textfields/password_textfield.dart';
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
                            hintText: "Alamat Email",
                            controller: emailController,
                          ),
                          PasswordTextField(
                            controller: passwordController,
                            hintText: "Kata Sandi",
                          ),
                          TextButton(
                            onPressed: (){},
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
                                if(_formKey.currentState!.validate()){}
                              },
                              title: LanguageGlobalVar.MASUK.tr
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(LanguageGlobalVar.NOT_HAVE_ACCOUNT.tr, style: GoogleFonts.inter(color: CustomColor.textThemeDarkSoftColor)),
                                TextButton(
                                    onPressed: (){
                                      Get.to(() => const Signup());
                                    },
                                    style: TextButton.styleFrom(
                                        padding: EdgeInsets.only(
                                          left: 5,
                                        )
                                    ),
                                    child: Text(LanguageGlobalVar.REGIST_NOW.tr, style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      color: CustomColor.defaultColor
                                    )
                                  )
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
                                onPressed: (){},
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
    );
  }
}
