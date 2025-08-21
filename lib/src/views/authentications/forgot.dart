import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/alerts/scaffold_messanger_alert.dart';
import 'package:tridentpro/src/components/buttons/elevated_button.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/components/textfields/email_textfield.dart';
import 'package:tridentpro/src/components/textfields/label_textfield.dart';
import 'package:tridentpro/src/controllers/authentication.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  final _formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;
  RxString phoneCode = "".obs;
  RxString number = "".obs;
  AuthController authController = Get.find();
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Forgot", style: GoogleFonts.inter(fontSize: 50, fontWeight: FontWeight.w700, color: CustomColor.secondaryColor, height: 1.0,)),
                      Text("password", style: GoogleFonts.inter(fontSize: 50, fontWeight: FontWeight.w700, color: Colors.black)),
                      const SizedBox(height: 5.0),
                      Text("Inputkan alamat Email yang telah didaftarkan sebelumnya, sistem akan mengirimkan kode password baru ke alamat email terkait.", style: TextStyle(color: CustomColor.textThemeLightSoftColor, fontSize: 15)),
                      const SizedBox(height: 30.0),
                      LabelTextField.labelName(
                        label: LanguageGlobalVar.EMAIL_ADDRESS.tr,
                        child: EmailTextField(
                          fieldName: LanguageGlobalVar.EMAIL_ADDRESS.tr,
                          controller: emailController,
                          useValidator: true,
                          hintText: LanguageGlobalVar.INPUT_YOUR_EMAIL_ADDRESS.tr,
                        )
                      ),
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
                  authController.forgotPassword(email: emailController.text).then((result){
                    if(result){
                      CustomScaffoldMessanger.showAppSnackBar(context, message: authController.responseMessage.value, type: SnackBarType.success);
                      Get.back();
                    }else{
                      CustomScaffoldMessanger.showAppSnackBar(context, message: authController.responseMessage.value, type: SnackBarType.error);
                    }
                  });
                }
              },
              title: authController.isLoading.value ? "Processing..." : LanguageGlobalVar.RESET_PASSWORD.tr
            ),
          ),
        ),
      ),
    );
  }
}
