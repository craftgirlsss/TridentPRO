import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/bottomsheets/material_bottom_sheets.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/containers/utilities.dart';
import 'package:tridentpro/src/controllers/company_controller.dart';
import 'package:tridentpro/src/controllers/trading.dart';

class Documents extends StatefulWidget {
  const Documents({super.key, this.loginID});
  final String? loginID;

  @override
  State<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  CompanyController companyController = Get.put(CompanyController());

  final RxList<Map<String, String>> documents = <Map<String, String>>[].obs;
  RxInt selectedIndexAccountTrading = 0.obs;
  RxString selectedAccountTrading = "".obs;
  RxString selectedAccountTradingHash = "".obs;
  TradingController tradingController = Get.put(TradingController());

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      tradingController.getTradingAccount().then((result){

        if(tradingController.tradingAccountModels.value?.response.real?.length != 0){
          selectedAccountTradingHash(tradingController.tradingAccountModels.value?.response.real?[0].id);
          selectedAccountTrading(tradingController.tradingAccountModels.value?.response.real?[0].login);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final data = [
      {
        "name": "Profile Perusahaan",
        "url": "https://cabinet-tridentprofutures.techcrm.net/export/profile-perusahaan?acc=${selectedAccountTradingHash ?? ''}"
      },
      {
        "name": "Pernyataan Simulasi / PERNYATAAN TELAH MELAKUKAN SIMULASI PERDAGANGAN BERJANGKA KOMODITI",
        "url": "https://cabinet-tridentprofutures.techcrm.net/export/pernyataan-simulasi?acc=${selectedAccountTradingHash ?? ''}"
      },
      {
        "name": "Pernyataan Pengalaman / SURAT PERNYATAAN TELAH BERPENGALAMAN MELAKSANAKAN TRANSAKS",
        "url": "https://cabinet-tridentprofutures.techcrm.net/export/pernyataan-pengalaman?acc=${selectedAccountTradingHash ?? ''}"
      },
      {
        "name": "Pernyataan Pengungkapan / Disclosure Statement",
        "url": ""
      },
      {
        "name": "Aplikasi Pembukaan Rekening / APLIKASI PEMBUKAAN REKENING TRANSAKSI SECARA ELEKTRONIK ONLINE",
        "url": "https://cabinet-tridentprofutures.techcrm.net/export/aplikasi-pembukaan-rekening?acc=${selectedAccountTradingHash ?? ''}"
      },
      {
        "name": "Dokumen Pemberitahuan Adanya resiko / DOKUMEN PEMBERITAHUAN ADANYA RISIKO YANG HARUS DISAMPAIKAN OLEH PIALANG BERJANGKA UNTUK TRANSAKSI KONTRAK DERIVATIF DALAM SISTEM PERDAGANGAN ALTERNATIF",
        "url": "https://cabinet-tridentprofutures.techcrm.net/export/pemberitahuan-adanya-risiko?acc=${selectedAccountTradingHash ?? ''}"
      },
      {
        "name": "Perjanjian Pemberian Amanat / PERJANJIAN PEMBERIAN AMANAT SECARA ELEKTRONIK ONLINE UNTUK TRANSAKSI KONTRAK DERIVATIF DALAM SISTEM PERDAGANGAN ALTERNATIF",
        "url": "https://cabinet-tridentprofutures.techcrm.net/export/perjanjian-pemberian-amanat?acc=${selectedAccountTradingHash ?? ''}"
      },
      {
        "name": "Personal Access Password / PERNYATAAN BERTANGGUNG JAWAB ATAS KODE AKSES TRANSAKSI NASABAH",
        "url": "https://cabinet-tridentprofutures.techcrm.net/export/personal-access-password?acc=${selectedAccountTradingHash ?? ''}"
      },
      {
        "name": "Pernyataan Dana Nasabah / PERNYATAAN BAHWA DANA YANG DIGUNAKAN SEBAGAI MARGIN MERUPAKAN DANA MILIK NASABAH SENDIR",
        "url": "https://cabinet-tridentprofutures.techcrm.net/export/pernyataan-dana-nasabah?acc=${selectedAccountTradingHash ?? ''}"
      },
      {
        "name": "Kelengkapan Formulir",
        "url": "https://cabinet-tridentprofutures.techcrm.net/export/kelengkapan-formulir?acc=${selectedAccountTradingHash ?? ''}"
      },
      {
        "name": "Surat Pernyataan Diterima",
        "url": "https://cabinet-tridentprofutures.techcrm.net/export/surat-pernyataan?acc=${selectedAccountTradingHash ?? ''}"
      },
    ];
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(
        title: "",
        autoImplyLeading: true,
        actions: [
          tradingController.tradingAccountModels.value?.response.real?.length != 0 ? CupertinoButton(
            onPressed: (){
              CustomMaterialBottomSheets.defaultBottomSheet(context, title: "Pilih Akun Trading", size: size, children: List.generate(tradingController.tradingAccountModels.value?.response.real?.length ?? 0, (i){
                return Obx(
                  () => ListTile(
                    title: Text(tradingController.accountTrading[i]['login'] != null ? tradingController.accountTrading[i]['login'].toString() : "0"),
                    onTap: (){
                      Get.back();
                      selectedAccountTrading(tradingController.tradingAccountModels.value?.response.real?[i].login.toString());
                      selectedIndexAccountTrading(i);
                      selectedAccountTradingHash(tradingController.tradingAccountModels.value?.response.real?[i].id);
                    },
                    leading: Icon(TeenyIcons.candle_chart, color: CustomColor.defaultColor),
                    trailing: Icon(AntDesign.arrow_right_outline, color: CustomColor.defaultColor),
                  ),
                );
              }));
            },
            padding: EdgeInsets.zero,
            child: Icon(Bootstrap.person_fill_gear, color: CustomColor.defaultColor)
        ).paddingZero : const SizedBox(),
        ]
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: tradingController.tradingAccountModels.value?.response.real?.length == 0 ? [
            SizedBox(
              width: size.width,
              height: size.height / 1.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning_amber_rounded, size: 30, color: Colors.red),
                  const SizedBox(height: 10.0),
                  Text("Anda belum memiliki akun trading real")
                ],
              ),
            )
          ] : [
            Obx(
              () => UtilitiesWidget.titleContent(
                title: "Daftar Dokumen Trading",
                subtitle: "Semua dokumen mengenai akun Trading $selectedAccountTrading anda ada dalam daftar dibawah ini.",
                children: List.generate(data.length, (i){
                  return cardDocument(
                    title: data[i]['name'],
                    onDownload: (){
                      print("${data[i]['url']}$selectedAccountTradingHash");
                      Get.to(() => PdfDownloadAndViewerPage(pdfUrl: "${data[i]['url']}$selectedAccountTradingHash"));
                    }
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

class PdfDownloadAndViewerPage extends StatefulWidget {
  final String pdfUrl;
  const PdfDownloadAndViewerPage({super.key, required this.pdfUrl});

  @override
  State<PdfDownloadAndViewerPage> createState() => _PdfDownloadAndViewerPageState();
}

class _PdfDownloadAndViewerPageState extends State<PdfDownloadAndViewerPage> {
  String? _localFilePath;
  bool _isDownloading = false;
  double _downloadProgress = 0;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _downloadPdf();
  }

  Future<void> _downloadPdf() async {
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0;
      _errorMessage = null;
    });

    try {
      final dio = Dio();
      final directory = await getApplicationDocumentsDirectory(); // Or getExternalStorageDirectory() for external storage
      final fileName = widget.pdfUrl.split('/').last.split('?').first; // Get filename from URL, remove query params
      final filePath = '${directory.path}/$fileName';

      await dio.download(
        widget.pdfUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );

      setState(() {
        _localFilePath = filePath;
        _isDownloading = false;
      });
      print('PDF downloaded to: $filePath');
    } catch (e) {
      setState(() {
        _isDownloading = false;
        _errorMessage = 'Failed to download PDF: $e';
      });
      print('Download error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: Center(
        child: _isDownloading
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text('Downloading: ${(_downloadProgress * 100).toStringAsFixed(1)}%'),
          ],
        )
            : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: _errorMessage != null
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(BoxIcons.bx_error, size: 30.0, color: Colors.red),
                    const SizedBox(height: 10.0),
                    Text("Gagal mendapatkan dokumen", textAlign: TextAlign.justify),
                  ],
                )
                : _localFilePath != null
                ? SfPdfViewer.file(File(_localFilePath!)) // Display the PDF
                : const Text('No PDF to display. Start download.'),
              ),
            ),
      ),
    );
  }
}
