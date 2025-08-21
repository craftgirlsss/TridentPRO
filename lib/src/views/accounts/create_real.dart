import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/alerts/default.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/bottomsheets/material_bottom_sheets.dart';
import 'package:tridentpro/src/components/buttons/elevated_button.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/components/painters/loading_water.dart';
import 'package:tridentpro/src/components/textfields/void_textfield.dart';
import 'package:tridentpro/src/controllers/regol.dart';
import 'package:tridentpro/src/views/accounts/step_1_upload_photo.dart';
import 'components/simple_utilities.dart';

class CreateReal extends StatefulWidget {
  const CreateReal({super.key});

  @override
  State<CreateReal> createState() => _CreateRealState();
}

class _CreateRealState extends State<CreateReal> {
  RxInt selectedIndex = 0.obs;
  RxBool isLoading = false.obs;
  RxBool selectedType = false.obs;
  RxInt selectedRadio = 1.obs;
  RxString accountTypeSuffix = "".obs;

  TextEditingController productController = TextEditingController();
  RegolController regolController = Get.put(RegolController());

  @override
  void initState() {
    super.initState();

    /** Fetch progressAccount */
    regolController.isLoading(true);
    regolController.progressAccount().then((result){

      /** Fetch products */
      regolController.getProducts().then((result){
        if(!result){
          CustomAlert.alertError();
          return false;
        }

        /** Assign account type to productController */
        if(regolController.accountModel.value?.type != null){
          productController.text = regolController.accountModel.value?.type.toString() ?? "";
          int index = regolController.productModels.value?.response.indexWhere((element) => element.type?.toUpperCase() == regolController.accountModel.value?.type?.toUpperCase()) ?? -1;
          if(index != -1){
            selectedIndex(index);
            selectedType(true);
            
            int index2 = regolController.productModels.value?.response[index].products?.indexWhere((element2) => element2.suffix == regolController.accountModel.value?.typeAcc) ?? -1;
            if(index2 != -1){
              accountTypeSuffix(regolController.productModels.value?.response[index].products?[index2].suffix);
              selectedRadio(index2 + 1);
            }
          }
        }

        regolController.isLoading(false);
      });
    });
  }

  @override
  void dispose() {
    productController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar.defaultAppBar(
            autoImplyLeading: true,
            title: '',
          ),
          body: SafeArea(
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SimpleUtilities.titleCreateReal(),
                      Obx(
                        () => isLoading.value ? const SizedBox() : VoidTextField(controller: productController, fieldName: "Trading Account Type", hintText:  "Trading Account Type", labelText: "Trading Account Type", onPressed: (){
                          CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Choose Trading Account Type", children: List.generate(regolController.productModels.value?.response.length ?? 0, (i){
                            return ListTile(
                              onTap: (){
                                Navigator.pop(context);
                                selectedIndex(i);
                                productController.text = regolController.productModels.value?.response[i].type != null ? regolController.productModels.value!.response[i].type!.toUpperCase() : "-";
                                selectedType(true);
                              },
                              title: Text(regolController.productModels.value?.response[i].type != null ? regolController.productModels.value!.response[i].type!.toUpperCase() :  "-", style: GoogleFonts.inter()),
                            );
                          }));
                        }),
                      ),
                      Obx(
                        () => selectedType.value ? ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: regolController.productModels.value?.response[selectedIndex.value].products!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Obx(
                                () => RadioListTile(
                                  enableFeedback: true,
                                  toggleable: false,
                                  activeColor: CustomColor.secondaryColor,
                                  selected: false,
                                  selectedTileColor: CustomColor.secondaryColor,
                                  shape: StadiumBorder(
                                    side: BorderSide(color: CustomColor.secondaryColor)
                                  ),
                                  title: Text(regolController.productModels.value?.response[selectedIndex.value].products?[index].name ?? "-"),
                                  value: index + 1,
                                  groupValue: selectedRadio.value,
                                  onChanged: (value) {
                                    accountTypeSuffix(regolController.productModels.value?.response[selectedIndex.value].products?[index].suffix);
                                    selectedRadio(value);
                                  },
                                ),
                              ),
                            );
                          },
                        )
                        : const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 3, bottom: 40),
            child: Obx(
              () => DefaultButton.defaultElevatedButton(
                onPressed: regolController.isLoading.value ? null : (){
                  regolController.postStepZero(accountSuffix: accountTypeSuffix.value, accountType: productController.text).then((result){
                    if(result){
                      Get.to(() => const Step1UploadPhoto());
                    }else{
                      CustomAlert.alertWaiting(message: regolController.responseMessage.value);
                    }
                  });
                },
                title: LanguageGlobalVar.CREATE_TRADING_ACCOUNT.tr
              ),
            ),
          ),
        ),
        Obx(() => regolController.isLoading.value ? LoadingWater() : const SizedBox())
      ],
    );
  }
}
