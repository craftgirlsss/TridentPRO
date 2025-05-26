import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tridentpro/src/components/alerts/default.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/bottomsheets/material_bottom_sheets.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/containers/utilities.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/components/painters/loading_water.dart';
import 'package:tridentpro/src/components/textfields/descriptive_textfield.dart';
import 'package:tridentpro/src/components/textfields/number_textfield.dart';
import 'package:tridentpro/src/components/textfields/void_textfield.dart';
import 'package:tridentpro/src/controllers/2_factory_auth.dart';
import 'package:tridentpro/src/controllers/regol.dart';
import 'package:tridentpro/src/controllers/utilities.dart';
import 'package:tridentpro/src/helpers/handlers/image_picker.dart';
import 'package:tridentpro/src/views/accounts/components/checklist_statement.dart';
import 'package:tridentpro/src/views/accounts/step_3_marital.dart';
import 'components/step_position.dart';

class Step18PrenyataanSimulasi extends StatefulWidget {
  const Step18PrenyataanSimulasi({super.key});

  @override
  State<Step18PrenyataanSimulasi> createState() => _Step18PrenyataanSimulasiState();
}

class _Step18PrenyataanSimulasiState extends State<Step18PrenyataanSimulasi> {

  UtilitiesController utilitiesController = Get.put(UtilitiesController());
  final _formKey = GlobalKey<FormState>();
  TextEditingController provinceController = TextEditingController();
  TextEditingController kabupatenController = TextEditingController();
  TextEditingController kecamatanController = TextEditingController();
  TextEditingController desaController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController rtController = TextEditingController();
  TextEditingController rwController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  RegolController regolController = Get.put(RegolController());
  TwoFactoryAuth twoFactoryAuth = Get.find();

