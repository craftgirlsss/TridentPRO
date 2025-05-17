import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/bottomsheets/material_bottom_sheets.dart';
import 'package:tridentpro/src/components/containers/utilities.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/components/textfields/descriptive_textfield.dart';
import 'package:tridentpro/src/components/textfields/name_textfield.dart';
import 'package:tridentpro/src/components/textfields/phone_textfield.dart';
import 'package:tridentpro/src/components/textfields/void_textfield.dart';
import 'package:tridentpro/src/helpers/handlers/json_file_reader.dart';
import 'package:tridentpro/src/helpers/variables/countrycurrency.dart';
import 'package:tridentpro/src/helpers/variables/global_variables.dart';
import 'package:tridentpro/src/views/accounts/step_12_bank_information.dart';
import 'package:tridentpro/src/views/accounts/step_13_perselisihan.dart';
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

  List<Map<dynamic, dynamic>> resultBank = [];

  @override
  void initState() {
    super.initState();
    readJsonFile('assets/json/bank.json').then((result){
      resultBank = result;
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
            title: "Bank Information",
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
                      NameTextField(controller: rootController, fieldName: "Cabang", hintText: "Cabang", labelText: "Cabang"),
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
                      PhoneTextField(controller: nomorRekening, fieldName: "Nomor Rekening", hintText: "Nomor Rekening", labelText: "Nomor Rekening"),
                    ]
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: StepUtilities.stepOnlineRegister(
          size: size,
          title: "Bank Information",
          onPressed: (){
            Get.to(() => const Step13PenyelesaianPerselisihan());
          },
          progressEnd: 4,
          currentAllPageStatus: 3,
          progressStart: 2
        ),
      ),
    );
  }
}

