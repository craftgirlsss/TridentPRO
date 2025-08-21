import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/alerts/default.dart';
import 'package:tridentpro/src/components/alerts/scaffold_messanger_alert.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/containers/utilities.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/components/textfields/descriptive_textfield.dart';
import 'package:tridentpro/src/components/textfields/money_textfields.dart';
import 'package:tridentpro/src/controllers/regol.dart';
import 'package:tridentpro/src/helpers/variables/global_variables.dart';
import 'package:tridentpro/src/views/accounts/step_11_job_history.dart';
import 'package:tridentpro/src/views/mainpage.dart';
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
  RegolController regolController = Get.find();
  RxString selectedIncome = "Antara 100-250 juta".obs;
  RxInt selectedValue = 1.obs;
  RxString rawValueNJOP = "".obs;
  RxString rawValueDeposito = "".obs;
  RxString rawValueLainnya = "".obs;
  RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    lokasiRumah.text = regolController.accountModel.value?.kekayaan_rumah_lokasi ?? "";
    nilaiNJOP.text = regolController.accountModel.value?.kekayaan_njop ?? "";
    depositoBank.text = regolController.accountModel.value?.kekayaan_deposit ?? "";
    lainnya.text = regolController.accountModel.value?.kekayaan_lain ?? "";
    rawValueDeposito.value = depositoBank.text;
    rawValueLainnya.value = lainnya.text;
    rawValueNJOP.value = nilaiNJOP.text;
  }

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
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar.defaultAppBar(
          autoImplyLeading: true,
          title: "Investment",
          actions: [
            CupertinoButton(
              onPressed: (){
                CustomAlert.alertDialogCustomInfo(
                  title: "Confirmation",
                  message: "Are you sure you want to cancel? All data will be lost.",
                  moreThanOneButton: true,
                  onTap: () {
                    Get.offAll(() => const Mainpage());
                  },
                  textButton: "Yes",
                );
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
                child: Text("Annual Income Range?", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                itemCount: GlobalVariable.incomePerYearIndo.length,
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
                        title: Text(GlobalVariable.incomePerYearIndo[index]),
                        value: index + 1,
                        groupValue: selectedValue.value,
                        onChanged: (value) {
                          switch(value){
                            case 1:
                              selectedIncome("Antara 100-250 juta");
                            case 2:
                              selectedIncome("Antara 250-500 juta");
                            case 3:
                              selectedIncome("500 juta");
                            default:
                              selectedIncome("-");
                          }
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
                    Obx(
                      () => isLoading.value ? const SizedBox() : TextFormFieldMoney(controller: nilaiNJOP,moneyType: MoneyType.idr, useValidator: true, label: "Nilai NJOP", hint: "Input Nilai NJOP",  labelText: "Nilai NJOP", onRawValueChanged: (val) {
                        rawValueNJOP.value = val; // contoh hasil: "1250000"
                        debugPrint("Nilai mentah: ${rawValueNJOP.value}");
                      },),
                    ),
                    Obx(
                      () => isLoading.value ? const SizedBox() : TextFormFieldMoney(controller: depositoBank, moneyType: MoneyType.idr, useValidator: true, label: "Deposito Bank", hint: "Input Deposito Bank",  labelText: "Deposito Bank", onRawValueChanged: (val) {
                        rawValueDeposito.value = val; // contoh hasil: "1250000"
                        debugPrint("Nilai mentah: ${rawValueDeposito.value}");
                      },),
                    ),
                    Obx(
                      () => isLoading.value ? const SizedBox() : TextFormFieldMoney(controller: lainnya, moneyType: MoneyType.idr, useValidator: true, label: "Lainnya (Optional)", hint: "Input Lainnya (Optional)",  labelText: "Lainnya (Optional)", onRawValueChanged: (val) {
                        rawValueLainnya.value = val; // contoh hasil: "1250000"
                        debugPrint("Nilai mentah: ${rawValueLainnya.value}");
                      },),
                    ),
                  ]
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: Obx(
          () => StepUtilities.stepOnlineRegister(
            size: size,
            title: regolController.isLoading.value ? "Loading..." : "Annual Income Range",
            onPressed: regolController.isLoading.value ? null : (){
              regolController.postKekayaan(
                annualIncome: selectedIncome.value,
                deposito: rawValueDeposito.value,
                lainnya: rawValueLainnya.value,
                lokasiRumah: lokasiRumah.text,
                njop: rawValueNJOP.value,
              ).then((result){
                if(result){
                  Get.to(() => const Step11JobHistory());
                }else{
                  CustomScaffoldMessanger.showAppSnackBar(context, message: regolController.responseMessage.value, type: SnackBarType.error);
                }
              });
            },
            progressEnd: 4,
            currentAllPageStatus: 2,
            progressStart: 4
          ),
        ),
      ),
    );
  }
}
