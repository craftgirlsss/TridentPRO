import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/buttons/outlined_button.dart';
import 'package:tridentpro/src/components/containers/utilities.dart';
import 'package:tridentpro/src/components/textfields/descriptive_textfield.dart';
import 'package:tridentpro/src/components/textfields/email_textfield.dart';
import 'package:tridentpro/src/components/textfields/name_textfield.dart';
import 'package:tridentpro/src/components/textfields/number_textfield.dart';
import 'package:tridentpro/src/components/textfields/phone_textfield.dart';
import 'package:tridentpro/src/controllers/home.dart';

import 'bank_page.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController kabupatenController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  HomeController homeController = Get.find();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      setState(() {
        nameController.text = homeController.profileModel.value?.name ?? "";
        phoneController.text = homeController.profileModel.value?.phone ?? "";
        emailController.text = homeController.profileModel.value?.email ?? "";
        addressController.text = homeController.profileModel.value?.address ?? "";
        countryController.text = homeController.profileModel.value?.country ?? "";
        zipController.text = homeController.profileModel.value?.zip ?? "";
      });
    });
  }

  @override
  void dispose() {
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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: CustomAppBar.defaultAppBar(
          title: "Edit Profilku",
          autoImplyLeading: true,
          actions: [
            SizedBox(
              height: 30,
              child: CustomOutlinedButton.defaultOutlinedButton(
                title: "Simpan",
                onPressed: (){}
              ),
            ),
            const SizedBox(width: 10)
          ]
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              UtilitiesWidget.titleContent(
                title: "Edit Profile Saya",
                subtitle: "Mohon untuk penuhi semua field profile anda agar anda bisa melakukan pembuatan akun trading",
                children: [
                  NameTextField(controller: nameController, fieldName: "Nama Lengkap", hintText: "Nama Lengkap Saya", labelText: "Nama Lengkap Saya"),
                  EmailTextField(controller: emailController, fieldName: "Alamat Email", hintText: "Alamat Email", labelText: "Alamat Email"),
                  PhoneTextField(controller: phoneController, fieldName: "Nomor WhatsApp", hintText: "Nomor WhatsApp", labelText: "Nomor WhatsApp"),
                  DescriptiveTextField(controller: addressController, fieldName: "Alamat Lengkap", hintText: "Alamat Lengkap Saya", labelText: "Alamat Lengkap Saya"),
                  NameTextField(controller: countryController, fieldName: "Country", hintText: "Country", labelText: "Country"),
                  NumberTextField(controller: zipController, fieldName: "Kode Pos", hintText: "Kode Pos", labelText: "Kode Pos", maxLength: 4),
                  SizedBox(
                    width: double.infinity,
                    child: CustomOutlinedButton.defaultOutlinedButton(
                      onPressed: (){
                        Get.to(() => const MyBankPage());
                      },
                      title: "Edit Bank Profil Saya"
                    ),
                  )
                ]
              )
            ],
          ),
        ),
      ),
    );
  }
}
