import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/alerts/default.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/bottomsheets/material_bottom_sheets.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/containers/utilities.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/components/textfields/descriptive_textfield.dart';
import 'package:tridentpro/src/components/textfields/name_textfield.dart';
import 'package:tridentpro/src/components/textfields/number_textfield.dart';
import 'package:tridentpro/src/components/textfields/phone_textfield.dart';
import 'package:tridentpro/src/components/textfields/void_textfield.dart';
import 'package:tridentpro/src/controllers/regol.dart';
import 'package:tridentpro/src/controllers/utilities.dart';
import 'package:tridentpro/src/helpers/variables/global_variables.dart';
import 'package:tridentpro/src/views/accounts/step_5_investment_goal.dart';

import 'components/step_position.dart';

class Step4EmergencyContact extends StatefulWidget {
  const Step4EmergencyContact({super.key});

  @override
  State<Step4EmergencyContact> createState() => _Step4EmergencyContact();
}

class _Step4EmergencyContact extends State<Step4EmergencyContact> {

  TextEditingController nameController = TextEditingController();
  TextEditingController relationController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController provinceController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipController = TextEditingController();

  RxBool showProvince = true.obs;
  RxBool showCity = false.obs;
  RxBool showVillage = false.obs;
  RxBool isIndonesia = true.obs;

  UtilitiesController utilitiesController = Get.put(UtilitiesController());
  RegolController regolController = Get.find();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController.text = regolController.accountModel.value?.drrtName ?? "";
    relationController.text = regolController.accountModel.value?.drrtStatus ?? "";
    phoneController.text = regolController.accountModel.value?.drrtPhone ?? "";
    addressController.text = regolController.accountModel.value?.drrtAddress ?? "";
    zipController.text = regolController.accountModel.value?.drrtPostalCode ?? "-";
  }

  @override
  void dispose() {
    nameController.dispose();
    relationController.dispose();
    phoneController.dispose();
    zipController.dispose();
    addressController.dispose();
    countryController.dispose();
    provinceController.dispose();
    cityController.dispose();
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
                child: Text(LanguageGlobalVar.CANCEL.tr, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: CustomColor.defaultColor)),
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
                    title: "Emergency Contact Information",
                    subtitle: "Please select and fill all emergency information details",
                    children: [
                      NameTextField(controller: nameController, fieldName: "Name", hintText: "Input emergency contact name", labelText: "Name"),
                      VoidTextField(controller: relationController, fieldName: "Relation Status", hintText: "Relation Status", labelText: "Relation Status", onPressed: () async {
                        CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Choose your Relation Status", children: List.generate(GlobalVariable.relation.length, (i){
                          return ListTile(
                            onTap: (){
                              Navigator.pop(context);
                              relationController.text = GlobalVariable.relation[i];
                            },
                            title: Text(GlobalVariable.relation[i], style: GoogleFonts.inter()),
                          );
                        }));
                      }),
                      PhoneTextField(controller: phoneController, fieldName: "Emergency Contact Phone Number", hintText: "Emergency Contact Phone Number", labelText: "Emergency Contact Phone Number"),
                      DescriptiveTextField(controller: addressController, fieldName: "Emergency Contact Address", hintText: "Emergency Contact Address", labelText: "Emergency Contact Address"),

                      // // Country
                      // Obx(
                      //   () => VoidTextField(controller: countryController, fieldName: utilitiesController.isLoading.value ? "Getting Country" : "Nationaly Emergency Contact", hintText: "Nationaly Emergency Contact", labelText:  utilitiesController.isLoading.value ? "Getting Country..." : "Nationaly Emergency Contact", onPressed: () async {
                      //     CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Choose Emergency Contact Nationaly", children: List.generate(utilitiesController.countryModels.value?.data.length ?? 0, (i){
                      //       return ListTile(
                      //         onTap: (){
                      //           Navigator.pop(context);
                      //           countryController.text = utilitiesController.countryModels.value?.data[i].name ?? "Unknown Name";
                      //           utilitiesController.selectedCountry(countryController.text);
                      //           showProvince(true);
                      //           showCity(false);
                      //           provinceController.clear();
                      //           cityController.clear();
                      //           countryController.text == "Indonesia" || countryController.text == "indonesia" ? isIndonesia(true) : isIndonesia(false);
                      //         },
                      //         title: Text(utilitiesController.countryModels.value?.data[i].name ?? "Unknonwn Country Name", style: GoogleFonts.inter()),
                      //       );
                      //     }));
                      //   }),
                      // ),
                      NumberTextField(controller: zipController, fieldName: "Zip Code", hintText: "Input Zip Code", labelText: "Zip Code", maxLength: 4),
                    ]
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Obx(
          () => StepUtilities.stepOnlineRegister(
            size: size,
            title: regolController.isLoading.value ? "Uploading..." : "Emergency Contact",
            onPressed: regolController.isLoading.value ? null : (){
              if(_formKey.currentState!.validate()){
                regolController.postStepFour(
                  emergencyAddress: addressController.text,
                  emergencyContact: phoneController.text,
                  emergencyName: nameController.text,
                  emergencyRelation: relationController.text,
                  postalCode: zipController.text
                ).then((result){
                  if(result){
                    Get.to(() => const Step5InvestmentGoal());
                  }else{
                    CustomAlert.alertError(message: regolController.responseMessage.value);
                  }
                });
              }
            },
            progressEnd: 4,
            progressStart: 4
          ),
        ),
      ),
    );
  }
}
