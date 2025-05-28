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
import 'package:tridentpro/src/views/accounts/step_6_invest_experience.dart';
import 'components/step_position.dart';

class Step19FamilyBappebti extends StatefulWidget {
  const Step19FamilyBappebti({super.key});

  @override
  State<Step19FamilyBappebti> createState() => _Step19FamilyBappebti();
}

class _Step19FamilyBappebti extends State<Step19FamilyBappebti> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController familyBappebti = TextEditingController();
  RegolController regolController = Get.put(RegolController());

  RxString idPhoto = "".obs;
  List<String> pilihan = ["Ya", "Tidak"];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    familyBappebti.dispose();
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
                      title: "Keluarga BAPPEBTI",
                      subtitle: "Apakah anda memiliki keluarga yang bekerja di BAPPEBTI",
                      children: [
                        const SizedBox(height: 10),
                        VoidTextField(controller: familyBappebti, fieldName: "Keluarga BAPPEBTI", hintText: "Pilih salah satu", labelText: "Keluarga BAPPEBTI", onPressed: (){
                          CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Apakah anda memiliki hubungan keluarga yang bekerja di BAPPEBTI", children: List.generate(pilihan.length, (i){
                            return ListTile(
                              onTap: (){
                                Navigator.pop(context);
                                familyBappebti.text = pilihan[i];
                              },
                              title: Text(pilihan[i], style: GoogleFonts.inter()),
                            );
                          }));
                        }),
                      ]
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Obx(
              () => StepUtilities.stepOnlineRegister(
              size: size,
              title: "Keluarga BAPPEBTI",
              onPressed: regolController.isLoading.value ? null : (){
                Get.to(() => const Step6InvestmentExperience());
              },
              progressEnd: 4,
              progressStart: 2
              ),
            ),
          ),
        ),
        Obx(() => regolController.isLoading.value ? LoadingWater() : const SizedBox())
      ],
    );
  }
}
