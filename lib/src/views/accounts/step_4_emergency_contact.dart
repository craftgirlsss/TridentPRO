import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/alerts/default.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/bottomsheets/material_bottom_sheets.dart';
import 'package:tridentpro/src/components/containers/utilities.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/components/textfields/descriptive_textfield.dart';
import 'package:tridentpro/src/components/textfields/name_textfield.dart';
import 'package:tridentpro/src/components/textfields/phone_textfield.dart';
import 'package:tridentpro/src/components/textfields/void_textfield.dart';
import 'package:tridentpro/src/controllers/utilities.dart';
import 'package:tridentpro/src/helpers/variables/global_variables.dart';
import 'package:tridentpro/src/views/accounts/step_5_investment_goal.dart';

import 'components/step_position.dart';

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
  TextEditingController zipController = TextEditingController();

  RxBool showProvince = false.obs;
  RxBool showCity = false.obs;
  RxBool isIndonesia = false.obs;

  UtilitiesController utilitiesController = Get.put(UtilitiesController());

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    utilitiesController.getCountry().then((result){
      if(!result){
        CustomAlert.alertError(
          message: utilitiesController.responseMessage.value,
          onTap: (){ Get.back(); }
        );
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    relationController.dispose();
    phoneController.dispose();
    zipController.dispose();
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
                        CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Choose your Relation Status", children: List.generate(GlobalVariable.relation.length, (i){
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

                      // Country
                      Obx(
                        () => VoidTextField(controller: countryController, fieldName: utilitiesController.isLoading.value ? "Getting Country" : "Nationaly Emergency Contact", hintText: "Nationaly Emergency Contact", labelText:  utilitiesController.isLoading.value ? "Getting Country..." : "Nationaly Emergency Contact", onPressed: () async {
                          CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Choose Emergency Contact Nationaly", children: List.generate(utilitiesController.countryModels.value?.data.length ?? 0, (i){
                            return ListTile(
                              onTap: (){
                                Navigator.pop(context);
                                countryController.text = utilitiesController.countryModels.value?.data[i].name ?? "Unknown Name";
                                utilitiesController.selectedCountry(countryController.text);
                                showProvince(true);
                                showCity(false);
                                provinceController.clear();
                                cityController.clear();
                                countryController.text == "Indonesia" || countryController.text == "indonesia" ? isIndonesia(true) : isIndonesia(false);
                              },
                              title: Text(utilitiesController.countryModels.value?.data[i].name ?? "Unknonwn Country Name", style: GoogleFonts.inter()),
                            );
                          }));
                        }),
                      ),

                      // Province
                      Obx(
                        () => showProvince.value ? VoidTextField(controller: provinceController, fieldName: "Province", hintText: "Select Province Emergency Contact", labelText: utilitiesController.isLoadingProvince.value ? "Getting Province..." : "Select Province", onPressed: () async {
                          if(isIndonesia.value){
                            utilitiesController.getProvinceRaja().then((result){
                              if(result){
                                CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Choose Emergency Contact Province", children: List.generate(utilitiesController.provinceRajaModels.value?.rajaongkir.results?.length ?? 0, (i){
                                  return ListTile(
                                    onTap: (){
                                      Navigator.pop(context);
                                      provinceController.text = utilitiesController.provinceRajaModels.value?.rajaongkir.results?[i].province ?? "Unknown Province Name";
                                      utilitiesController.selectedProvince(utilitiesController.provinceRajaModels.value?.rajaongkir.results?[i].provinceId);
                                      showCity(true);
                                      cityController.clear();
                                    },
                                    title: Text(utilitiesController.provinceRajaModels.value?.rajaongkir.results?[i].province ?? "Unknown Province Name", style: GoogleFonts.inter()),
                                  );
                                }));
                              }else{
                                CustomAlert.alertError(
                                  onTap: (){ Get.back(); },
                                  message: utilitiesController.responseMessage.value
                                );
                              }
                            });
                          }else{
                            utilitiesController.getProvince(countryName: utilitiesController.selectedCountry.value).then((result){
                              if(result){
                                CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Choose Emergency Contact Province", children: List.generate(utilitiesController.provinceModels.value?.data.states?.length ?? 0, (i){
                                  return ListTile(
                                    onTap: (){
                                      Navigator.pop(context);
                                      provinceController.text = utilitiesController.provinceModels.value?.data.states?[i].name ?? "Unknown Province Name";
                                      utilitiesController.selectedProvince(provinceController.text);
                                      showCity(true);
                                      cityController.clear();
                                    },
                                    title: Text(utilitiesController.provinceModels.value?.data.states?[i].name ?? "Unknown Province Name", style: GoogleFonts.inter()),
                                  );
                                }));
                              }else{
                                CustomAlert.alertError(
                                  onTap: (){ Get.back(); },
                                  message: utilitiesController.responseMessage.value
                                );
                              }
                            });
                          }
                        }) : const SizedBox(),
                      ),

                      // City
                      Obx(
                        () => showCity.value ? VoidTextField(controller: cityController, fieldName: "City", hintText: "Select City Emergency Contact", labelText: utilitiesController.isLoadingCity.value ? "Getting City..." : "Select City", onPressed: () async {
                          if(isIndonesia.value){
                            utilitiesController.getCityRaja().then((result){
                              if(result){
                                CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Choose Emergency Contact City", children: List.generate(utilitiesController.kabupatenRajaModels.value?.rajaongkir.results?.length ?? 0, (i){
                                  return ListTile(
                                    onTap: (){
                                      Navigator.pop(context);
                                      cityController.text = utilitiesController.kabupatenRajaModels.value?.rajaongkir.results?[i].cityName ?? "Unknown Kabupaten Name";
                                      utilitiesController.selectedCity(utilitiesController.kabupatenRajaModels.value?.rajaongkir.results?[i].cityId);
                                      showCity(true);
                                    },
                                    title: Text(utilitiesController.kabupatenRajaModels.value?.rajaongkir.results?[i].cityName ?? "Unknown Province Name", style: GoogleFonts.inter()),
                                  );
                                }));
                              }else{
                                CustomAlert.alertError(
                                    onTap: (){ Get.back(); },
                                    message: utilitiesController.responseMessage.value
                                );
                              }
                            });
                          }else{
                            utilitiesController.getCity(provinceName: utilitiesController.selectedProvince.value).then((result){
                              if(result){
                                CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Choose Emergency Contact City", children: List.generate(utilitiesController.provinceModels.value?.data.states?.length ?? 0, (i){
                                    return ListTile(
                                      onTap: (){
                                        Navigator.pop(context);
                                        cityController.text = utilitiesController.cityModels.value?.data[i] ?? "Unknown Province Name";
                                        utilitiesController.selectedCity(provinceController.text);
                                      },
                                      title: Text(utilitiesController.cityModels.value?.data[i] ?? "Unknown Province Name", style: GoogleFonts.inter()),
                                    );
                                }));
                              }else{
                                CustomAlert.alertError(
                                    onTap: (){ Get.back(); },
                                    message: utilitiesController.responseMessage.value
                                );
                              }
                            });
                          }
                        }) : const SizedBox(),
                      ),

                      PhoneTextField(controller: zipController, fieldName: "Zip Code", hintText: "Input Zip Code", labelText: "Zip Code"),
                    ]
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: StepUtilities.stepOnlineRegister(
          size: size,
          title: "Emergency Contact",
          onPressed: (){
            Get.to(() => const Step5InvestmentGoal());
          },
          progressEnd: 4,
          progressStart: 4
        ),
      ),
    );
  }
}
