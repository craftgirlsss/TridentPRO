import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tridentpro/src/components/alerts/default.dart';
import 'package:tridentpro/src/components/alerts/scaffold_messanger_alert.dart';
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
import 'package:tridentpro/src/controllers/utilities.dart';

class Withdrawal extends StatefulWidget {
  const Withdrawal({super.key, this.idLogin});
  final String? idLogin;

  @override
  State<Withdrawal> createState() => _WithdrawalState();
}

class _WithdrawalState extends State<Withdrawal> {

  SettingController settingController = Get.put(SettingController());
  UtilitiesController utilitiesController = Get.find();
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
  final TextEditingController convertedAmount = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      if(widget.idLogin != null){
        selectedTradingID(widget.idLogin);
        myAccountTrading.text = selectedTradingID.value;
      }
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
    convertedAmount.dispose();
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
                          if(widget.idLogin == null){
                            CustomMaterialBottomSheets.defaultBottomSheet(context, title: "Pilih Akun Trading", size: size, children: List.generate(tradingController.tradingAccountModels.value?.response.real?.length ?? 0, (i){
                            final account = tradingController.tradingAccountModels.value?.response.real?[i];
                              return ListTile(
                                subtitle: Text("${account?.currency} - ${account?.login ?? "-"}", style: GoogleFonts.inter(fontWeight: FontWeight.w400, color: Colors.black45)),
                                title: Text("${account?.namaTipeAkun ?? "-"} (\$${account?.balance})", style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                                onTap: (){
                                  Navigator.pop(context);
                                  myAccountTrading.text = "${account?.login} - \$${account?.balance}";
                                  selectedTradingID(account?.id);
                                },
                                leading: Icon(Icons.group, color: CustomColor.defaultColor),
                                trailing: Icon(AntDesign.arrow_right_outline, color: CustomColor.defaultColor),
                              );
                            }));
                          }
                        }),
                      ),
                      Obx(
                        () => selectedTradingID.value == "" ? const SizedBox() : NumberTextField(controller: myAmount, fieldName: "Jumlah Deposit", hintText: "Jumlah Withdrawal", labelText: "Jumlah Withdrawal", maxLength: 1, currencyType: "US", withCurrencyFormatter: true, onSubmitted: (p0) {
                          utilitiesController.convertingMoney(amount: myAmount.text, accountID: selectedTradingID.value).then((result){
                            if(result == false){
                              CustomScaffoldMessanger.showAppSnackBar(context, message: utilitiesController.responseMessage.value, type: SnackBarType.error);
                            }else{
                              convertedAmount.text = result['response']['amount_received'].toString();
                            }
                          });
                        },),
                      ),
                      NumberTextField(controller: convertedAmount, fieldName: "Hasil Konversi", hintText: "Hasil Konversi", labelText: "Hasil Konversi", maxLength: 1, currencyType: "ID", withCurrencyFormatter: true, readOnly: true, preffix: "IDR "),
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
