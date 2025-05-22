import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/bottomsheets/material_bottom_sheets.dart';
import 'package:tridentpro/src/components/containers/phone_code_selector.dart';
import 'package:tridentpro/src/components/containers/utilities.dart';
import 'package:tridentpro/src/components/dates/material_datepicker.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/components/textfields/email_textfield.dart';
import 'package:tridentpro/src/components/textfields/name_textfield.dart';
import 'package:tridentpro/src/components/textfields/phone_textfield.dart';
import 'package:tridentpro/src/components/textfields/void_textfield.dart';
import 'package:tridentpro/src/helpers/variables/countries.dart';
import 'package:tridentpro/src/helpers/variables/global_variables.dart';
import 'package:tridentpro/src/views/accounts/step_3_marital.dart';

import 'components/step_position.dart';

class Step2StoredData extends StatefulWidget {
  const Step2StoredData({super.key});

  @override
  State<Step2StoredData> createState() => _Step2StoredData();
}

class _Step2StoredData extends State<Step2StoredData> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController idTypeController = TextEditingController();
  TextEditingController idNumberController = TextEditingController();
  TextEditingController taxController = TextEditingController();
  TextEditingController dateBirthController = TextEditingController();
  TextEditingController placeBirthController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  RxString selectedPhone = "62".obs;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    idTypeController.dispose();
    idNumberController.dispose();
    taxController.dispose();
    dateBirthController.dispose();
    placeBirthController.dispose();
    genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar.defaultAppBar(
          autoImplyLeading: true,
          title: LanguageGlobalVar.PERSONAL_INFORMATION.tr,
          actions: [
            CupertinoButton(
              onPressed: (){},
              child: Text(LanguageGlobalVar.CANCEL.tr, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            )
          ]
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                UtilitiesWidget.titleContent(
                  title: LanguageGlobalVar.TITLE_REGOL_PAGE_2.tr,
                  subtitle: LanguageGlobalVar.SUBTITLE_REGOL_PAGE_2.tr,
                  children: [
                    NameTextField(controller: nameController, fieldName: LanguageGlobalVar.FULL_NAME.tr, hintText: LanguageGlobalVar.INPUT_YOUR_NAME.tr, labelText: LanguageGlobalVar.FULL_NAME.tr),
                    EmailTextField(controller: emailController, fieldName: LanguageGlobalVar.EMAIL_ADDRESS.tr, hintText: LanguageGlobalVar.INPUT_YOUR_EMAIL_ADDRESS.tr, labelText: LanguageGlobalVar.EMAIL_ADDRESS.tr),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() => CustomPhoneSelector.phoneCodeSelector(onTap: (){
                          CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: LanguageGlobalVar.CHOOSE_YOUR_PHONE_CODE.tr, children: List.generate(countryList.length, (i){
                            return ListTile(
                              leading: Text("+${countryList[i].phoneCode}", style: GoogleFonts.inter()),
                              onTap: (){
                                Navigator.pop(context);
                                selectedPhone(countryList[i].phoneCode);
                              },
                              title: Text(countryList[i].name, style: GoogleFonts.inter()),
                            );
                          }));
                        }, selectedPhone: selectedPhone.value)),
                        const SizedBox(width: 5),
                        Expanded(child: PhoneTextField(controller: phoneController, fieldName: LanguageGlobalVar.PHONE_NUMBER.tr, hintText: "81xxxx", labelText: LanguageGlobalVar.PHONE_NUMBER.tr)),
                      ],
                    ),
                  ]
                ),

                UtilitiesWidget.titleContent(
                    title: LanguageGlobalVar.TITLE_REGOL_PAGE_2_2.tr,
                    subtitle: LanguageGlobalVar.SUBTITLE_REGOL_PAGE_2_2.tr,
                    children: [
                      PhoneTextField(controller: idNumberController, fieldName: LanguageGlobalVar.ID_TYPE_NUMBER.tr, hintText: LanguageGlobalVar.ID_TYPE_NUMBER.tr, labelText: LanguageGlobalVar.ID_TYPE_NUMBER.tr),
                      PhoneTextField(controller: taxController, fieldName: LanguageGlobalVar.TAX_CARD.tr, hintText: LanguageGlobalVar.TAX_CARD.tr, labelText: LanguageGlobalVar.TAX_CARD.tr),
                      VoidTextField(controller: dateBirthController, fieldName: LanguageGlobalVar.BIRTH_DATE.tr, hintText: LanguageGlobalVar.BIRTH_DATE.tr, labelText: LanguageGlobalVar.BIRTH_DATE.tr, onPressed: () async {
                        var result = await CustomMaterialDatePicker.selectDate(context);
                        dateBirthController.text = result ?? "";
                      }),
                      NameTextField(controller: placeBirthController, fieldName: LanguageGlobalVar.BIRTH_PLACE.tr, hintText: LanguageGlobalVar.BIRTH_PLACE.tr, labelText: LanguageGlobalVar.BIRTH_PLACE.tr),
                      VoidTextField(controller: genderController, fieldName: LanguageGlobalVar.GENDER.tr, hintText: LanguageGlobalVar.GENDER.tr, labelText: LanguageGlobalVar.GENDER.tr, onPressed: (){
                        CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, isScrolledController: false, title: LanguageGlobalVar.CHOOSE_YOUR_GENDER.tr, children: List.generate(GlobalVariable.gender.length, (i){
                          return ListTile(
                            title: Text(GlobalVariable.gender[i], style: GoogleFonts.inter()),
                            onTap: (){
                              Navigator.pop(context);
                              genderController.text = GlobalVariable.gender[i];
                            },
                          );
                        }));
                      }),
                    ]
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: StepUtilities.stepOnlineRegister(
          size: size,
          title: LanguageGlobalVar.DATA_COLLECTION.tr,
          onPressed: (){
            Get.to(() => const Step3Marital());
          },
          progressEnd: 4,
          progressStart: 2
        ),
      ),
    );
  }
}
