import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/bottomsheets/material_bottom_sheets.dart';
import 'package:tridentpro/src/components/buttons/elevated_button.dart';
import 'package:tridentpro/src/components/containers/utilities.dart';
import 'package:tridentpro/src/components/dates/material_datepicker.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/components/textfields/email_textfield.dart';
import 'package:tridentpro/src/components/textfields/name_textfield.dart';
import 'package:tridentpro/src/components/textfields/phone_textfield.dart';
import 'package:tridentpro/src/components/textfields/void_textfield.dart';
import 'package:tridentpro/src/helpers/variables/global_variables.dart';

class Step2StoredData extends StatefulWidget {
  const Step2StoredData({super.key});

  @override
  State<Step2StoredData> createState() => _Step2StoredData();
}

class _Step2StoredData extends State<Step2StoredData> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController idTypeController = TextEditingController();
  TextEditingController idNumberController = TextEditingController();
  TextEditingController taxController = TextEditingController();
  TextEditingController dateBirthController = TextEditingController();
  TextEditingController placeBirthController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    idTypeController.dispose();
    idNumberController.dispose();
    taxController.dispose();
    dateBirthController.dispose();
    placeBirthController.dispose();
    genderController.dispose();
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
                  title: "Data Profile",
                  subtitle: "Please fill all your account details",
                  children: [
                    NameTextField(controller: nameController, fieldName: "Name", hintText: "Input your name", labelText: "Full Name"),
                    EmailTextField(controller: emailController, fieldName: "Email", hintText: "Input your email address", labelText: "Email Address"),
                    PhoneTextField(controller: phoneController, fieldName: "Phone", hintText: "+62", labelText: "Phone Number"),
                  ]
                ),

                UtilitiesWidget.titleContent(
                    title: "Personal Information",
                    subtitle: "Please fill all your personal details",
                    children: [
                      PhoneTextField(controller: idNumberController, fieldName: "ID Type Number", hintText: "ID Type Number", labelText: "ID Type Number"),
                      PhoneTextField(controller: taxController, fieldName: "Tax Number", hintText: "Tax Number", labelText: "Tax Number"),
                      VoidTextField(controller: dateBirthController, fieldName: "Date Birth", hintText: "Date Birth", labelText: "Date Birth", onPressed: () async {
                        var result = await CustomMaterialDatePicker.selectDate(context);
                        dateBirthController.text = result ?? "";
                      }),
                      NameTextField(controller: placeBirthController, fieldName: "Place Birth", hintText: "Place Birth", labelText: "Place Birth"),
                      VoidTextField(controller: genderController, fieldName: "Gender", hintText: "Gender", labelText: "Gender", onPressed: (){
                        CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, isScrolledController: false, title: "Please choose your gender", children: List.generate(GlobalVariable.gender.length, (i){
                          return ListTile(
                            title: Text(GlobalVariable.gender[i], style: GoogleFonts.inter()),
                            onTap: (){
                              Navigator.pop(context);
                              genderController.text = GlobalVariable.gender[i];
                            },
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
