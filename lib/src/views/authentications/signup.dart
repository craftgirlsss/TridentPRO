import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/alerts/default.dart';
import 'package:tridentpro/src/components/buttons/elevated_button.dart';
import 'package:tridentpro/src/components/buttons/outlined_button.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/components/textfields/email_textfield.dart';
import 'package:tridentpro/src/components/textfields/label_textfield.dart';
import 'package:tridentpro/src/components/textfields/name_textfield.dart';
import 'package:tridentpro/src/components/textfields/otp_textfield.dart';
import 'package:tridentpro/src/components/textfields/password_textfield.dart';
import 'package:tridentpro/src/components/utilities/utilities.dart';
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
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              forceMaterialTransparency: true,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Hello", style: GoogleFonts.inter(fontSize: 50, fontWeight: FontWeight.w700, color: CustomColor.secondaryColor, height: 1.0,)),
                        Text("there!", style: GoogleFonts.inter(fontSize: 50, fontWeight: FontWeight.w700, color: Colors.black)),
                        const SizedBox(height: 5.0),
                        Text("Lihat pergerakan harga pasar global secara langsung, dengan chart interaktif dan analisis teknikal lengkap.", style: TextStyle(color: CustomColor.textThemeLightSoftColor, fontSize: 15)),
                        const SizedBox(height: 30.0),
                        LabelTextField.labelName(
                          label: LanguageGlobalVar.FULL_NAME.tr,
                          child: NameTextField(
                            useValidator: true,
                            fieldName: LanguageGlobalVar.FULL_NAME.tr,
                            controller: fullNameController,
                            hintText: LanguageGlobalVar.FULL_NAME.tr,
                          )
                        ),
                        LabelTextField.labelName(
                          label: LanguageGlobalVar.EMAIL_ADDRESS.tr,
                          child: EmailTextField(
                            useValidator: true,
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
                                    validator: (value) {
                                      if (value!.countryCode.isEmpty) {
                                        return 'Mohon isikan nomor HP';
                                      }
                                      return null;
                                    },
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
                                        color: CustomColor.secondaryColor
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
                                       //if(kDebugMode){
                                          authController.sendOTPWA(phone: number.value, phoneCode: phoneCode.value).then((result){
                                            CustomAlert.showMySnackBar(authController.responseMessage.value);
                                          });
                                        // }else{
                                        //   authController.sendOTPSMS(phone: number.value, phoneCode: phoneCode.value).then((result){
                                        //     CustomAlert.showMySnackBar(authController.responseMessage.value);
                                        //   });
                                        }
                                      //}
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
                        UtilitiesComponents.checkBoxAgreement(context, checkedRead: checkedRead)
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
                  onPressed: authController.isLoading.value ? null : checkedRead.value ? (){
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
                  } : null,
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
