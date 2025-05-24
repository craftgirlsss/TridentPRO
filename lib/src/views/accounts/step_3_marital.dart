import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/alerts/default.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/bottomsheets/material_bottom_sheets.dart';
import 'package:tridentpro/src/components/containers/utilities.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/components/painters/loading_water.dart';
import 'package:tridentpro/src/components/textfields/name_textfield.dart';
import 'package:tridentpro/src/components/textfields/phone_textfield.dart';
import 'package:tridentpro/src/components/textfields/void_textfield.dart';
import 'package:tridentpro/src/controllers/regol.dart';
import 'package:tridentpro/src/helpers/variables/global_variables.dart';
import 'package:tridentpro/src/views/accounts/step_4_emergency_contact.dart';

import 'components/step_position.dart';

class Step3Marital extends StatefulWidget {
  const Step3Marital({super.key});

  @override
  State<Step3Marital> createState() => _Step3Marital();
}

class _Step3Marital extends State<Step3Marital> {

  TextEditingController maritalStatusController = TextEditingController();
  TextEditingController motherNameController = TextEditingController();
  TextEditingController wifeHusbandName = TextEditingController();
  TextEditingController phoneHomeController = TextEditingController();
  TextEditingController faxController = TextEditingController();
  RxBool showNameWifeOrHusband = false.obs;
  final _formKey = GlobalKey<FormState>();

  // Init Class Controller Trading
  RegolController regolController = Get.find();


  @override
  void dispose() {
    maritalStatusController.dispose();
    motherNameController.dispose();
    phoneHomeController.dispose();
    wifeHusbandName.dispose();
    faxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        GestureDetector(
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
                      title: "Marital Status",
                      subtitle: "Please select information details",
                      children: [
                        VoidTextField(controller: maritalStatusController, fieldName: "Marital Status", hintText: "Marital Status", labelText: "Marital Status", onPressed: () async {
                          CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, isScrolledController: true, title: "Please choose your marital status", children: List.generate(GlobalVariable.maritalIndoVersion.length, (i){
                            return ListTile(
                              title: Text(GlobalVariable.maritalIndoVersion[i], style: GoogleFonts.inter()),
                              onTap: (){
                                Navigator.pop(context);
                                maritalStatusController.text = GlobalVariable.maritalIndoVersion[i];
                                if(maritalStatusController.text == "Kawin"){
                                  showNameWifeOrHusband(true);
                                }else{
                                  showNameWifeOrHusband(false);
                                }
                              }
                            );
                          }));
                        }),
                        Obx(() => showNameWifeOrHusband.value ? NameTextField(controller: wifeHusbandName, fieldName: "Wife or Husband Name", hintText: "Wife or Husband Name", labelText: "Wife or Husband Name") : const SizedBox()),
                      ]
                    ),
                    UtilitiesWidget.titleContent(
                      title: "Other Information",
                      subtitle: "Please fill all your family information details",
                      children: [
                        NameTextField(controller: motherNameController, fieldName: "Mother Name", hintText: "Input your mother name", labelText: "Mother Name"),
                        PhoneTextField(controller: phoneHomeController, fieldName: "Phone Home", hintText: "Phone Home", labelText: "Phone Home"),
                        PhoneTextField(controller: faxController, fieldName: "Fax Number", hintText: "Fax Number", labelText: "Fax Number"),
                      ]
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: StepUtilities.stepOnlineRegister(
              size: size,
              title: "Marital Status",
              onPressed: (){
                if(_formKey.currentState!.validate()){
                  regolController.postStepThree(faxNumber: faxController.text, maritalStatus: maritalStatusController.text, motherName: motherNameController.text, phoneHome: phoneHomeController.text, wifeName: wifeHusbandName.text).then((result){
                    if(result){
                      Get.to(() => const Step4EmergencyContact());
                    }
                  });
                }else{
                  CustomAlert.alertError(message: regolController.responseMessage.value);
                }
              },
              progressEnd: 4,
              progressStart: 3
            ),
          ),
        ),
        Obx(() => regolController.isLoading.value ? LoadingWater() : const SizedBox())
      ],
    );
  }
}
