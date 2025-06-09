import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tridentpro/src/components/alerts/default.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/bottomsheets/material_bottom_sheets.dart';
import 'package:tridentpro/src/components/buttons/outlined_button.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/containers/utilities.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/components/textfields/name_textfield.dart';
import 'package:tridentpro/src/components/textfields/number_textfield.dart';
import 'package:tridentpro/src/components/textfields/phone_textfield.dart';
import 'package:tridentpro/src/components/textfields/void_textfield.dart';
import 'package:tridentpro/src/controllers/setting.dart';
import 'package:tridentpro/src/helpers/handlers/json_file_reader.dart';
import 'package:tridentpro/src/helpers/variables/countrycurrency.dart';
import 'package:tridentpro/src/helpers/variables/global_variables.dart';
import 'package:tridentpro/src/views/accounts/step_17_dokumen_pendukung.dart';
import 'package:tridentpro/src/views/mainpage.dart';
import 'components/step_position.dart';

class Step12BankInformation extends StatefulWidget {
  const Step12BankInformation({super.key});

  @override
  State<Step12BankInformation> createState() => _Step12BankInformation();
}

class _Step12BankInformation extends State<Step12BankInformation> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController currencyController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController rootController = TextEditingController();
  TextEditingController jenisRekening = TextEditingController();
  TextEditingController nomorRekening = TextEditingController();

  TextEditingController currencyController2 = TextEditingController();
  TextEditingController bankNameController2 = TextEditingController();
  TextEditingController cityController2 = TextEditingController();
  TextEditingController rootController2 = TextEditingController();
  TextEditingController jenisRekening2 = TextEditingController();
  TextEditingController nomorRekening2 = TextEditingController();
  SettingController settingController = Get.put(SettingController());
  RxBool addedBank = false.obs;

  List<Map<dynamic, dynamic>> resultBank = [];

  @override
  void initState() {
    super.initState();
    readJsonFile('assets/json/bank.json').then((result){
      resultBank = result;
      settingController.getUserBank().then((result){
        if(!result){
          CustomAlert.alertError(message: settingController.responseMessage.value);
          return;
        }
        if(settingController.userBankModel.value?.response != null || settingController.userBankModel.value?.response?.length != 0){
          bankNameController.text = settingController.userBankModel.value?.response?[0].name ?? "";
          rootController.text = settingController.userBankModel.value?.response?[0].branch ?? "";
          jenisRekening.text = settingController.userBankModel.value?.response?[0].type ?? "";
          nomorRekening.text = settingController.userBankModel.value?.response?[0].account ?? "";
          if(settingController.userBankModel.value!.response!.length > 1){
            bankNameController2.text = settingController.userBankModel.value?.response?[1].name ?? "";
            rootController2.text = settingController.userBankModel.value?.response?[1].branch ?? "";
            jenisRekening2.text = settingController.userBankModel.value?.response?[1].type ?? "";
            nomorRekening2.text = settingController.userBankModel.value?.response?[1].account ?? "";
          }
        }
      });
    });
  }

  @override
  void dispose() {
    currencyController.dispose();
    bankNameController.dispose();
    cityController.dispose();
    rootController.dispose();
    jenisRekening.dispose();
    nomorRekening.dispose();

    currencyController2.dispose();
    bankNameController2.dispose();
    cityController2.dispose();
    rootController2.dispose();
    jenisRekening2.dispose();
    nomorRekening2.dispose();
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
          title: "Bank Information",
          actions: [
            CupertinoButton(
              onPressed: () async {
                Get.offAll(() => const Mainpage());
              },
              child: Text(LanguageGlobalVar.CANCEL.tr, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: CustomColor.defaultColor)),
            )
          ]
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    UtilitiesWidget.titleContent(
                      title: "Bank Information",
                      subtitle: "Please give the bank account details on your name that will be used with withdrawal of funds",
                      children: [
                        VoidTextField(controller: currencyController, fieldName: "Currency Type", hintText: "Currency Type", labelText: "Currency Type", onPressed: () async {
                          CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Choose your bank currency type", children: List.generate(currencyCodes.length, (i){
                            return ListTile(
                              onTap: (){
                                Navigator.pop(context);
                                currencyController.text = currencyCodes[i].code;
                              },
                              title: Text("${currencyCodes[i].code} - ${currencyCodes[i].name}", style: GoogleFonts.inter()),
                            );
                          }));
                        }),
                        VoidTextField(controller: bankNameController, fieldName: "Bank Name", hintText: "Bank Name", labelText: "Bank Name", onPressed: () async {
                          CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Choose your bank currency type", children: List.generate(resultBank.length, (i){
                            return ListTile(
                              onTap: (){
                                Navigator.pop(context);
                                bankNameController.text = resultBank[i]['Name'];
                              },
                              title: Text("${resultBank[i]['Name']}", style: GoogleFonts.inter()),
                            );
                          }));
                        }),
                        NameTextField(controller: cityController, fieldName: "City", hintText: "City", labelText: "City"),
                        NameTextField(controller: rootController, fieldName: "Cabang", hintText: "Cabang", labelText: "Cabang", useValidator: false),
                        VoidTextField(controller: jenisRekening, fieldName: "Jenis Rekening", hintText: "Jenis Rekening", labelText: "Jenis Rekening", onPressed: () async {
                          CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Choose your saving bank type", children: List.generate(GlobalVariable.jenisTabungan.length, (i){
                            return ListTile(
                              onTap: (){
                                Navigator.pop(context);
                                jenisRekening.text = GlobalVariable.jenisTabungan[i];
                              },
                              title: Text(GlobalVariable.jenisTabungan[i], style: GoogleFonts.inter()),
                            );
                          }));
                        }),
                        NumberTextField(controller: nomorRekening, fieldName: "Nomor Rekening", hintText: "Nomor Rekening", labelText: "Nomor Rekening", useValidator: false),
                        SizedBox(
                          height: 40,
                          width: size.width / 1.7,
                          child: Obx(
                            () => CustomOutlinedButton.defaultOutlinedButton(
                              onPressed: (){
                                addedBank.value = !addedBank.value;
                              },
                              title: addedBank.value ? "Hapus Bank" : "Tambah Informasi Bank"
                            ),
                          ),
                        ),
                      ]
                    ),
                  ],
                ),
              ),

              Obx(() => addedBank.value ? addBank(size,
                bankNameController2: bankNameController2,
                cityController2: cityController2,
                currencyController2: currencyController2,
                jenisRekening2: jenisRekening2,
                nomorRekening2: nomorRekening2,
                rootController2: rootController2,
              ) : const SizedBox())
            ],
          ),
        ),
        bottomNavigationBar: Obx(
          () => StepUtilities.stepOnlineRegister(
            size: size,
            title: settingController.isLoading.value ? null : "Bank Information",
            onPressed: settingController.isLoading.value ? null : (){
              Get.to(() => const Step17UploadPhoto());
            },
            progressEnd: 4,
            currentAllPageStatus: 3,
            progressStart: 2
          ),
        ),
      ),
    );
  }

  Widget addBank(Size size, {TextEditingController? currencyController2, TextEditingController? bankNameController2, TextEditingController? cityController2, TextEditingController? rootController2, TextEditingController? jenisRekening2, TextEditingController? nomorRekening2}){
    return UtilitiesWidget.titleContent(
      title: "Bank Information",
      subtitle: "Please give the bank account details on your name that will be used with withdrawal of funds",
      children: [
        VoidTextField(controller: currencyController2, fieldName: "Currency Type", hintText: "Currency Type", labelText: "Currency Type", onPressed: () async {
          CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Choose your bank currency type", children: List.generate(currencyCodes.length, (i){
            return ListTile(
              onTap: (){
                Navigator.pop(context);
                currencyController2!.text = currencyCodes[i].code;
              },
              title: Text("${currencyCodes[i].code} - ${currencyCodes[i].name}", style: GoogleFonts.inter()),
            );
          }));
        }),
        VoidTextField(controller: bankNameController2, fieldName: "Bank Name", hintText: "Bank Name", labelText: "Bank Name", onPressed: () async {
          CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Choose your bank currency type", children: List.generate(resultBank.length, (i){
            return ListTile(
              onTap: (){
                Navigator.pop(context);
                bankNameController2!.text = resultBank[i]['Name'];
              },
              title: Text("${resultBank[i]['Name']}", style: GoogleFonts.inter()),
            );
          }));
        }),
        NameTextField(controller: cityController2, fieldName: "City", hintText: "City", labelText: "City"),
        NameTextField(controller: rootController2, fieldName: "Cabang", hintText: "Cabang", labelText: "Cabang"),
        VoidTextField(controller: jenisRekening2, fieldName: "Jenis Rekening", hintText: "Jenis Rekening", labelText: "Jenis Rekening", onPressed: () async {
          CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Choose your saving bank type", children: List.generate(GlobalVariable.jenisTabungan.length, (i){
            return ListTile(
              onTap: (){
                Navigator.pop(context);
                jenisRekening2!.text = GlobalVariable.jenisTabungan[i];
              },
              title: Text(GlobalVariable.jenisTabungan[i], style: GoogleFonts.inter()),
            );
          }));
        }),
        PhoneTextField(controller: nomorRekening2, fieldName: "Nomor Rekening", hintText: "Nomor Rekening", labelText: "Nomor Rekening"),
      ]
    );
  }
}

