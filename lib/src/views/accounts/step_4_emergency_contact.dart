import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/bottomsheets/material_bottom_sheets.dart';
import 'package:tridentpro/src/components/buttons/elevated_button.dart';
import 'package:tridentpro/src/components/containers/utilities.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/components/textfields/descriptive_textfield.dart';
import 'package:tridentpro/src/components/textfields/name_textfield.dart';
import 'package:tridentpro/src/components/textfields/phone_textfield.dart';
import 'package:tridentpro/src/components/textfields/void_textfield.dart';
import 'package:tridentpro/src/helpers/variables/countries.dart';
import 'package:tridentpro/src/helpers/variables/global_variables.dart';

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

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    relationController.dispose();
    phoneController.dispose();
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
                    title: "Emergency Contact Information",
                    subtitle: "Please select and fill all emergency information details",
                    children: [
                      NameTextField(controller: nameController, fieldName: "Name", hintText: "Input emergency contact name", labelText: "Name"),
                      VoidTextField(controller: relationController, fieldName: "Relation Status", hintText: "Relation Status", labelText: "Relation Status", onPressed: () async {
                        CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Choose your Nationaly", children: List.generate(GlobalVariable.relation.length, (i){
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
                      VoidTextField(controller: countryController, fieldName: "Nationaly Emergency Contact", hintText: "Nationaly Emergency Contact", labelText: "Nationaly Emergency Contact", onPressed: () async {
                        CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Choose Emergency Contact Nationaly", children: List.generate(countryList.length, (i){
                          return ListTile(
                            onTap: (){
                              Navigator.pop(context);
                              countryController.text = countryList[i].name;
                            },
                            title: Text(countryList[i].name, style: GoogleFonts.inter()),
                          );
                        }));
                      }),
                    ]
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: DefaultButton.defaultElevatedButton(
              onPressed: (){
                if(_formKey.currentState!.validate()){

                }else{

                }
              },
              title: LanguageGlobalVar.SELANJUTNYA.tr
          ),
        ),
      ),
    );
  }
}
