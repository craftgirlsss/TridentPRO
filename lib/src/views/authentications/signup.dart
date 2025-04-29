import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/components/textfields/email_textfield.dart';
import 'package:tridentpro/src/components/textfields/label_textfield.dart';
import 'package:tridentpro/src/components/textfields/name_textfield.dart';
import 'package:tridentpro/src/components/textfields/otp_textfield.dart';
import 'package:tridentpro/src/components/textfields/phone_textfield.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  RxBool checkedRead = false.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    otpController.dispose();
    phoneController.dispose();
    confirmPasswordController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(LanguageGlobalVar.REGIST_NOW.tr, style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          )),
                          const SizedBox(height: 8),
                          Text(LanguageGlobalVar.CREATE_ACCOUNT_FOR_START.tr, style: GoogleFonts.inter(
                            fontSize: 14,
                            color: CustomColor.textThemeDarkSoftColor
                          ))
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    LabelTextField.labelName(
                      child: NameTextField(
                        controller: fullNameController,
                        hintText: "Fill your name",
                      )
                    ),
                    LabelTextField.labelName(
                      label: "Email",
                      child: EmailTextField(
                        controller: emailController,
                        hintText: "name@email.com",
                      )
                    ),
                    LabelTextField.labelName(
                      label: "Phone",
                      child: Row(
                        children: [
                          Expanded(
                            child: PhoneTextField(
                              controller: phoneController,
                              hintText: "+62",
                            ),
                          ),
                          const SizedBox(width: 5),
                          SizedBox(
                            width: size.width / 4,
                            child: OTPTextField(
                              controller: otpController,
                              hintText: "OTP",
                            ),
                          ),
                        ],
                      )
                    ),
                  ],
                ),
              )
            ),
          ),
        ),
      ),
    );
  }
}
