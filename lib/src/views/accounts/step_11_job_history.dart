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
  void initState() {
    super.initState();
    yourJobCategoryController.text = regolController.accountModel.value?.kerja_tipe ?? "";
    businessNameController.text = regolController.accountModel.value?.kerja_nama ?? "";
    categoryBusinessNameController.text = regolController.accountModel.value?.kerja_bidang ?? "";
    jobPositionController.text = regolController.accountModel.value?.kerja_jabatan ?? "";
    durationOfWorkController.text = regolController.accountModel.value?.kerja_lama ?? "";
    currentAddressOffice.text = regolController.accountModel.value?.kerja_alamat ?? "";
    officePhoneContact.text = regolController.accountModel.value?.kerja_telepon ?? "";
    faxController.text = regolController.accountModel.value?.kerja_fax ?? "";
    durationOfLastWorkController.text = regolController.accountModel.value?.kerja_lama_sebelum ?? "";
  }

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
        resizeToAvoidBottomInset: true,
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
                  title: "Informasi Pekerjaan",
                  subtitle: "Beri tahu kami tentang pekerjaan anda.",
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
                    NameTextField(controller: businessNameController, fieldName: "Nama Perusahaan", hintText: "Nama Perusahaan", labelText: "Nama Perusahaan"),
                    NameTextField(controller: categoryBusinessNameController, fieldName: "Bidang Usaha", hintText: "Input nama bidang usaha", labelText: "Nama Bidang Usaha"),
                    NameTextField(controller: jobPositionController, fieldName: "Job Position", hintText: "Job Position", labelText: "Job Position"),
                    NameTextField(controller: durationOfWorkController, fieldName: "Lama Bekerja", hintText: "Lama Bekerja", labelText: "Lama Bekerja"),
                    DescriptiveTextField(controller: currentAddressOffice, fieldName: "Alamat Pekerjaan Saat Ini", hintText: "Alamat Pekerjaan Saat Ini", labelText: "Alamat Pekerjaan Saat Ini"),
                    PhoneTextField(controller: officePhoneContact, fieldName: "Office Phone Contact", hintText: "Office Phone Contact", labelText: "Office Phone Contact (Optional)", useValidator: false),
                    PhoneTextField(controller: faxController, fieldName: "Office Fax", hintText: "Office Fax", labelText: "Office Fax (Optional)", useValidator: false),
                  ]
                ),
                UtilitiesWidget.titleContent(
                  title: "Last Job Information",
                  subtitle: "Tell me a little about your last job",
                  children: [
                    NameTextField(controller: durationOfLastWorkController, fieldName: "Lama Bekerja", hintText: "Lama Bekerja", labelText: "Lama Bekerja"),
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
                  namaPekerjaan: yourJobCategoryController.text,
                  namaPerusahaan: businessNameController.text,
                  bidangUsaha: categoryBusinessNameController.text,
                  jabatanPekerjaan: durationOfWorkController.text,
                  lamaBekerja: durationOfWorkController.text,
                  alamatKantor: currentAddressOffice.text,
                  lamaBekerjaSebelumnya: durationOfLastWorkController.text,
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