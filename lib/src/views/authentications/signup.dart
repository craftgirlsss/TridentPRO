import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tridentpro/src/components/alerts/default.dart';
import 'package:tridentpro/src/components/buttons/elevated_button.dart';
import 'package:tridentpro/src/components/buttons/outlined_button.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/components/painters/loading_water.dart';
import 'package:tridentpro/src/components/textfields/email_textfield.dart';
import 'package:tridentpro/src/components/textfields/label_textfield.dart';
import 'package:tridentpro/src/components/textfields/name_textfield.dart';
import 'package:tridentpro/src/components/textfields/otp_textfield.dart';
import 'package:tridentpro/src/components/textfields/password_textfield.dart';
import 'package:tridentpro/src/controllers/authentication.dart';
import 'package:tridentpro/src/views/authentications/signin.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  RxBool checkedRead = false.obs;
  RxBool isLoading = false.obs;
  RxString phoneCode = "".obs;
  RxString number = "".obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  AuthController authController = Get.find();

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
      child: Stack(
        children: [
          Scaffold(
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
                                child: Obx(
                                  () => isLoading.value ? const SizedBox() : IntlPhoneField(
                                    dropdownIcon: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.black26),
                                    dropdownDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    decoration: InputDecoration(
                                    labelText: LanguageGlobalVar.PHONE,
                                    hintStyle: GoogleFonts.inter(
                                      color: CustomColor.textThemeDarkSoftColor,
                                      fontSize: 14
                                    ),
                                    labelStyle: const TextStyle(color: CustomColor.textThemeDarkSoftColor, fontSize: 14),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                        color: CustomColor.defaultColor
                                      )
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12.0),
                                        borderSide: BorderSide(
                                          color: CustomColor.textThemeDarkSoftColor
                                        )
                                      ),
                                    ),
                                    initialCountryCode: 'ID', // Nigeria default
                                    onChanged: (phone) {
                                      phoneCode(phone.countryCode);
                                      number(phone.number); // Output: +234xxxx
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              SizedBox(
                                width: size.width / 4,
                                height: 52,
                                child: Obx(
                                  () => CustomOutlinedButton.defaultOutlinedButton(
                                    onPressed: authController.isLoading.value ? null : (){
                                      if(number.value == ""){
                                        CustomAlert.alertError(
                                          message: LanguageGlobalVar.ERROR_PHONE_NULL.tr
                                        );
                                      }else{
                                        if(kDebugMode){
                                          authController.sendOTPWA(phone: number.value, phoneCode: phoneCode.value).then((result){
                                            CustomAlert.showMySnackBar(authController.responseMessage.value);
                                          });
                                        }else{
                                          authController.sendOTPSMS(phone: number.value, phoneCode: phoneCode.value).then((result){
                                            CustomAlert.showMySnackBar(authController.responseMessage.value);
                                          });
                                        }
                                      }
                                    },
                                    title: authController.isLoadingOTP.value ? "Sending OTP..." : LanguageGlobalVar.SEND_OTP.tr
                                  ),
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
                                      child: Text(LanguageGlobalVar.TERMS_AND_CONDITIONS.tr, style: GoogleFonts.inter(color: CustomColor.defaultColor, fontWeight: FontWeight.bold, fontSize: 12)), onTap: (){}),
                                  ),
                                  Text(LanguageGlobalVar.AND.tr, style: GoogleFonts.inter(color: CustomColor.textThemeDarkSoftColor)),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: GestureDetector(
                                      child: Text(LanguageGlobalVar.PRIVACY_AND_POLICY.tr, style: GoogleFonts.inter(color: CustomColor.defaultColor, fontWeight: FontWeight.bold, fontSize: 12)), onTap: (){}),
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
              child: Obx(
                () => DefaultButton.defaultElevatedButton(
                  onPressed: authController.isLoading.value ? null : (){
                    if(_formKey.currentState!.validate()){
                      if(confirmPasswordController.text != passwordController.text){
                        CustomAlert.alertError(
                          message: LanguageGlobalVar.PASSWORD_NOT_THE_SAME.tr
                        );
                      }else{
                        authController.register(
                          phoneCode: phoneCode.value,
                          phone: number.value,
                          password: confirmPasswordController.text,
                          email: emailController.text,
                          name: fullNameController.text,
                          otp: otpController.text,
                          ibCode: ""
                        ).then((result){
                          if(result){
                            CustomAlert.alertDialogCustomSuccess(
                              message: authController.responseMessage.value,
                              onTap: (){
                                Get.off(() => const SignIn());
                              }
                            );
                          }else{
                            CustomAlert.alertError(
                              message: authController.responseMessage.value
                            );
                          }
                        });
                      }
                    }
                  },
                  title: authController.isLoading.value ? "Processing..." : LanguageGlobalVar.SELANJUTNYA.tr
                ),
              ),
            ),
          ),
          // Obx(() => authController.isLoading.value ? LoadingWater() : const SizedBox())
        ],
      ),
    );
  }
}
