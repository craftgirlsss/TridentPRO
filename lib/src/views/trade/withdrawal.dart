import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/alerts/default.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/bottomsheets/material_bottom_sheets.dart';
import 'package:tridentpro/src/components/buttons/outlined_button.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/containers/utilities.dart';
import 'package:tridentpro/src/components/textfields/name_textfield.dart';
import 'package:tridentpro/src/components/textfields/number_textfield.dart';
import 'package:tridentpro/src/components/textfields/void_textfield.dart';
import 'package:tridentpro/src/controllers/setting.dart';
import 'package:tridentpro/src/controllers/trading.dart';

class Withdrawal extends StatefulWidget {
  const Withdrawal({super.key});

  @override
  State<Withdrawal> createState() => _WithdrawalState();
}

class _WithdrawalState extends State<Withdrawal> {

  SettingController settingController = Get.put(SettingController());
  TradingController tradingController = Get.put(TradingController());
  RxString selectedBankUserID = "".obs;
  RxString selectedTradingID = "".obs;
  RxList akunTradingList = [].obs;
  RxBool isLoading = false.obs;
  final _formKey = GlobalKey<FormState>();
  TextEditingController myBankCabang = TextEditingController();
  TextEditingController myBankName = TextEditingController();
  TextEditingController myBankNumber = TextEditingController();
  TextEditingController myBankType = TextEditingController();
  TextEditingController myAmount = TextEditingController();
  TextEditingController myAccountTrading = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      settingController.getUserBank().then((resultGetMyBank){
        if(!resultGetMyBank){
          CustomAlert.alertError(message: settingController.responseMessage.value);
          return;
        }
        tradingController.getTradingAccountV2().then((resultTrading){
          akunTradingList.value = resultTrading;
        });
        selectedBankUserID(settingController.userBankModel.value?.response?[0].id);
        myBankCabang.text = settingController.userBankModel.value?.response?[0].branch ?? "";
        myBankName.text = settingController.userBankModel.value?.response?[0].name ?? "";
        myBankNumber.text = settingController.userBankModel.value?.response?[0].account ?? "";
        myBankType.text = settingController.userBankModel.value?.response?[0].type ?? "";
      });
    });
  }

  @override
  void dispose() {
    myBankCabang.dispose();
    myBankName.dispose();
    myBankNumber.dispose();
    myBankType.dispose();
    myAmount.dispose();
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
                  onPressed: (){
                    isLoading(true);
                    print("Trading ID: ${selectedTradingID.value}");
                    print("Bank User ID: ${selectedBankUserID.value}");
                    print("Amount: ${myAmount.text}");
                    if(_formKey.currentState!.validate()){
                      settingController.withdrawal(
                        bankUserID: selectedBankUserID.value,
                        amount: myAmount.text,
                        tradingID: selectedTradingID.value
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
        body: RefreshIndicator(
          color: CustomColor.defaultColor,
          onRefresh: () async {},
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  UtilitiesWidget.titleContent(
                    title: "Withdrawal",
                    subtitle: "Pastikan jumlah balance anda mencukupi untuk proses withdrawal",
                    children: [
                      Obx(
                        () => VoidTextField(controller: myBankName, fieldName: "Nama Bank", hintText: "Nama Bank", labelText: "Nama Bank", onPressed: settingController.isLoading.value ? null : () async {
                          CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Pilih bank yang anda miliki", children: List.generate(settingController.userBankModel.value?.response?.length ?? 0, (i){
                            return ListTile(
                              onTap: (){
                                Navigator.pop(context);
                                selectedBankUserID(settingController.userBankModel.value?.response?[i].id);
                                myBankCabang.text = settingController.userBankModel.value?.response?[i].branch ?? "";
                                myBankName.text = settingController.userBankModel.value?.response?[i].name ?? "";
                                myBankNumber.text = settingController.userBankModel.value?.response?[i].account ?? "";
                                myBankType.text = settingController.userBankModel.value?.response?[i].type ?? "";
                              },
                              title: Text(settingController.userBankModel.value?.response?[i].name ?? "", style: GoogleFonts.inter()),
                            );
                          }));
                        }),
                      ),
                      NameTextField(controller: myBankNumber, fieldName: "Nomor Rekening", hintText: "Nomor Rekening", labelText: "Nomor Rekening", readOnly: true, useValidator: false),
                      NameTextField(controller: myBankCabang, fieldName: "Cabang", hintText: "Cabang", labelText: "Cabang", readOnly: true, useValidator: false),
                      NameTextField(controller: myBankType, fieldName: "Tipe", hintText: "Tipe", labelText: "Tipe", readOnly: true, useValidator: false),
                      Obx(
                        () => VoidTextField(controller: myAccountTrading, fieldName: "Akun Trading", hintText: "Akun Trading", labelText: "Akun Trading", onPressed: settingController.isLoading.value ? null : () async {
                          CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Pilih Akun Trading", children: List.generate(akunTradingList.length, (i){
                            return ListTile(
                              onTap: (){
                                Navigator.pop(context);
                                myAccountTrading.text = "${akunTradingList[i]['login'].toString()} - \$${akunTradingList[i]['balance'].toString()}";
                                selectedTradingID(akunTradingList[i]['id']);
                              },
                              title: Text("${myAccountTrading.text = akunTradingList[i]['login'].toString()} - \$${akunTradingList[i]['balance'].toString()}", style: GoogleFonts.inter()),
                            );
                          }));
                        }),
                      ),
                      NumberTextField(controller: myAmount, fieldName: "Jumlah Deposit", hintText: "Jumlah Deposit", labelText: "Jumlah Deposit", maxLength: 1),
                    ]
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
