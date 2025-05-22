import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tridentpro/src/components/buttons/elevated_button.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SimpleUtilities.titleCreateReal(),
                SizedBox(
                  width: size.width,
                  height: size.width / 1.2,
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        SimpleUtilities.listType.length, (i){
                          return Obx(
                            () => isLoading.value ? const SizedBox() : SimpleUtilities.tileAccount(
                              onPressed: () => selectedIndex(i),
                              title: SimpleUtilities.listType[i]['name'],
                              spread: SimpleUtilities.listType[i]['spread'].toString(),
                              selected: i == 0 ? true : false
                            ),
                          );
                        }
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => isLoading.value ? const SizedBox() : SimpleUtilities.cardInfoAccountType(
                    size: size,
                    first: SimpleUtilities.listType[selectedIndex.value]['leverage'],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: DefaultButton.defaultElevatedButton(
          onPressed: (){
            Get.to(() => const Step1UploadPhoto());
          },
          title: LanguageGlobalVar.CREATE_TRADING_ACCOUNT.tr
        ),
      ),
    );
  }
}
