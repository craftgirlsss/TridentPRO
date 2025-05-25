import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/alerts/default.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/bottomsheets/material_bottom_sheets.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/containers/utilities.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/components/textfields/descriptive_textfield.dart';
import 'package:tridentpro/src/components/textfields/name_textfield.dart';
import 'package:tridentpro/src/components/textfields/number_textfield.dart';
import 'package:tridentpro/src/components/textfields/phone_textfield.dart';
import 'package:tridentpro/src/components/textfields/void_textfield.dart';
import 'package:tridentpro/src/controllers/regol.dart';
import 'package:tridentpro/src/helpers/variables/global_variables.dart';
import 'package:tridentpro/src/views/accounts/step_12_bank_information.dart';
import 'package:tridentpro/src/views/mainpage.dart';
import 'components/step_position.dart';

class Step11JobHistory extends StatefulWidget {
  const Step11JobHistory({super.key});

  @override
  State<Step11JobHistory> createState() => _Step11JobHistory();
}

class _Step11JobHistory extends State<Step11JobHistory> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController categoryBusinessNameController = TextEditingController();
  TextEditingController yourJobCategoryController = TextEditingController();
  TextEditingController jobPositionController = TextEditingController();
  TextEditingController durationOfWorkController = TextEditingController();
  TextEditingController durationOfLastWorkController = TextEditingController();
  TextEditingController currentAddressOffice = TextEditingController();
  TextEditingController officePhoneContact = TextEditingController();
  TextEditingController faxController = TextEditingController();

  RegolController regolController = Get.find();

  @override
  void dispose() {
    businessNameController.dispose();
    categoryBusinessNameController.dispose();
    yourJobCategoryController.dispose();
    jobPositionController.dispose();
    durationOfWorkController.dispose();
    durationOfLastWorkController.dispose();
    officePhoneContact.dispose();
    faxController.dispose();
    currentAddressOffice.dispose();
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
            title: "Job Information",
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
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                UtilitiesWidget.titleContent(
                    title: "Job Information",
                    subtitle: "Tell me a little about your current job",
                    children: [
                      VoidTextField(controller: yourJobCategoryController, fieldName: "Your Current Job", hintText: "Your Current Job", labelText: "Your Current Job", onPressed: () async {
                        CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Choose your current job", children: List.generate(GlobalVariable.jobListIndo.length, (i){
                          return ListTile(
                            onTap: (){
                              Navigator.pop(context);
                              yourJobCategoryController.text = GlobalVariable.jobListIndo[i];
                            },
                            title: Text(GlobalVariable.jobListIndo[i], style: GoogleFonts.inter()),
                          );
                        }));
                      }),
                      NameTextField(controller: businessNameController, fieldName: "Company Name", hintText: "Company Name", labelText: "Company Name"),
                      NameTextField(controller: categoryBusinessNameController, fieldName: "Bidang Usaha", hintText: "Input nama bidang usaha", labelText: "Nama Bidang Usaha"),
                      NameTextField(controller: jobPositionController, fieldName: "Job Position", hintText: "Job Position", labelText: "Job Position"),
                      NumberTextField(controller: durationOfWorkController, fieldName: "Lama Bekerja", hintText: "Lama Bekerja", labelText: "Lama Bekerja", maxLength: 0),
                      DescriptiveTextField(controller: currentAddressOffice, fieldName: "Current Address Office", hintText: "Current Address Office", labelText: "Current Address Office"),
                      PhoneTextField(controller: officePhoneContact, fieldName: "Office Phone Contact", hintText: "Office Phone Contact", labelText: "Office Phone Contact (Optional)"),
                      PhoneTextField(controller: faxController, fieldName: "Office Fax", hintText: "Office Fax", labelText: "Office Fax (Optional)"),
                    ]
                ),
                UtilitiesWidget.titleContent(
                  title: "Last Job Information",
                  subtitle: "Tell me a little about your last job",
                  children: [
                    NumberTextField(controller: durationOfLastWorkController, fieldName: "Lama Bekerja", hintText: "Lama Bekerja", labelText: "Lama Bekerja", maxLength: 0),
                  ]
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Obx(
          () => StepUtilities.stepOnlineRegister(
            size: size,
            title: regolController.isLoading.value ? "Uploading..." : "Your Job Experience",
            onPressed: regolController.isLoading.value ? null : (){
              if(_formKey.currentState!.validate()){
                regolController.postStepEight(
                  companyName: businessNameController.text,
                  position: yourJobCategoryController.text,
                  address: currentAddressOffice.text,
                  jobName: categoryBusinessNameController.text,
                  longTime: durationOfWorkController.text,
                  longTimeOldJob: durationOfLastWorkController.text,
                  bidangUsaha: categoryBusinessNameController.text
                ).then((result){
                  if(result){
                    Get.to(() => const Step12BankInformation());
                  }else{
                    CustomAlert.alertError(message: regolController.responseMessage.value);
                  }
                });
              }
            },
            progressEnd: 4,
            currentAllPageStatus: 3,
            progressStart: 1
          ),
        ),
      ),
    );
  }
}