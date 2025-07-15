import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/bottomsheets/material_bottom_sheets.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/containers/utilities.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/controllers/company_controller.dart';
import 'package:tridentpro/src/controllers/regol.dart';
import 'package:tridentpro/src/controllers/trading.dart';
import 'package:tridentpro/src/helpers/variables/global_variables.dart';
import 'package:tridentpro/src/views/accounts/pdf_viewers_page.dart';
import 'package:tridentpro/src/views/accounts/step_16_success.dart';
import 'components/step_position.dart';

class Step14PenyelesaianPerselisihan extends StatefulWidget {
  const Step14PenyelesaianPerselisihan({super.key});

  @override
  State<Step14PenyelesaianPerselisihan> createState() => _Step14PenyelesaianPerselisihan();
}

class _Step14PenyelesaianPerselisihan extends State<Step14PenyelesaianPerselisihan> {
  CompanyController companyController = Get.put(CompanyController());
  RegolController regolController = Get.put(RegolController());
  final _formKey = GlobalKey<FormState>();
  RxString selectedAccountTrading = "".obs;
  RxInt selectedIndexAccountTrading = 0.obs;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      regolController.progressAccount().then((result){
        if(result){
          selectedAccountTrading(regolController.accountModel.value?.idHash);
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar.defaultAppBar(
          autoImplyLeading: true,
          title: "Peraturan",
          actions: [
            // CupertinoButton(
            //   onPressed: (){
            //     CustomMaterialBottomSheets.defaultBottomSheet(context, title: "Pilih Akun Trading", size: size, children: List.generate(tradingController.accountTrading.length, (i){
            //       return Obx(
            //         () => ListTile(
            //           title: Text(tradingController.accountTrading[i]['login'] != null ? tradingController.accountTrading[i]['login'].toString() : "0"),
            //           onTap: (){
            //             Get.back();
            //             selectedAccountTrading(tradingController.accountTrading[i]['id'].toString());
            //             selectedIndexAccountTrading(i);
            //             print(selectedAccountTrading);
            //           },
            //           leading: Icon(TeenyIcons.candle_chart, color: CustomColor.defaultColor),
            //           trailing: Icon(AntDesign.arrow_right_outline, color: CustomColor.defaultColor),
            //         ),
            //       );
            //     }));
            //   },
            //   padding: EdgeInsets.zero,
            //   child: Icon(Bootstrap.person_fill_gear, color: CustomColor.defaultColor)
            // ),
            CupertinoButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? accessToken = prefs.getString('accessToken');
                print(accessToken);
                // Get.offAll(() => const Mainpage());
              },
              child: Text(LanguageGlobalVar.CANCEL.tr, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: CustomColor.defaultColor)),
            ),
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
                    title: "Dokumen Persetujuan",
                    subtitle: "Saya menyatakan telah membaca dan menyetujui masing masing dokumen yang dikeluarkan oleh ${GlobalVariable.namaPerusahaan} sebagai berikut:",
                    children: [
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Profile Perusahaan Pialang Berjangka', style: GoogleFonts.inter(fontSize: 16.0)),
                        value: true,
                        onChanged:(bool? value) {
                          Get.to(() => PdfViewerScreen(pdfUrl: companyController.profilePerusahaan(acc: selectedAccountTrading.value), title: "Profil Perusahaan Pialang Berjangka"));
                        },
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Pernyataan Simulasi', style: GoogleFonts.inter(fontSize: 16.0)),
                        value: true,
                        onChanged:(bool? value) {
                          Get.to(() => PdfViewerScreen(pdfUrl: companyController.pernyataanSimulasi(acc: selectedAccountTrading.value), title: "Pernyataan Simulasi"));
                        },
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Pernyataaan Telah Berpengalaman', style: GoogleFonts.inter(fontSize: 16.0)),
                        value: true,
                        onChanged:(bool? value) {
                          Get.to(() => PdfViewerScreen(pdfUrl: companyController.pernyataanPengalaman(acc: selectedAccountTrading.value), title: "Pernyataan Pengalaman"));
                        },
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Pernyataaan Pengungkapan', style: GoogleFonts.inter(fontSize: 16.0)),
                        value: true,
                        onChanged:(bool? value) {
                          Get.to(() => PdfViewerScreen(pdfUrl: companyController.suratPernyataanPenerimaanNasabah(acc: selectedAccountTrading.value), title: "Pernyataaan Pengungkapan"));
                        },
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Aplikasi Pembukaaan Rekening Transaksi', style: GoogleFonts.inter(fontSize: 16.0)),
                        value: true,
                        onChanged:(bool? value) {
                          Get.to(() => PdfViewerScreen(pdfUrl: companyController.aplikasiPembukaanRekening(acc: selectedAccountTrading.value), title: "Aplikasi Pembukaaan Rekening Transaksi"));
                        },
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Dokumen Pemberitahuan Adanya Resiko', style: GoogleFonts.inter(fontSize: 16.0)),
                        value: true,
                        onChanged:(bool? value) {
                          Get.to(() => PdfViewerScreen(pdfUrl: companyController.dokumenPemberitahuanAdanyaResiko(acc: selectedAccountTrading.value), title: "Dokumen Pemberitahuan Adanya Resiko"));
                        },
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Peraturan Perdagangan (Trading Rules)', style: GoogleFonts.inter(fontSize: 16.0)),
                        value: true,
                        onChanged:(bool? value) {
                          Get.to(() => PdfViewerScreen(pdfUrl: companyController.tradingRules(acc: selectedAccountTrading.value), title: "Trading Rules"));
                        },
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Kode Akses', style: GoogleFonts.inter(fontSize: 16.0)),
                        value: true,
                        onChanged:(bool? value) {
                          Get.to(() => PdfViewerScreen(pdfUrl: companyController.personalAccessPassword(acc: selectedAccountTrading.value), title: "Kode Akses"));
                        },
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Pernyataan Sumber Dana Milik Sendiri', style: GoogleFonts.inter(fontSize: 16.0)),
                        value: true,
                        onChanged:(bool? value) {
                          Get.to(() => PdfViewerScreen(pdfUrl: companyController.pernyataanDanaNasabah(acc: selectedAccountTrading.value), title: "Pernyataan Sumber Dana Milik Sendiri"));
                        },
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Pernytaan Penerimtaan Nasabah', style: GoogleFonts.inter(fontSize: 16.0)),
                        value: true,
                        onChanged:(bool? value) {
                          Get.to(() => PdfViewerScreen(pdfUrl: companyController.suratPernyataanPenerimaanNasabah(acc: selectedAccountTrading.value), title: "Pernytaan Penerimtaan Nasabah"));
                        },
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Formulir Verifikasi Kelengkapan', style: GoogleFonts.inter(fontSize: 16.0)),
                        value: true,
                        onChanged:(bool? value) {
                          Get.to(() => PdfViewerScreen(pdfUrl: companyController.formulirVerifikasiKelengkapan(acc: selectedAccountTrading.value), title: "Formulir Verifikasi Kelengkapan"));
                        },
                      ),
                    ]
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: StepUtilities.stepOnlineRegister(
          size: size,
          title: "Dokumen Persetujuan",
          onPressed: (){
            Get.to(() => const SuccessSubmit());
          },
          progressEnd: 4,
          currentAllPageStatus: 3,
          progressStart: 4
        ),
      ),
    );
  }
}