  RxString simulasiAkunDemoURL = "".obs;
  RxBool isLoading = false.obs;
  RxBool selectedStatement = true.obs;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      regolController.isLoading(true);
      rtController.text = regolController.accountModel.value?.rt ?? '-';
      rwController.text = regolController.accountModel.value?.rw ?? '-';
      await utilitiesController.getProvinceAPI().then((result) async {
        if(!result){
          CustomAlert.alertError(message: utilitiesController.responseMessage.value);
          return false;
        }
        if(regolController.accountModel.value?.province != null){
          provinceController.text = regolController.accountModel.value?.province ?? "-";
          utilitiesController.selectedProvinceID(base64Encode(utf8.encode(regolController.accountModel.value!.province!)));
          await utilitiesController.getKabupatenAPI().then((resultKabupaten) async {
            if(!resultKabupaten){
              return false;
            }

            if(regolController.accountModel.value?.city != null){
              kabupatenController.text = regolController.accountModel.value?.city ?? "";
              utilitiesController.selectedKabupatenID(base64Encode(utf8.encode(regolController.accountModel.value!.city!)));
              await utilitiesController.getKecamatanAPI().then((resultKecamatan) async {
                if(!resultKecamatan){
                  return false;
                }

                if(regolController.accountModel.value?.district != null){
                  kecamatanController.text = regolController.accountModel.value?.district ?? "";
                  utilitiesController.selectedKecamatanID(base64Encode(utf8.encode(regolController.accountModel.value!.district!)));
                  await utilitiesController.getDesaAPI().then((resultDesa){
                    if(!resultDesa){
                      return false;
                    }
                    desaController.text = regolController.accountModel.value?.village ?? "";
                    zipController.text = regolController.accountModel.value?.postalCode ?? '-';
                  });
                }
              });
            }
          });
        }
      });
      regolController.isLoading(false);
    });
  }

  @override
  void dispose() {
    provinceController.dispose();
    kabupatenController.dispose();
    kecamatanController.dispose();
    desaController.dispose();
    zipController.dispose();
    rtController.dispose();
    rwController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: CustomAppBar.defaultAppBar(
              autoImplyLeading: true,
              title: LanguageGlobalVar.PERSONAL_INFORMATION.tr,
              actions: [
                CupertinoButton(
                  onPressed: () async {
                    print(regolController.accountModel.value?.province);
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    // String? results = prefs.getString('accessToken');
                    // print(results);
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
                      title: "Informasi Alamat",
                      subtitle: "Isi semua form yang ada dibawah ini untuk dapat melanjutkan proses pembuatan akun real.",
                      children: [
                        // Province
                        VoidTextField(controller: provinceController, fieldName: "Provinsi", hintText: "Provinsi", labelText: "Provinsi", onPressed: (){
                          CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Pilih Provinsi Anda", children: List.generate(utilitiesController.provinceModelAPI.value?.response?.length ?? 0, (i){
                            return ListTile(
                              title: Text(utilitiesController.provinceModelAPI.value?.response?[i].name ?? "-", style: GoogleFonts.inter()),
                              onTap: (){
                                Navigator.pop(context);
                                provinceController.text = utilitiesController.provinceModelAPI.value?.response?[i].name ?? "-";
                                utilitiesController.selectedProvinceID(utilitiesController.provinceModelAPI.value?.response?[i].code);
                                utilitiesController.getKabupatenAPI().then((result){
                                  if(result){
                                    kabupatenController.text = utilitiesController.kabupatenModelAPI.value?.response?[0].name ?? "-";
                                  }
                                });
                              },
                            );
                          }));
                        }),

                        // Kabupaten
                        // Obx(
                        //   () => utilitiesController.selectedProvinceID.value == "" ? const SizedBox() :
                          VoidTextField(controller: kabupatenController, fieldName: "Kabupaten", hintText: "Kabupaten", labelText: "Kabupaten", onPressed: (){
                            CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Pilih Kabupaten Anda", children: List.generate(utilitiesController.kabupatenModelAPI.value?.response?.length ?? 0, (i){
                              return ListTile(
                                title: Text(utilitiesController.kabupatenModelAPI.value?.response?[i].name ?? "-", style: GoogleFonts.inter()),
                                onTap: (){
                                  Navigator.pop(context);
                                  kabupatenController.text = utilitiesController.kabupatenModelAPI.value?.response?[i].name ?? "-";
                                  utilitiesController.selectedKabupatenID(utilitiesController.kabupatenModelAPI.value?.response?[i].code);
                                  utilitiesController.getKecamatanAPI().then((result){
                                    if(result){
                                      kecamatanController.text = utilitiesController.kecamatanModelAPI.value?.response?[0].name ?? "-";
                                    }
                                  });
                                },
                              );
                            }));
                          }),
                        // ),


                        // Kecamatan
                        // Obx(
                        //   () => utilitiesController.selectedKabupatenID.value == "" ? const SizedBox() :
                          VoidTextField(controller: kecamatanController, fieldName: "Kecamatan", hintText: "Kecamatan", labelText: "Kecamatan", onPressed: (){
                            CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Pilih Kecamatan Anda", children: List.generate(utilitiesController.kecamatanModelAPI.value?.response?.length ?? 0, (i){
                              return ListTile(
                                title: Text(utilitiesController.kecamatanModelAPI.value?.response?[i].name ?? "-", style: GoogleFonts.inter()),
                                onTap: (){
                                  Navigator.pop(context);
                                  kecamatanController.text = utilitiesController.kecamatanModelAPI.value?.response?[i].name ?? "-";
                                  utilitiesController.selectedKecamatanID(utilitiesController.kecamatanModelAPI.value?.response?[i].code);
                                  utilitiesController.getDesaAPI().then((result){
                                    if(result){
                                      desaController.text = utilitiesController.desaModelAPI.value?.response?[0].village ?? "-";
                                    }
                                  });
                                },
                              );
                            }));
                          }),
                        // ),

                        // Desa
                        // Obx(
                        //   () => utilitiesController.selectedKecamatanID.value == "" ? const SizedBox() :
                          VoidTextField(controller: desaController, fieldName: "Desa", hintText: "Desa", labelText: "Desa", onPressed: (){
                            CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Pilih Desa Anda", children: List.generate(utilitiesController.desaModelAPI.value?.response?.length ?? 0, (i){
                              return ListTile(
                                title: Text(utilitiesController.desaModelAPI.value?.response?[i].village ?? "-", style: GoogleFonts.inter()),
                                onTap: (){
                                  Navigator.pop(context);
                                  desaController.text = utilitiesController.desaModelAPI.value?.response?[i].village ?? "-";
                                  utilitiesController.selectedDesaID(utilitiesController.desaModelAPI.value?.response?[i].code);
                                  zipController.text = utilitiesController.desaModelAPI.value?.response?[i].postalCode ?? "0";
                                },
                              );
                            }));
                          }),
                        // ),
                        // Obx(() => utilitiesController.selectedDesaID.value == "" ? const SizedBox() :
                        NumberTextField(controller: zipController, hintText: "Kode Pos", labelText: "Kode Pos", maxLength: 4, fieldName: "Alamat Lengkap"),
                        // ),
                        // Obx(
                        //   () => utilitiesController.selectedDesaID.value == "" ? const SizedBox() :
                          Row(
                            children: [
                              Expanded(child: NumberTextField(controller: rtController, hintText: "RT", labelText: "RT", maxLength: 1, fieldName: "RT")),
                              const SizedBox(width: 10.0),
                              Expanded(child: NumberTextField(controller: rwController, hintText: "RW", labelText: "RW", maxLength: 1, fieldName: "RW",)),
                            ],
                          ),
                        // ),

                        // Obx(() => utilitiesController.selectedDesaID.value == "" ? const SizedBox() :
                        DescriptiveTextField(controller: addressController, hintText: "Alamat Lengkap", labelText: "Alamat Lengkap", fieldName: "Alamat Lengkap")
        // ),
                      ]
                    ),

                    UtilitiesWidget.titleContent(
                      title: "Pernyataan Simulasi",
                      subtitle: "Unggah foto simulasi penggunaan akun DEMO yang telah anda buat.",
                      children: [
                        Obx(
                          () => isLoading.value ? const SizedBox() : UtilitiesWidget.uploadPhoto(title: "Simulasi Akun Demo", onPressed: () async {
                            simulasiAkunDemoURL(await CustomImagePicker.pickImageFromCameraAndReturnUrl());
                          }, urlPhoto: simulasiAkunDemoURL.value),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Dengan mengisi kolom “YA” di bawah ini, saya menyatakan bahwa semua informasi dan semua dokumen yang saya lampirkan dalam APLIKASI PEMBUKAAN REKENING TRANSAKSI SECARA ELEKTRONIK ONLINE adalah benar dan tepat, Saya akan bertanggung jawab penuh apabila dikemudian hari terjadi sesuatu hal sehubungan dengan ketidakbenaran data yang saya berikan.", textAlign: TextAlign.justify, style: GoogleFonts.inter(color: Colors.black54)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Obx(
                                  () => Row(
                                    children: [
                                      Checkbox(
                                        fillColor: WidgetStatePropertyAll(Colors.white),
                                        checkColor: CustomColor.defaultColor,
                                        side: WidgetStateBorderSide.resolveWith((Set<MaterialState> states) {
                                          if (states.contains(MaterialState.selected)) {
                                            return const BorderSide(color: Colors.black45); // tetap tampil meski dicentang
                                          }
                                          return const BorderSide(color: Colors.black45); // tidak dicentang
                                        }),
                                        value: selectedStatement.value == true ? true : false,
                                        onChanged: (value) => selectedStatement.value = !selectedStatement.value,
                                      ),

                                      Text("YA")
                                    ],
                                  ),
                                ),
                                Obx(
                                  () => Row(
                                    children: [
                                      Checkbox(
                                        fillColor: WidgetStatePropertyAll(Colors.white),
                                        checkColor: CustomColor.defaultColor,
                                        side: WidgetStateBorderSide.resolveWith((Set<MaterialState> states) {
                                          if (states.contains(WidgetState.selected)) {
                                            return const BorderSide(color: Colors.black45); // tetap tampil meski dicentang
                                          }
                                          return const BorderSide(color: Colors.black45); // tidak dicentang
                                        }),
                                        value: selectedStatement.value == false ? true : false,
                                        onChanged: (value) => selectedStatement.value = !selectedStatement.value,
                                      ),
                                      Text("TIDAK")
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ]
                    )
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Obx(
              () => StepUtilities.stepOnlineRegister(
                size: size,
                title: LanguageGlobalVar.VERIFICATION_IDENTITY.tr,
                onPressed: regolController.isLoading.value ? null : (){
                  print(zipController.text);
                  print(provinceController.text);
                  if(_formKey.currentState!.validate()){
                    regolController.postStepNinePernyataanSimulasi(
                      urlPhoto: simulasiAkunDemoURL.value,
                      appAddress: addressController.text,
                      appAgree: selectedStatement.value == true ? "ya" : "tidak",
                      appCity: kabupatenController.text,
                      appDistrict: kecamatanController.text,
                      appProvince: provinceController.text,
                      appRT: rtController.text,
                      appRW: rwController.text,
                      appVillage: desaController.text,
                      appZipcode: zipController.text
                    ).then((result){
                      if(!result){
                        CustomAlert.alertError(message: regolController.responseMessage.value);
                        return false;
                      }
                      Get.to(() => const Step3Marital());
                    });
                  }
                },
                progressEnd: 4,
                progressStart: 1
              ),
            ),
          ),
        ),
        Obx(() => regolController.isLoading.value ? LoadingWater() : const SizedBox())
      ],
    );
  }
}
