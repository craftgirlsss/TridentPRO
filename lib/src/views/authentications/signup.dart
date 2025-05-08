import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/buttons/elevated_button.dart';
import 'package:tridentpro/src/components/buttons/outlined_button.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/components/textfields/email_textfield.dart';
import 'package:tridentpro/src/components/textfields/label_textfield.dart';
import 'package:tridentpro/src/components/textfields/name_textfield.dart';
import 'package:tridentpro/src/components/textfields/otp_textfield.dart';
import 'package:tridentpro/src/components/textfields/password_textfield.dart';
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
                      label: LanguageGlobalVar.FULL_NAME.tr,
                      child: NameTextField(
                        fieldName: LanguageGlobalVar.FULL_NAME.tr,
                        controller: fullNameController,
                        hintText: LanguageGlobalVar.FULL_NAME.tr,
                      )
                    ),
                    LabelTextField.labelName(
                      label: LanguageGlobalVar.EMAIL_ADDRESS.tr,
                      child: EmailTextField(
                        fieldName: LanguageGlobalVar.EMAIL_ADDRESS.tr,
                        controller: emailController,
                        hintText: "name@email.com",
                      )
                    ),
                    LabelTextField.labelName(
                      label: LanguageGlobalVar.PHONE_NUMBER.tr,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: PhoneTextField(
                              fieldName: LanguageGlobalVar.PHONE_NUMBER.tr,
                              controller: phoneController,
                              hintText: "+62",
                            ),
                          ),
                          const SizedBox(width: 5),
                          SizedBox(
                            width: size.width / 4,
                            height: 55,
                            child: CustomOutlinedButton.defaultOutlinedButton(
                              onPressed: (){},
                              title: LanguageGlobalVar.SEND_OTP.tr
                            ),
                          ),
                        ],
                      )
                    ),
                    LabelTextField.labelName(
                      label: LanguageGlobalVar.OTP_CODE.tr,
                      child: OTPTextField(
                        fieldName: LanguageGlobalVar.OTP_CODE.tr,
                        controller: otpController,
                        hintText: LanguageGlobalVar.OTP_CODE.tr,
                      )
                    ),
                    LabelTextField.labelName(
                      label: LanguageGlobalVar.PASSWORD.tr,
                      child: PasswordTextField(
                        fieldName: LanguageGlobalVar.PASSWORD.tr,
                        controller: passwordController,
                        hintText: LanguageGlobalVar.CREATE_PASSWORD.tr,
                      )
                    ),
                    LabelTextField.labelName(
                      label: LanguageGlobalVar.REPEAT_PASSWORD.tr,
                      child: PasswordTextField(
                        fieldName: LanguageGlobalVar.REPEAT_PASSWORD.tr,
                        controller: confirmPasswordController,
                        hintText: LanguageGlobalVar.REPEAT_PASSWORD.tr,
                      )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Obx(
                          () => Checkbox(
                          side: BorderSide(width: 1.0, color: CustomColor.textThemeDarkSoftColor),
                          activeColor: CustomColor.defaultColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0)
                          ),
                          value: checkedRead.value, onChanged: (value) => checkedRead.value = !checkedRead.value),
                        ),
                        Flexible(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.start,
                            children: [
                              Text(LanguageGlobalVar.HAVE_READ.tr, style: GoogleFonts.inter(color: CustomColor.textThemeDarkSoftColor)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: GestureDetector(
                                  child: Text("Terms and Conditions", style: GoogleFonts.inter(color: CustomColor.defaultColor, fontWeight: FontWeight.bold, fontSize: 12)), onTap: (){}),
                              ),
                              Text(LanguageGlobalVar.AND.tr, style: GoogleFonts.inter(color: CustomColor.textThemeDarkSoftColor)),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: GestureDetector(
                                  child: Text("Privacy and Policy", style: GoogleFonts.inter(color: CustomColor.defaultColor, fontWeight: FontWeight.bold, fontSize: 12)), onTap: (){}),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: DefaultButton.defaultElevatedButton(
            onPressed: (){
              if(_formKey.currentState!.validate()){}
            },
            title: LanguageGlobalVar.SELANJUTNYA.tr
          ),
        ),
      ),
    );
  }
}
