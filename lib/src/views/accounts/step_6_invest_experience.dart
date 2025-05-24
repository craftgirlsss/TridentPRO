import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:tridentpro/src/components/alerts/default.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/containers/utilities.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/components/textfields/name_textfield.dart';
import 'package:tridentpro/src/controllers/regol.dart';
import 'package:tridentpro/src/helpers/variables/global_variables.dart';
import 'package:tridentpro/src/views/accounts/step_7_balance_sources.dart';
import 'package:tridentpro/src/views/accounts/step_8_income_range.dart';

import 'components/step_position.dart';

class Step6InvestmentExperience extends StatefulWidget {
  const Step6InvestmentExperience({super.key});

  @override
  State<Step6InvestmentExperience> createState() => _Step6InvestmentExperience();
}

class _Step6InvestmentExperience extends State<Step6InvestmentExperience> {

  RxInt selectedValue = 1.obs;
  RxBool showBrokerName = true.obs;
  TextEditingController companyNameController = TextEditingController();
  RegolController regolController = Get.find();

  @override
  void dispose() {
    companyNameController.dispose();
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
          title: "Investment",
          actions: [
            CupertinoButton(
              onPressed: (){},
              child: Text(LanguageGlobalVar.CANCEL.tr, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            )
          ]
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Apakah anda pernah berinvestasi sebelumnya?", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                itemCount: GlobalVariable.investExperienceIndo.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Obx(
                      () => RadioListTile(
                        enableFeedback: true,
                        toggleable: false,
                        selected: false,
                        selectedTileColor: CustomColor.defaultColor,
                        shape: StadiumBorder(
                          side: BorderSide(color: CustomColor.defaultColor)
                        ),
                        title: Text(GlobalVariable.investExperienceIndo[index]),
                        value: index + 1,
                        groupValue: selectedValue.value,
                        onChanged: (value) {
                          print(value);
                          selectedValue(value);
                          if(index == 0){
                            showBrokerName(true);
                          }else{
                            showBrokerName(false);
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
              Obx(
                () => showBrokerName.value ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: UtilitiesWidget.titleContent(
                    title: "Nama Perusahaan Pialang",
                    subtitle: "Inputkan nama perusahaan pialang yang pernah anda gunakan jasa nya.",
                    children: [
                      NameTextField(controller: companyNameController, fieldName: "Nama Perusahaan", hintText: "Nama Perusahaan", labelText: "Nama Perusahaan"),
                    ]
                  ),
                ) : const SizedBox(),
              )
            ],
          ),
        ),
        bottomNavigationBar: Obx(
          () => StepUtilities.stepOnlineRegister(
            size: size,
            title: regolController.isLoading.value ? "Uploading..." : "Investment Experience",
            onPressed: regolController.isLoading.value ? null : (){
              print(showBrokerName);
              print(selectedValue.value);
              print(GlobalVariable.investExperienceIndo[selectedValue.value-1]);
              if(showBrokerName.value){
                if(companyNameController.text == "" || companyNameController.length == 0){
                  CustomAlert.alertError(message: "Mohon nama perusahaan diisi");
                }else{
                  regolController.postStepSix(companyName: companyNameController.text, experience: GlobalVariable.investExperienceIndo[selectedValue.value-1].toLowerCase()).then((result){
                    if(result){
                      // Get.to(() => const Step7BalanceSources());
                      Get.to(() => const Step8IncomeRange());
                    }else{
                      CustomAlert.alertError(message: regolController.responseMessage.value);
                    }
                  });
                }
              }else{
                regolController.postStepSix(companyName: companyNameController.text, experience: GlobalVariable.investExperienceIndo[selectedValue.value-1].toLowerCase()).then((result){
                  if(result){
                    // Get.to(() => const Step7BalanceSources());
                    Get.to(() => const Step8IncomeRange());
                  }else{
                    CustomAlert.alertError(message: regolController.responseMessage.value);
                  }
                });
              }
            },
            progressEnd: 3,
            currentAllPageStatus: 2,
            progressStart: 2
          ),
        ),
      ),
    );
  }
}
