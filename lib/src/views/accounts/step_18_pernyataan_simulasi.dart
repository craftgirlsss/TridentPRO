import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/bottomsheets/material_bottom_sheets.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/containers/utilities.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/components/painters/loading_water.dart';
import 'package:tridentpro/src/components/textfields/number_textfield.dart';
import 'package:tridentpro/src/components/textfields/void_textfield.dart';
import 'package:tridentpro/src/controllers/regol.dart';
import 'package:tridentpro/src/helpers/handlers/image_picker.dart';
import 'package:tridentpro/src/helpers/variables/countries.dart';
import 'package:tridentpro/src/helpers/variables/id_type.dart' show idTypeList;
import 'package:tridentpro/src/views/accounts/step_2_stored_data.dart';
import 'components/step_position.dart';

class Step18PrenyataanSimulasi extends StatefulWidget {
  const Step18PrenyataanSimulasi({super.key});

  @override
  State<Step18PrenyataanSimulasi> createState() => _Step18PrenyataanSimulasiState();
}

class _Step18PrenyataanSimulasiState extends State<Step18PrenyataanSimulasi> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController nationallyController = TextEditingController();
  TextEditingController idTypeController = TextEditingController();
  TextEditingController idTypeNumber = TextEditingController();
  RegolController regolController = Get.put(RegolController());

  RxString idPhoto = "".obs;
  RxString idPhotoSelfie = "".obs;
  RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    print(regolController.accountModel.value?.country);
    idTypeController.text = regolController.accountModel.value?.idType ?? "";
    idTypeNumber.text = regolController.accountModel.value?.idNumber ?? "";
    nationallyController.text = regolController.accountModel.value?.country ?? "";
  }

  @override
  void dispose() {
    nationallyController.dispose();
    idTypeController.dispose();
    idTypeNumber.dispose();
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
                  onPressed: (){},
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
                      title: LanguageGlobalVar.TITLE_REGOL_PAGE_1.tr,
                      subtitle: LanguageGlobalVar.SUBTITLE_REGOL_PAGE_1.tr,
                      children: [
                        const SizedBox(height: 10),
                        VoidTextField(controller: nationallyController, fieldName: LanguageGlobalVar.NATIONALY.tr, hintText: LanguageGlobalVar.CHOOSE_NATIONALY.tr, labelText: LanguageGlobalVar.NATIONALY.tr, onPressed: (){
                          CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: LanguageGlobalVar.CHOOSE_NATIONALY.tr, children: List.generate(countryList.length, (i){
                            return ListTile(
                              onTap: (){
                                Navigator.pop(context);
                                nationallyController.text = countryList[i].name;
                              },
                              title: Text(countryList[i].name, style: GoogleFonts.inter()),
                            );
                          }));
                        }),
                        VoidTextField(onPressed: (){
                          CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: LanguageGlobalVar.CHOOSE_YOUR_ID_TYPE.tr, isScrolledController: false, children: List.generate(idTypeList.length, (i){
                            return ListTile(
                              onTap: (){
                                Navigator.pop(context);
                                idTypeController.text = idTypeList[i].name;
                              },
                              title: Text(idTypeList[i].name, style: GoogleFonts.inter()),
                            );
                          }));
                        },
                            controller: idTypeController, fieldName: LanguageGlobalVar.ID_TYPE.tr, hintText: LanguageGlobalVar.ID_TYPE.tr, labelText: LanguageGlobalVar.ID_TYPE.tr
                        ),
                        NumberTextField(controller: idTypeNumber, fieldName: LanguageGlobalVar.ID_TYPE_NUMBER.tr, hintText: LanguageGlobalVar.ID_TYPE_NUMBER.tr, labelText: LanguageGlobalVar.ID_TYPE_NUMBER.tr, maxLength: 14),
                        Obx(
                          () => isLoading.value ? const SizedBox() : UtilitiesWidget.uploadPhoto(title: "Foto KTP", onPressed: () async {
                            idPhoto.value = await CustomImagePicker.pickImageFromCameraAndReturnUrl();
                          }, urlPhoto: idPhoto.value),
                        ),
                        Obx(
                          () => isLoading.value ? const SizedBox() : UtilitiesWidget.uploadPhoto(title: "Foto Selfie", urlPhoto: idPhotoSelfie.value, onPressed: () async {
                              idPhotoSelfie.value = await CustomImagePicker.pickImageFromCameraAndReturnUrl();
                            }
                          )
                        ),
                      ]
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Obx(
                  () => StepUtilities.stepOnlineRegister(
                  size: size,
                  title: LanguageGlobalVar.VERIFICATION_IDENTITY.tr,
                  onPressed: regolController.isLoading.value ? null : (){
                    if(idTypeController.text == "Nationaly Identification Card") idTypeController.text = "KTP";
                    regolController.postStepOne(
                        country: nationallyController.text,
                        idType: idTypeController.text,
                        idTypeNumber: idTypeNumber.text,
                        appFotoIdentitas: idPhoto.value,
                        appFotoTerbaru: idPhotoSelfie.value
                    ).then((result){
                      if(result){
                        print("BERHASIL");
                        Get.to(() => const Step2StoredData());
                      }else{
                        print("GAGAL");
                      }
                    });
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
