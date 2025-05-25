import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/containers/utilities.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/components/painters/loading_water.dart';
import 'package:tridentpro/src/controllers/regol.dart';
import 'package:tridentpro/src/helpers/handlers/image_picker.dart';
import 'package:tridentpro/src/views/accounts/step_13_perselisihan.dart';
import 'package:tridentpro/src/views/accounts/step_2_stored_data.dart';
import 'components/step_position.dart';

class Step17UploadPhoto extends StatefulWidget {
  const Step17UploadPhoto({super.key});

  @override
  State<Step17UploadPhoto> createState() => _Step17UploadPhotoState();
}

class _Step17UploadPhotoState extends State<Step17UploadPhoto> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController nationallyController = TextEditingController();
  TextEditingController idTypeController = TextEditingController();
  TextEditingController idTypeNumber = TextEditingController();
  RegolController regolController = Get.put(RegolController());

  RxString idPhoto = "".obs;
  RxString idPhotoSelfie = "".obs;
  RxString idPhotoPendukung = "".obs;
  RxString idPhotoPendukungLainnya = "".obs;
  RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
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
                      // title: LanguageGlobalVar.TITLE_REGOL_PAGE_1.tr,
                      subtitle: LanguageGlobalVar.SUBTITLE_REGOL_PAGE_1.tr,
                      title: "Dokumen Pendukung",
                      children: [
                        Obx(
                          () => isLoading.value ? const SizedBox() : UtilitiesWidget.uploadPhoto(title: "(cover buku tabungan (recommended), tagihan kartu kredit, tagihan listrik / air, scan kartu npwp, rekening koran bank, pbb / bpjs, lainnya", onPressed: () async {
                            idPhoto.value = await CustomImagePicker.pickImageFromCameraAndReturnUrl();
                            },
                            urlPhoto: idPhoto.value
                          ),
                        ),
                        Obx(
                          () => isLoading.value ? const SizedBox() : UtilitiesWidget.uploadPhoto(title: "Pendukung (required)", urlPhoto: idPhotoSelfie.value, onPressed: () async {
                            idPhotoSelfie.value = await CustomImagePicker.pickImageFromCameraAndReturnUrl();
                            }
                          )
                        ),
                        Obx(
                          () => isLoading.value ? const SizedBox() : UtilitiesWidget.uploadPhoto(title: "Pendukung (required)", urlPhoto: idPhotoSelfie.value, onPressed: () async {
                              idPhotoPendukung.value = await CustomImagePicker.pickImageFromCameraAndReturnUrl();
                            }
                          )
                        ),
                        Obx(
                          () => isLoading.value ? const SizedBox() : UtilitiesWidget.uploadPhoto(title: "Pendukung Lainnya (required)", urlPhoto: idPhotoSelfie.value, onPressed: () async {
                              idPhotoPendukungLainnya.value = await CustomImagePicker.pickImageFromCameraAndReturnUrl();
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
                    Get.to(() => const Step13PenyelesaianPerselisihan());
                  });
                },
                progressEnd: 4,
                progressStart: 3
              ),
            ),
          ),
        ),
        Obx(() => regolController.isLoading.value ? LoadingWater() : const SizedBox())
      ],
    );
  }
}
