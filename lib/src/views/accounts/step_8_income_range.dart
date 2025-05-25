import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/containers/utilities.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/components/textfields/descriptive_textfield.dart';
import 'package:tridentpro/src/components/textfields/number_textfield.dart';
import 'package:tridentpro/src/helpers/variables/global_variables.dart';
import 'package:tridentpro/src/views/accounts/step_11_job_history.dart';
import 'components/step_position.dart';

class Step8IncomeRange extends StatefulWidget {
  const Step8IncomeRange({super.key});

  @override
  State<Step8IncomeRange> createState() => _Step8IncomeRange();
}

class _Step8IncomeRange extends State<Step8IncomeRange> {

  TextEditingController lokasiRumah = TextEditingController();
  TextEditingController nilaiNJOP = TextEditingController();
  TextEditingController depositoBank = TextEditingController();
  TextEditingController lainnya = TextEditingController();

  RxInt selectedValue = 1.obs;

  @override
  void dispose() {
    lokasiRumah.dispose();
    nilaiNJOP.dispose();
    depositoBank.dispose();
    lainnya.dispose();
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
                child: Text("Annual Income Range?", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                itemCount: GlobalVariable.incomePerYear.length,
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
                        title: Text(GlobalVariable.incomePerYear[index]),
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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: UtilitiesWidget.titleContent(
                  title: "Daftar Kekayaan",
                  subtitle: "Input semua daftar kekayaan yang anda miliki",
                  children: [
                    DescriptiveTextField(
                      controller: lokasiRumah,
                      labelText: "Lokasi Rumah",
                      hintText: "Input Lokasi Rumah",
                    ),
                    NumberTextField(controller: nilaiNJOP, fieldName: "Nilai NJOP", hintText: "Nilai NJOP", labelText: "Nilai NJOP"),
                    NumberTextField(controller: depositoBank, fieldName: "Deposito Bank", hintText: "Deposito Bank", labelText: "Deposito Bank"),
                    NumberTextField(controller: nilaiNJOP, fieldName: "Lainnya (Optional)", hintText: "Lainnya (Optional)", labelText: "Lainnya (Optional)"),
                  ]
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: StepUtilities.stepOnlineRegister(
          size: size,
          title: "Annual Income Range",
          onPressed: (){
            Get.to(() => const Step11JobHistory());
          },
          progressEnd: 3,
          currentAllPageStatus: 2,
          progressStart: 3
        ),
      ),
    );
  }
}
