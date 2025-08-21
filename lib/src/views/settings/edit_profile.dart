import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:tridentpro/src/components/alerts/default.dart';
import 'package:tridentpro/src/components/alerts/scaffold_messanger_alert.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/bottomsheets/material_bottom_sheets.dart';
import 'package:tridentpro/src/components/buttons/outlined_button.dart';
import 'package:tridentpro/src/components/containers/utilities.dart';
import 'package:tridentpro/src/components/textfields/descriptive_textfield.dart';
import 'package:tridentpro/src/components/textfields/email_textfield.dart';
import 'package:tridentpro/src/components/textfields/name_textfield.dart';
import 'package:tridentpro/src/components/textfields/number_textfield.dart';
import 'package:tridentpro/src/components/textfields/phone_textfield.dart';
import 'package:tridentpro/src/components/textfields/void_textfield.dart';
import 'package:tridentpro/src/controllers/home.dart';
import 'package:tridentpro/src/controllers/user_controller.dart';
import 'package:tridentpro/src/helpers/handlers/date_pickers.dart';

import 'bank_page.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  UserController userController = Get.put(UserController());

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController jenisKelamin = TextEditingController();
  TextEditingController tempatLahir = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController kabupatenController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController tanggalLahir = TextEditingController();
  HomeController homeController = Get.find();
  RxString selectedDateBirth = "".obs;
  RxBool isLoading = false.obs;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await userController.getProfile().then((resultGet) {
        if (resultGet) {
          setState(() {
            jenisKelamin.text = userController.profileModel.value?.gender ?? "-";
            nameController.text = userController.profileModel.value?.name ?? "";
            phoneController.text = userController.profileModel.value?.phone ?? "";
            emailController.text = userController.profileModel.value?.email ?? "";
            addressController.text = userController.profileModel.value?.address ?? "";
            countryController.text = userController.profileModel.value?.country ?? "";
            zipController.text = userController.profileModel.value?.zip ?? "";
            tanggalLahir.text = userController.profileModel.value?.tglLahir ?? "";
            tempatLahir.text = userController.profileModel.value?.tmptLahir ?? "";
            addressController.text = userController.profileModel.value?.address ?? "";
          });
        }
      });
    });
  }

  @override
  void dispose() {
    jenisKelamin.dispose();
    tempatLahir.dispose();
    tanggalLahir.dispose();
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    emailController.dispose();
    kabupatenController.dispose();
    countryController.dispose();
    zipController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: CustomAppBar.defaultAppBar(
          title: "Edit Profilku",
          autoImplyLeading: true,
          actions: [
            SizedBox(
              height: 30,
              child: Obx(
                () => CustomOutlinedButton.defaultOutlinedButton(
                  title: userController.isLoading.value ? "Processing..." : "Simpan",
                  onPressed: userController.isLoading.value ? null : () async {
                    if(_formKey.currentState!.validate()){
                      if(jenisKelamin.text == "Laki-laki") jenisKelamin.text = "laki-laki";
                      if(jenisKelamin.text == "Perempuan") jenisKelamin.text = "perempuan";
                      userController.updateProfile(
                        address: addressController.text,
                        gender: jenisKelamin.text,
                        dateOfBirth: selectedDateBirth.value == "" ? tanggalLahir.text : selectedDateBirth.value,
                        placeOfBirth: tempatLahir.text,
                        country: countryController.text,
                        fullname: nameController.text,
                        zipcode: zipController.text
                      ).then((result){
                        if(result){
                          userController.getProfile().then((resultGet){
                            print(resultGet);
                            if(resultGet){
                              setState(() {
                                jenisKelamin.text = userController.profileModel.value?.gender ?? "-";
                                nameController.text = userController.profileModel.value?.name ?? "";
                                phoneController.text = userController.profileModel.value?.phone ?? "";
                                emailController.text = userController.profileModel.value?.email ?? "";
                                addressController.text = userController.profileModel.value?.address ?? "";
                                countryController.text = userController.profileModel.value?.country ?? "";
                                zipController.text = userController.profileModel.value?.zip ?? "";
                                tanggalLahir.text = userController.profileModel.value?.tglLahir ?? "";
                                tempatLahir.text = userController.profileModel.value?.tmptLahir ?? "";
                                addressController.text = userController.profileModel.value?.address ?? "";
                              });
                            }
                          });
                          CustomAlert.alertDialogCustomSuccess(onTap: (){
                            Get.back();
                          }, message: userController.responseMessage.value, title: "Berhasil", textButton: "Kembali");
                        }else{
                          CustomAlert.alertError(onTap: (){Get.back();}, message: userController.responseMessage.value, title: "Gagal");
                        }
                      });
                    }else{
                      CustomScaffoldMessanger.showAppSnackBar(context, message: "Form tidak boleh kosong");
                    }
                  }
                ),
              ),
            ),
            const SizedBox(width: 10)
          ]
        ),
        body: Obx(
          () => RefreshIndicator(
            onRefresh: isLoading.value ? ()async{} : () async {
              await userController.getProfile().then((resultGet){
                if(resultGet){
                  jenisKelamin.text = userController.profileModel.value?.gender ?? "-";
                  nameController.text = userController.profileModel.value?.name ?? "";
                  phoneController.text = userController.profileModel.value?.phone ?? "";
                  emailController.text = userController.profileModel.value?.email ?? "";
                  addressController.text = userController.profileModel.value?.address ?? "";
                  countryController.text = userController.profileModel.value?.country ?? "";
                  zipController.text = userController.profileModel.value?.zip ?? "";
                  tanggalLahir.text = userController.profileModel.value?.tglLahir ?? "";
                  tempatLahir.text = userController.profileModel.value?.tmptLahir ?? "";
                  addressController.text = userController.profileModel.value?.address ?? "";
                }
              });
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: UtilitiesWidget.titleContent(
                  title: "Edit Profile Saya",
                  subtitle: "Mohon untuk penuhi semua field profile anda agar anda bisa melakukan pembuatan akun trading",
                  children: [
                    NameTextField(controller: nameController, fieldName: "Nama Lengkap", hintText: "Nama Lengkap Saya", labelText: "Nama Lengkap Saya", useValidator: false),
                    EmailTextField(controller: emailController, fieldName: "Alamat Email", hintText: "Alamat Email", labelText: "Alamat Email", readOnly: true, useValidator: false),
                    PhoneTextField(controller: phoneController, fieldName: "Nomor WhatsApp", hintText: "Nomor WhatsApp", labelText: "Nomor WhatsApp", useValidator: false),
                    VoidTextField(controller: jenisKelamin, fieldName: "Jenis Kelamin", hintText: "Jenis Kelamin", labelText: "Jenis Kelamin", iconData: Bootstrap.gender_ambiguous, onPressed: () async {
                      CustomMaterialBottomSheets.defaultBottomSheet(context, isScrolledController: false, size: size, title: "Pilih jenis kelamin", children: List.generate(2, (i){
                        if(i == 0){
                          return ListTile(
                            onTap: (){
                              Navigator.pop(context);
                              jenisKelamin.text = "Laki-laki";
                            },
                            title: Text("Laki-laki", style: GoogleFonts.inter()),
                          );
                        }
                        return ListTile(
                          onTap: (){
                            Navigator.pop(context);
                            jenisKelamin.text = "Perempuan";
                          },
                          title: Text("Perempuan", style: GoogleFonts.inter()),
                        );
                      }));
                    }),
                    VoidTextField(iconData: Clarity.calendar_line, controller: tanggalLahir, fieldName: "Tanggal Lahir", hintText: "Tanggal Lahir", labelText: "Tanggal Lahir", onPressed: () async {
                      DateTime? selected;
                      selected = await CustomDatePicker.material(context);
                      if(selected != null){
                        tanggalLahir.text = CustomDatePicker.formatIndonesiaDate(selected);
                        selectedDateBirth(DateFormat('yyyy-MM-dd').format(selected));
                      }
                    }),
                    NameTextField(controller: tempatLahir, fieldName: "Tempat Lahir", hintText: "Tempat Lahir", labelText: "Tempat Lahir", useValidator: false, iconData: CupertinoIcons.placemark),
                    DescriptiveTextField(controller: addressController, fieldName: "Alamat Lengkap", hintText: "Alamat Lengkap Saya", labelText: "Alamat Lengkap Saya", useValidator: false, iconData: CupertinoIcons.placemark,),
                    NameTextField(controller: countryController, fieldName: "Country", hintText: "Country", labelText: "Country", useValidator: false, iconData: Icons.flag_outlined),
                    NumberTextField(controller: zipController, fieldName: "Kode Pos", hintText: "Kode Pos", labelText: "Kode Pos", maxLength: 4, useValidator: false),
                    SizedBox(
                      width: double.infinity,
                      child: CustomOutlinedButton.defaultOutlinedButton(
                        onPressed: (){
                          Get.to(() => const MyBankPage());
                        },
                        title: "Edit Bank Profil Saya"
                      ),
                    ),
                    const SizedBox(height: 40.0),
                  ]
                ),
              )
            ),
          ),
        ),
      ),
    );
  }
}
