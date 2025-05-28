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

class Step20PernytaaanPailit extends StatefulWidget {
  const Step20PernytaaanPailit({super.key});

  @override
  State<Step20PernytaaanPailit> createState() => _Step20PernytaaanPailit();
}

class _Step20PernytaaanPailit extends State<Step20PernytaaanPailit> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController pernyataanPailit = TextEditingController();
  RegolController regolController = Get.put(RegolController());

  RxString idPhoto = "".obs;
  List<String> pilihan = ["Ya", "Tidak"];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    pernyataanPailit.dispose();
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
                        title: "Pernyataan Pailit",
                        subtitle: "Apakah anda dinyatakan pailit oleh pengadilan?",
                        children: [
                          const SizedBox(height: 10),
                          VoidTextField(controller: pernyataanPailit, fieldName: "Pernyataan Pailit", hintText: "Pernyataan Pailit", labelText: "Pernyataan Pailit", onPressed: (){
                            CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Apakah anda dinyatakan pailit oleh pengadilan?", children: List.generate(pilihan.length, (i){
                              return ListTile(
                                onTap: (){
                                  Navigator.pop(context);
                                  pernyataanPailit.text = pilihan[i];
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
                  progressEnd: 5,
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
