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
import 'package:tridentpro/src/components/textfields/void_textfield.dart';
import 'package:tridentpro/src/controllers/regol.dart';
import 'package:tridentpro/src/helpers/handlers/image_picker.dart';
import 'package:tridentpro/src/helpers/variables/global_variables.dart';
import 'package:tridentpro/src/views/accounts/step_13_perselisihan.dart';
import 'package:tridentpro/src/views/accounts/step_2_stored_data.dart';
import 'components/checklist_statement.dart';
import 'components/step_position.dart';

class Step17UploadPhoto extends StatefulWidget {
  const Step17UploadPhoto({super.key});

  @override
  State<Step17UploadPhoto> createState() => _Step17UploadPhotoState();
}

class _Step17UploadPhotoState extends State<Step17UploadPhoto> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController documentFirstName = TextEditingController();
  TextEditingController documentSecondName = TextEditingController();
  RegolController regolController = Get.put(RegolController());

  RxString documentFirstURL = "".obs;
  RxString documentSecondURL = "".obs;
  RxBool isLoading = false.obs;
  RxBool accepted = false.obs;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    documentFirstName.dispose();
    documentSecondName.dispose();
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
                      subtitle: LanguageGlobalVar.SUBTITLE_REGOL_PAGE_1.tr,
                      title: "Dokumen Pendukung",
                      children: [
                        // Document First
                        VoidTextField(controller: documentFirstName, fieldName: "Dokumen Pendukung 1", hintText: "Dokumen Pendukung 1", labelText: "Dokumen Pendukung 1", onPressed: () async {
                          CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Pilih Jenis Dokumen Pendukung 1 untuk disubmit", children: List.generate(GlobalVariable.listSupportedDocuments.length, (i){
                            return ListTile(
                              onTap: (){
                                Navigator.pop(context);
                                documentFirstName.text = GlobalVariable.listSupportedDocuments[i];
                              },
                              title: Text("${GlobalVariable.listSupportedDocuments[i]} - ${GlobalVariable.listSupportedDocuments[i]}", style: GoogleFonts.inter()),
                            );
                          }));
                        }),
                        Obx(
                          () => isLoading.value ? const SizedBox() : UtilitiesWidget.uploadPhoto(title: "Upload Foto", onPressed: () async {
                            documentFirstURL.value = await CustomImagePicker.pickImageFromCameraAndReturnUrl();
                            },
                            urlPhoto: documentFirstURL.value
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Document Second
                        Obx(
                          () => isLoading.value ? const SizedBox() : UtilitiesWidget.uploadPhoto(title: "Upload Foto", onPressed: () async {
                            documentSecondURL.value = await CustomImagePicker.pickImageFromCameraAndReturnUrl();
                          },
                            urlPhoto: documentSecondURL.value
                          ),
                        ),

                        checklistStatement(
                          accepted: accepted.value
                        )

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
                    Get.to(() => const Step13PenyelesaianPerselisihan());
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
