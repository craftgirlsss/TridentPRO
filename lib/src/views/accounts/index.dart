import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tridentpro/src/components/alerts/default.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/components/painters/loading_water.dart';
import 'package:tridentpro/src/controllers/trading.dart';
import 'package:tridentpro/src/views/accounts/demo_section.dart';
import 'package:tridentpro/src/views/accounts/pending_account.dart';
import 'package:tridentpro/src/views/accounts/real_section.dart';

class Accounts extends StatefulWidget {
  const Accounts({super.key});

  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  String selected = "Demo";
  RxBool isLoading = false.obs;
  TradingController tradingController = Get.put(TradingController());

  @override
  void initState() {
    super.initState();
    tradingController.getTradingAccount().then((result){
      if(!result){
        CustomAlert.alertError(message: tradingController.responseMessage.value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Stack(
        children: [
          Scaffold(
            appBar: CustomAppBar.defaultAppBar(
              title: LanguageGlobalVar.TRADING_ACCOUNT.tr,
              autoImplyLeading: false,
              // actions: <Widget>[
              //   IconButtons.defaultIconButton(
              //     onPressed: (){
              //       print(tradingController.tradingAccountModels.value?.response.real?.length);
              //     },
              //     icon: OctIcons.search
              //   )
              // ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: Obx(
                  () => tradingController.tradingAccountModels.value?.response.demo == null ? const SizedBox() : SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Obx(
                              () {
                                if(tradingController.tradingAccountModels.value?.response.demo?.length == 0){
                                  return SegmentedButton<String>(
                                    segments: const <ButtonSegment<String>>[
                                      ButtonSegment(
                                        value: 'Demo',
                                        label: Text('Demo'),
                                      ),
                                    ],
                                    selected: <String>{selected},
                                    onSelectionChanged: (newSelection) {
                                      setState(() {
                                        selected = newSelection.first;
                                      });
                                    },
                                    multiSelectionEnabled: false,
                                    showSelectedIcon: false,
                                  );
                                }
                                return SegmentedButton<String>(
                                  segments: const <ButtonSegment<String>>[
                                    ButtonSegment(
                                      value: 'Real',
                                      label: Text('Real'),
                                    ),
                                    ButtonSegment(
                                      value: 'Demo',
                                      label: Text('Demo'),
                                    ),
                                    ButtonSegment(
                                      value: 'Pending',
                                      label: Text('Pending'),
                                    ),

                                  ],
                                  selected: <String>{selected},
                                  onSelectionChanged: (newSelection) {
                                    setState(() {
                                      selected = newSelection.first;
                                    });
                                  },
                                  multiSelectionEnabled: false,
                                  showSelectedIcon: false,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              )
            ),
            body: Obx(() {
              if(tradingController.isLoading.value){
                return SizedBox();
              }else if(selected == "Demo"){
                return DemoSection();
              }else if(selected == "Real"){
                return RealSection();
              }else if(selected == "Pending"){
                return PendingAccount();
              }else{
                return SizedBox(
                  child: Text("Tidak dikenali"),
                );
              }
            }),
            // body: Obx(() => tradingController.isLoading.value ? const SizedBox() : selected == "Demo" ? DemoSection() : RealSection())
          ),
          Obx(() => tradingController.isLoading.value ? LoadingWater() : const SizedBox())
        ],
      ),
    );
  }
}


