import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/helpers/variables/global_variables.dart';
import 'package:tridentpro/src/views/accounts/step_8_income_range.dart';
import 'package:tridentpro/src/views/mainpage.dart';

import 'components/step_position.dart';

class Step7BalanceSources extends StatefulWidget {
  const Step7BalanceSources({super.key});

  @override
  State<Step7BalanceSources> createState() => _Step7BalanceSources();
}

class _Step7BalanceSources extends State<Step7BalanceSources> {

  RxInt selectedValue = 1.obs;

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
                child: Text("Where Do The Funds For Your Investment Come From?", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                itemCount: GlobalVariable.balanceSources.length,
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
                        title: Text(GlobalVariable.balanceSources[index]),
                        value: index + 1,
                        groupValue: selectedValue.value,
                        onChanged: (value) {
                          selectedValue(value);
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: StepUtilities.stepOnlineRegister(
          size: size,
          title: "Balance Sources",
          onPressed: (){
            Get.to(() => const Step8IncomeRange());
          },
          progressEnd: 6,
          currentAllPageStatus: 2,
          progressStart: 3
        ),
      ),
    );
  }
}
