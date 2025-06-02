import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tridentpro/src/components/alerts/default.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/bottomsheets/material_bottom_sheets.dart';
import 'package:tridentpro/src/components/buttons/outlined_button.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/containers/utilities.dart';
import 'package:tridentpro/src/components/textfields/number_textfield.dart';
import 'package:tridentpro/src/components/textfields/void_textfield.dart';
import 'package:tridentpro/src/controllers/setting.dart';
import 'package:tridentpro/src/controllers/trading.dart';

class InternalTransfer extends StatefulWidget {
  const InternalTransfer({super.key});

  @override
  State<InternalTransfer> createState() => _InternalTransferState();
}

class _InternalTransferState extends State<InternalTransfer> {

  RxBool isLoading = false.obs;
  final _formKey = GlobalKey<FormState>();
  RxString selectedTradingIDSender = "".obs;
  RxString selectedTradingIDReceiver = "".obs;
  RxList akunTradingList = [].obs;
  SettingController settingController = Get.put(SettingController());
  TradingController tradingController = Get.put(TradingController());
  TextEditingController myAccountTradingSender = TextEditingController();
  TextEditingController myAccountTradingReceiver = TextEditingController();
  TextEditingController amount = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      tradingController.getTradingAccountV2().then((resultTrading){
        akunTradingList.value = resultTrading;
        print(akunTradingList);
      });
    });
  }

  @override
  void dispose() {
    amount.dispose();
    myAccountTradingReceiver.dispose();
    myAccountTradingSender.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: CustomAppBar.defaultAppBar(
          title: "Withdrawal",
          autoImplyLeading: true,
          actions: [
            SizedBox(
              height: 30,
              child: Obx(
                () => isLoading.value ? CircularProgressIndicator(color: CustomColor.defaultColor) : CustomOutlinedButton.defaultOutlinedButton(
                  title: "Submit",
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String? accessToken = prefs.getString('accessToken');
                    print(accessToken);
                    isLoading(true);
                    print("Trading ID Sender: ${selectedTradingIDSender.value}");
                    print("Trading ID Receiver: ${selectedTradingIDReceiver.value}");
                    print("Amount: ${amount.text}");
                    if(_formKey.currentState!.validate()){
                      settingController.internalTransfer(
                        amount: amount.text,
                        tradingIDReceiver: selectedTradingIDReceiver.value,
                        tradingIDSender: selectedTradingIDSender.value
                      ).then((resultWD){
                        if(resultWD){
                          CustomAlert.alertDialogCustomSuccess(message: settingController.responseMessage.value, onTap: (){
                            Get.back();
                          });
                          isLoading(false);
                          return;
                        }
                        isLoading(false);
                        CustomAlert.alertError(message: settingController.responseMessage.value);
                      });
                    }
                  }
                ),
              ),
            ),
            const SizedBox(width: 10)
          ]
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                UtilitiesWidget.titleContent(
                  title: "Akun Trading Pengirim",
                  subtitle: "Pastikan jumlah balance anda mencukupi untuk proses internal transfer",
                  children: [
                    Obx(
                      () => VoidTextField(controller: myAccountTradingSender, fieldName: "Akun Trading Pengirim", hintText: "Akun Trading Pengirim", labelText: "Akun Trading Pengirim", onPressed: settingController.isLoading.value ? null : () async {
                        CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Pilih Akun Trading Pengirim", children: List.generate(akunTradingList.length, (i){
                          return ListTile(
                            onTap: (){
                              Navigator.pop(context);
                              myAccountTradingSender.text = "${akunTradingList[i]['login'].toString()} - \$${akunTradingList[i]['balance'].toString()}";
                              selectedTradingIDSender(akunTradingList[i]['id']);
                            },
                            title: Text("${myAccountTradingSender.text = akunTradingList[i]['login'].toString()} - \$${akunTradingList[i]['balance'].toString()}", style: GoogleFonts.inter()),
                          );
                        }));
                      }),
                    ),
                  ]
                ),

                UtilitiesWidget.titleContent(
                  title: "Akun Trading Penerima",
                  subtitle: "Pastikan jumlah balance anda mencukupi untuk proses internal transfer",
                  children: [
                    Obx(
                      () => VoidTextField(controller: myAccountTradingReceiver, fieldName: "Akun Trading Pengirim", hintText: "Akun Trading Pengirim", labelText: "Akun Trading Pengirim", onPressed: settingController.isLoading.value ? null : () async {
                        CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Pilih Akun Trading Pengirim", children: List.generate(akunTradingList.length, (i){
                          return ListTile(
                            onTap: (){
                              Navigator.pop(context);
                              myAccountTradingReceiver.text = "${akunTradingList[i]['login'].toString()} - \$${akunTradingList[i]['balance'].toString()}";
                              selectedTradingIDReceiver(akunTradingList[i]['id']);
                            },
                            title: Text("${myAccountTradingReceiver.text = akunTradingList[i]['login'].toString()} - \$${akunTradingList[i]['balance'].toString()}", style: GoogleFonts.inter()),
                          );
                        }));
                      }),
                    ),
                  ]
                ),

                UtilitiesWidget.titleContent(
                  title: "Jumlah Transfer",
                  subtitle: "Pastikan jumlah balance anda mencukupi untuk proses internal transfer",
                  children: [
                    NumberTextField(controller: amount, fieldName: "Jumlah Transfer", hintText: "Jumlah Transfer", labelText: "Jumlah Transfer", maxLength: 1),
                  ]
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
