import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/helpers/variables/global_variables.dart';
import 'package:tridentpro/src/views/accounts/step_4_emergency_contact.dart';

import 'components/step_position.dart';

class Step5InvestmentGoal extends StatefulWidget {
  const Step5InvestmentGoal({super.key});

  @override
  State<Step5InvestmentGoal> createState() => _Step5InvestmentGoal();
}

class _Step5InvestmentGoal extends State<Step5InvestmentGoal> {

  RxInt _selectedValue = 1.obs;

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
        body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          itemCount: GlobalVariable.investmentGoal.length,
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
                title: Text(GlobalVariable.investmentGoal[index]),
                value: index + 1,
                groupValue: _selectedValue.value,
                onChanged: (value) {
                  _selectedValue(value);
                },
              ),
            ),
          );
        },),
        // Padding(
        //   padding: const EdgeInsets.all(20.0),
        //   child: SizedBox(
        //     width: double.infinity,
        //     height: double.maxFinite,
        //     child: Wrap(
        //       crossAxisAlignment: WrapCrossAlignment.start,
        //       direction: Axis.vertical,
        //       alignment: WrapAlignment.start,
        //       children: List.generate(GlobalVariable.investmentGoal.length, (i){
        //         // return Chip(
        //         //   elevation: 3,
        //         //   onDeleted: (){
        //         //     print("Deleted");
        //         //   },
        //         //   surfaceTintColor: CustomColor.defaultSoftColor,
        //         //   color: WidgetStatePropertyAll(CustomColor.defaultColor),
        //         //   shape: StadiumBorder(),
        //         //   label: Text(GlobalVariable.investmentGoal[i], style: GoogleFonts.inter()));
        //       }),
        //     ),
        //   ),
        // ),
        bottomNavigationBar: StepUtilities.stepOnlineRegister(
          size: size,
          title: "Investment Goal",
          onPressed: (){
            Get.to(() => const Step4EmergencyContact());
          },
          progressEnd: 8,
          currentAllPageStatus: 2,
          progressStart: 1
        ),
      ),
    );
  }
}
