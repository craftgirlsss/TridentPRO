import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/bottomsheets/material_bottom_sheets.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/containers/utilities.dart';
import 'package:tridentpro/src/controllers/trading.dart';

class Documents extends StatefulWidget {
  const Documents({super.key, this.loginID});
  final String? loginID;

  @override
  State<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {

  RxList<String> documents = [
    "Profile Perusahaan",
    "Pernyataan Simulasi / PERNYATAAN TELAH MELAKUKAN SIMULASI PERDAGANGAN BERJANGKA KOMODITI",
    "Pernyataan Pengalaman / SURAT PERNYATAAN TELAH BERPENGALAMAN MELAKSANAKAN TRANSAKS",
    "Pernyataan Pengungkapan / Disclosure Statement",
    "Aplikasi Pembukaan Rekening / APLIKASI PEMBUKAAN REKENING TRANSAKSI SECARA ELEKTRONIK ONLINE",
    "Dokumen Pemberitahuan Adanya resiko / DOKUMEN PEMBERITAHUAN ADANYA RISIKO YANG HARUS DISAMPAIKAN OLEH PIALANG BERJANGKA UNTUK TRANSAKSI KONTRAK DERIVATIF DALAM SISTEM PERDAGANGAN ALTERNATIF",
    "Perjanjian Pemberian Amanat / PERJANJIAN PEMBERIAN AMANAT SECARA ELEKTRONIK ONLINE UNTUK TRANSAKSI KONTRAK DERIVATIF DALAM SISTEM PERDAGANGAN ALTERNATIF",
    "Personal Access Password / PERNYATAAN BERTANGGUNG JAWAB ATAS KODE AKSES TRANSAKSI NASABAH",
    "Pernyataan Dana Nasabah / PERNYATAAN BAHWA DANA YANG DIGUNAKAN SEBAGAI MARGIN MERUPAKAN DANA MILIK NASABAH SENDIR",
    "Kelengkapan Formulir",
    "Surat Pernyataan Diterima"
  ].obs;
  TradingController tradingController = Get.put(TradingController());

  Future<void> loadTradingAccount() async {
    tradingController.accountTrading.value = await tradingController.getTradingAccountV2().then((result) => result);
  }
  RxInt selectedIndexAccountTrading = 0.obs;
  RxString selectedAccountTrading = "-".obs;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      loadTradingAccount().then((result){
        if(widget.loginID != null){
          print("Masuk ke if");
          selectedAccountTrading(widget.loginID);
          for(int i = 0; i < tradingController.accountTrading.length; i++){
            if(tradingController.accountTrading[i]['login'] == widget.loginID){
              selectedIndexAccountTrading(i);
            }
          }
          print(selectedAccountTrading);
          print(selectedIndexAccountTrading);
        }else{
          selectedAccountTrading(tradingController.accountTrading[0]['login'].toString());
          selectedIndexAccountTrading(0);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(
        title: "",
        autoImplyLeading: true,
        actions: [
          CupertinoButton(
            onPressed: (){
              CustomMaterialBottomSheets.defaultBottomSheet(context, title: "Pilih Akun Trading", size: size, children: List.generate(tradingController.accountTrading.length ?? 0, (i){
                return Obx(
                  () => ListTile(
                    title: Text(tradingController.accountTrading[i]['login'] != null ? tradingController.accountTrading[i]['login'].toString() : "0"),
                    onTap: (){
                      Get.back();
                      selectedAccountTrading(tradingController.accountTrading[i]['login'].toString());
                      selectedIndexAccountTrading(i);
                    },
                    leading: Icon(TeenyIcons.candle_chart, color: CustomColor.defaultColor),
                    trailing: Icon(AntDesign.arrow_right_outline, color: CustomColor.defaultColor),
                  ),
                );
              }));
            },
            padding: EdgeInsets.zero,
            child: Icon(Bootstrap.person_fill_gear, color: CustomColor.defaultColor)
        ).paddingZero,
        ]
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Obx(
              () => UtilitiesWidget.titleContent(
                title: "Daftar Dokumen Trading",
                subtitle: "Semua dokumen mengenai akun Trading $selectedAccountTrading anda ada dalam daftar dibawah ini.",
                children: List.generate(documents.length, (i){
                  return cardDocument(
                    title: documents[i],
                    onDownload: (){}
                  );
                })
              ),
            ),
            const SizedBox(height: 60.0)
          ],
        ),
      ),
    );
  }

  Widget cardDocument({String? title, String? description, Function()? onDownload}){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.black12)
      ),
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.description, size: 28, color: CustomColor.defaultColor),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title ?? "Title",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (onDownload != null)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero
                ),
                onPressed: onDownload,
                icon: Icon(EvaIcons.download, color: CustomColor.defaultColor),
                label: Text("Unduh Dokumen", style: GoogleFonts.inter(color: CustomColor.defaultColor, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }
}
