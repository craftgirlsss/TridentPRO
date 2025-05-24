import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/bottomsheets/material_bottom_sheets.dart';
import 'package:tridentpro/src/components/containers/utilities.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/components/painters/loading_water.dart';
import 'package:tridentpro/src/components/textfields/phone_textfield.dart';
import 'package:tridentpro/src/components/textfields/void_textfield.dart';
import 'package:tridentpro/src/controllers/regol.dart';
import 'package:tridentpro/src/helpers/handlers/image_picker.dart';
import 'package:tridentpro/src/helpers/variables/countries.dart';
import 'package:tridentpro/src/helpers/variables/id_type.dart' show idTypeList;
import 'components/step_position.dart';

class Step1UploadPhoto extends StatefulWidget {
  const Step1UploadPhoto({super.key});

  @override
  State<Step1UploadPhoto> createState() => _Step1UploadPhotoState();
}

class _Step1UploadPhotoState extends State<Step1UploadPhoto> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController nationallyController = TextEditingController();
  TextEditingController idTypeController = TextEditingController();
  TextEditingController idTypeNumber = TextEditingController();
  RegolController regolController = Get.put(RegolController());

  RxString idPhoto = "".obs;
  RxString idPhotoSelfie = "".obs;
  RxBool isLoading = false.obs;

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
                        PhoneTextField(controller: idTypeNumber, fieldName: LanguageGlobalVar.ID_TYPE_NUMBER.tr, hintText: LanguageGlobalVar.ID_TYPE_NUMBER.tr, labelText: LanguageGlobalVar.ID_TYPE_NUMBER.tr),
                        Obx(
                          () => isLoading.value ? const SizedBox() : UtilitiesWidget.uploadPhoto(title: "Foto KTP", onPressed: () async {
                            idPhoto.value = await CustomImagePicker.pickImageFromCameraAndReturnUrl();
                          }, urlPhoto: idPhoto.value),
                        ),
                        Obx(
                          () => isLoading.value ? const SizedBox() : UtilitiesWidget.uploadPhoto(title: "Foto Selfie", urlPhoto: idPhotoSelfie.value, onPressed: () async {
                            idPhotoSelfie.value = await CustomImagePicker.pickImageFromCameraAndReturnUrl();
                          })),
                      ]
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: StepUtilities.stepOnlineRegister(
              size: size,
              title: LanguageGlobalVar.VERIFICATION_IDENTITY.tr,
              onPressed: (){
                regolController.postStepOne(
                  country: nationallyController.text,
                  idType: idTypeController.text,
                  idTypeNumber: idTypeNumber.text,
                  appFotoIdentitas: idPhoto.value,
                  appFotoTerbaru: idPhotoSelfie.value
                );
                // Get.to(() => const Step2StoredData());
              },
              progressEnd: 4,
              progressStart: 1
            ),
          ),
        ),
        Obx(() => regolController.isLoading.value ? LoadingWater() : const SizedBox())
      ],
    );
  }
}
