import 'package:flutter/material.dart';
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
import 'package:get/get.dart';
import 'package:tridentpro/src/controllers/trading.dart';
import 'package:tridentpro/src/helpers/handlers/image_picker.dart';
import 'package:tridentpro/src/helpers/variables/countrycurrency.dart';

class Deposit extends StatefulWidget {
  const Deposit({super.key});

  @override
  State<Deposit> createState() => _DepositState();
}

class _DepositState extends State<Deposit> {
  
  SettingController settingController = Get.put(SettingController());
  TradingController tradingController = Get.put(TradingController());
  RxString selectedBankAdminID = "".obs;
  RxString selectedBankUserID = "".obs;
  RxString selectedTradingID = "".obs;
  RxString selectedPhotoPath = "".obs;
  RxBool isLoading = false.obs;
  RxList akunTradingList = [].obs;
  final _formKey = GlobalKey<FormState>();
  TextEditingController myBankCabang = TextEditingController();
  TextEditingController myBankName = TextEditingController();
  TextEditingController myBankNumber = TextEditingController();
  TextEditingController myBankType = TextEditingController();
  TextEditingController myAmount = TextEditingController();
  TextEditingController myAccountTrading = TextEditingController();

  TextEditingController bankAdminName = TextEditingController();
  TextEditingController bankAdminHolder = TextEditingController();
  TextEditingController bankAdminNumber = TextEditingController();
  TextEditingController bankAdminCurrency = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      settingController.getAdminBank().then((resultBank){
        if(!resultBank){
          CustomAlert.alertError(message: settingController.responseMessage.value);
          return;
        }
        selectedBankAdminID(settingController.adminBankModel.value?.response?[0].id);
        bankAdminHolder.text = settingController.adminBankModel.value?.response?[0].bankHolder ?? "";
        bankAdminNumber.text = settingController.adminBankModel.value?.response?[0].bankAccount ?? "";
        bankAdminName.text = settingController.adminBankModel.value?.response?[0].bankName ?? "";
        bankAdminCurrency.text = settingController.adminBankModel.value?.response?[0].currency ?? "0";
        settingController.getUserBank().then((resultGetMyBank){
          if(!resultGetMyBank){
            CustomAlert.alertError(message: settingController.responseMessage.value);
            return;
          }
          tradingController.getTradingAccount().then((resultTrading){
            if(!resultTrading){
              CustomAlert.alertError(message: tradingController.responseMessage.value);
            }
          });
          selectedBankUserID(settingController.userBankModel.value?.response?[0].id);
          myBankCabang.text = settingController.userBankModel.value?.response?[0].branch ?? "";
          myBankName.text = settingController.userBankModel.value?.response?[0].name ?? "";
          myBankNumber.text = settingController.userBankModel.value?.response?[0].account ?? "";
          myBankType.text = settingController.userBankModel.value?.response?[0].type ?? "";
        });
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
    bankAdminName.dispose();
    bankAdminHolder.dispose();
    bankAdminCurrency.dispose();
    bankAdminNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: CustomAppBar.defaultAppBar(
          title: "Deposit",
          autoImplyLeading: true,
          actions: [
            SizedBox(
              height: 30,
              child: Obx(
                () => isLoading.value ? CircularProgressIndicator() : CustomOutlinedButton.defaultOutlinedButton(
                  title: "Submit",
                  onPressed: settingController.isLoading.value ? null : () async {
                    isLoading(true);
                    if(_formKey.currentState!.validate()){
                      if(selectedPhotoPath.value == ""){
                        CustomAlert.alertError(message: "Mohon unggah foto bukti transfer");
                        isLoading(false);
                        return;
                      }
                      settingController.deposit(
                        imageURL: selectedPhotoPath.value,
                        accountID: selectedTradingID.value,
                        amount: myAmount.text,
                        bankAdminID: selectedBankAdminID.value,
                        bankUserID: selectedBankUserID.value,
                      ).then((result){
                        if(result){
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
          onRefresh: () async {
            await settingController.getAdminBank();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  UtilitiesWidget.titleContent(
                    title: "Bank Admin",
                    subtitle: "Pilih bank admin sesuai dengan currency akun yang anda pilih sebelumnya saat pembuatan akun trading",
                    children: [
                      Obx(
                        () => VoidTextField(controller: bankAdminHolder, fieldName: "Admin Bank Holder", hintText: "Admin Bank Holder", labelText: "Admin Bank Holder", onPressed: settingController.isLoading.value ? null : () async {
                          CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Pilih bank admin yang sesuai dengan rekening anda", children: List.generate(settingController.adminBankModel.value?.response?.length ?? 0, (i){
                            return ListTile(
                              onTap: (){
                                Navigator.pop(context);
                                bankAdminHolder.text = settingController.adminBankModel.value?.response?[i].bankHolder ?? "";
                                selectedBankAdminID(settingController.adminBankModel.value?.response?[i].id);
                                bankAdminNumber.text = settingController.adminBankModel.value?.response?[i].bankAccount ?? "";
                                bankAdminName.text = settingController.adminBankModel.value?.response?[i].bankName ?? "";
                                bankAdminCurrency.text = settingController.adminBankModel.value?.response?[i].currency ?? "0";
                              },
                              title: Text("${settingController.adminBankModel.value?.response?[i].bankHolder ?? ""} - ${currencyCodes[i].name}", style: GoogleFonts.inter()),
                            );
                          }));
                        }),
                      ),
                      NameTextField(controller: bankAdminName, fieldName: "Nama Bank", hintText: "Nama Bank", labelText: "Nama Bank", readOnly: true, useValidator: false),
                      NameTextField(controller: bankAdminNumber, fieldName: "Nomor Rekening", hintText: "Nomor Rekening", labelText: "Nomor Rekening", readOnly: true, useValidator: false),
                      NameTextField(controller: bankAdminCurrency, fieldName: "Kurs Akun Bank", hintText: "Kurs Akun Bank", labelText: "Kurs Akun Bank", readOnly: true, useValidator: false),
                    ]
                  ),

                  UtilitiesWidget.titleContent(
                    title: "Bank Anda",
                    subtitle: "Pilih bank yang anda miliki",
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
                          CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Pilih Akun Trading", children: List.generate(tradingController.tradingAccountModels.value?.response.real?.length ?? 0, (i){
                            return ListTile(
                              onTap: (){
                                Navigator.pop(context);
                                myAccountTrading.text = "${tradingController.tradingAccountModels.value?.response.real?[i].login} - \$${tradingController.tradingAccountModels.value?.response.real?[i].balance}";
                                selectedTradingID(tradingController.tradingAccountModels.value?.response.real?[i].id);
                              },
                              title: Text("${tradingController.tradingAccountModels.value?.response.real?[i].login} - \$${tradingController.tradingAccountModels.value?.response.real?[i].balance}", style: GoogleFonts.inter()),
                            );
                          }));
                        }),
                      ),
                      NumberTextField(controller: myAmount, fieldName: "Jumlah Deposit", hintText: "Jumlah Deposit", labelText: "Jumlah Deposit", maxLength: 1),
                    ]
                  ),

                  UtilitiesWidget.titleContent(
                    title: "Bukti Transfer",
                    subtitle: "Upload foto bukti transfer anda agar proses Deposit dapat kami proses dan dapat dipertanggung jawabkan kebenarannya. Maksimal ukuran file 5 MB dengan format Jpeg, JPG, PNG.",
                    children: [
                      Obx(
                        () => settingController.isLoading.value ? const SizedBox() : UtilitiesWidget.uploadPhoto(isImageOnline: false, title: "Foto KTP", onPressed: () async {
                            selectedPhotoPath(await CustomImagePicker.pickImageFromCameraAndReturnUrl());
                          },
                          urlPhoto: selectedPhotoPath.value
                        ),
                      ),
                    ]
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
