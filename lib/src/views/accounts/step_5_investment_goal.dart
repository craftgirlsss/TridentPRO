import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/alerts/default.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/controllers/regol.dart';
import 'package:tridentpro/src/helpers/variables/global_variables.dart';
import 'package:tridentpro/src/views/accounts/step_19_familly_bappebti.dart';
import 'package:tridentpro/src/views/mainpage.dart';

import 'components/step_position.dart';

class Step5InvestmentGoal extends StatefulWidget {
  const Step5InvestmentGoal({super.key});

  @override
  State<Step5InvestmentGoal> createState() => _Step5InvestmentGoal();
}

class _Step5InvestmentGoal extends State<Step5InvestmentGoal> {

  RegolController regolController = Get.find();
  RxInt selectedValue = 1.obs;
  RxString selectedName = "".obs;

  int setInvestGoals({String? name}){
    switch(name){
      case "lindung nilai":
        selectedName(GlobalVariable.investmentGoalIndonesia[0]);
        return selectedValue(1);
      case "gain":
        selectedName(GlobalVariable.investmentGoalIndonesia[1]);
        return selectedValue(2);
      case "spekulasi":
        selectedName(GlobalVariable.investmentGoalIndonesia[2]);
        return selectedValue(3);
      case "lainnya":
        selectedName(GlobalVariable.investmentGoalIndonesia[3]);
        return selectedValue(4);
      default:
        return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    setInvestGoals(name: regolController.accountModel.value?.tujuan_investasi);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar.defaultAppBar(
            autoImplyLeading: true,
            title: "Investment",
            actions: [
              CupertinoButton(
                onPressed: (){
                  Get.offAll(() => const Mainpage());
                },
                child: Text(LanguageGlobalVar.CANCEL.tr, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: CustomColor.defaultColor)),
              )
            ]
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("What Is Your Main Goal of Investing?", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                itemCount: GlobalVariable.investmentGoalIndonesia.length,
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
                      title: Text(GlobalVariable.investmentGoalIndonesia[index]),
                      value: index + 1,
                      groupValue: selectedValue.value,
                      onChanged: (value) {
                        selectedValue(value);
                        selectedName(GlobalVariable.investmentGoalIndonesia[index]);
                      },
                    ),
                  ),
                );
              },),
            ],
          ),
        ),
        bottomNavigationBar: Obx(
          () => StepUtilities.stepOnlineRegister(
            size: size,
            title: regolController.isLoading.value ? "Uploading..." : "Investment Goal",
            onPressed: regolController.isLoading.value ? null : (){
              regolController.postStepFive(investmentGoal: selectedName.value).then((result){
                if(result){
                  Get.to(() => Step19FamilyBappebti());
                }else{
                  CustomAlert.alertError(message: regolController.responseMessage.value);
                }
              });
            },
            progressEnd: 4,
            currentAllPageStatus: 2,
            progressStart: 1
          ),
        ),
      ),
    );
  }
}
