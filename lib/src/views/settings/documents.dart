import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/bottomsheets/material_bottom_sheets.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/containers/utilities.dart';
import 'package:tridentpro/src/controllers/company_controller.dart';
import 'package:tridentpro/src/controllers/trading.dart';
import 'package:tridentpro/src/views/accounts/pdf_viewers_page.dart';

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

  Future<void> loadTradingAccount() async {
    tradingController.accountTrading.value = await tradingController.getTradingAccountV2().then((result) => result);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      loadTradingAccount().then((result){
        selectedAccountTradingHash(tradingController.accountTrading[0]['id']);
        final data = [
          {
            "name": "Profile Perusahaan",
            "url": companyController.profilePerusahaan()
          },
          {
            "name": "Pernyataan Simulasi / PERNYATAAN TELAH MELAKUKAN SIMULASI PERDAGANGAN BERJANGKA KOMODITI",
            "url": companyController.pernyataanSimulasi()
          },
          {
            "name": "Pernyataan Pengalaman / SURAT PERNYATAAN TELAH BERPENGALAMAN MELAKSANAKAN TRANSAKS",
            "url": companyController.pernyataanPengalaman()
          },
          {
            "name": "Pernyataan Pengungkapan / Disclosure Statement",
            "url": companyController.suratPernyataanPenerimaanNasabah()
          },
          {
            "name": "Aplikasi Pembukaan Rekening / APLIKASI PEMBUKAAN REKENING TRANSAKSI SECARA ELEKTRONIK ONLINE",
            "url": companyController.aplikasiPembukaanRekening()
          },
          {
            "name": "Dokumen Pemberitahuan Adanya resiko / DOKUMEN PEMBERITAHUAN ADANYA RISIKO YANG HARUS DISAMPAIKAN OLEH PIALANG BERJANGKA UNTUK TRANSAKSI KONTRAK DERIVATIF DALAM SISTEM PERDAGANGAN ALTERNATIF",
            "url": companyController.dokumenPemberitahuanAdanyaResiko()
          },
          {
            "name": "Perjanjian Pemberian Amanat / PERJANJIAN PEMBERIAN AMANAT SECARA ELEKTRONIK ONLINE UNTUK TRANSAKSI KONTRAK DERIVATIF DALAM SISTEM PERDAGANGAN ALTERNATIF",
            "url": companyController.perjanjianPemberianAmanat()
          },
          {
            "name": "Personal Access Password / PERNYATAAN BERTANGGUNG JAWAB ATAS KODE AKSES TRANSAKSI NASABAH",
            "url": companyController.personalAccessPassword()
          },
          {
            "name": "Pernyataan Dana Nasabah / PERNYATAAN BAHWA DANA YANG DIGUNAKAN SEBAGAI MARGIN MERUPAKAN DANA MILIK NASABAH SENDIR",
            "url": companyController.pernyataanDanaNasabah()
          },
          {
            "name": "Kelengkapan Formulir",
            "url": companyController.formulirVerifikasiKelengkapan()
          },
          {
            "name": "Surat Pernyataan Diterima",
            "url": companyController.suratPernyataanPenerimaanNasabah()
          },
        ];
        documents.addAll(data);
        if(widget.loginID != null){
          selectedAccountTrading(widget.loginID);
          for(int i = 0; i < tradingController.accountTrading.length; i++){
            if(tradingController.accountTrading[i]['login'] == widget.loginID){
              selectedIndexAccountTrading(i);
            }
          }
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
              CustomMaterialBottomSheets.defaultBottomSheet(context, title: "Pilih Akun Trading", size: size, children: List.generate(tradingController.accountTrading.length, (i){
                return Obx(
                  () => ListTile(
                    title: Text(tradingController.accountTrading[i]['login'] != null ? tradingController.accountTrading[i]['login'].toString() : "0"),
                    onTap: (){
                      Get.back();
                      selectedAccountTrading(tradingController.accountTrading[i]['login'].toString());
                      selectedIndexAccountTrading(i);
                      selectedAccountTradingHash(tradingController.accountTrading[i]['id']);
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
                    title: documents[i]['name'],
                    onDownload: (){
                      Get.to(() => PermissionHandlerScreen(documentURL: "${documents[i]['url']}$selectedAccountTradingHash", title: documents[i]['name']!));
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


class PermissionHandlerScreen extends StatefulWidget {
  final String? documentURL;
  final String? title;
  const PermissionHandlerScreen({Key? key, this.documentURL, this.title}) : super(key: key);

  @override
  State<PermissionHandlerScreen> createState() => _PermissionHandlerScreenState();
}

class _PermissionHandlerScreenState extends State<PermissionHandlerScreen> {
  bool _permissionsGranted = false;
  bool _isLoading = true;
  String _permissionMessage = 'Checking permissions...';

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    setState(() {
      _isLoading = true;
      _permissionMessage = 'Requesting necessary permissions...';
    });

    // List to hold permissions to request
    List<Permission> permissionsToRequest = [
      Permission.camera, // For CAMERA
    ];

    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 33) {
        // Android 13 (API 33) and above: Use granular media permissions
        permissionsToRequest.add(Permission.photos); // For READ_MEDIA_IMAGES
        // You might also add Permission.videos, Permission.audio if needed
      } else {
        // Android 12 (API 32) and below: Use Permission.storage
        permissionsToRequest.add(Permission.storage); // For READ_EXTERNAL_STORAGE, WRITE_EXTERNAL_STORAGE
      }
    } else if (Platform.isIOS) {
      // On iOS, Permission.storage maps to Photos permission for saving to gallery.
      // For general app documents, getApplicationDocumentsDirectory() doesn't need explicit permission.
      permissionsToRequest.add(Permission.photos); // For saving images/files to Photos
    }

    // Request all permissions at once
    Map<Permission, PermissionStatus> statuses = await permissionsToRequest.request();

    bool allGranted = true;
    List<String> deniedPermissions = [];
    bool permanentlyDenied = false;

    statuses.forEach((permission, status) {
      if (status.isDenied) {
        allGranted = false;
        deniedPermissions.add(permission.toString().split('.').last);
      } else if (status.isPermanentlyDenied) {
        allGranted = false;
        permanentlyDenied = true;
        deniedPermissions.add(permission.toString().split('.').last);
      }
    });

    if (allGranted) {
      setState(() {
        _permissionsGranted = true;
        _isLoading = false;
      });
      // Navigate to your main content or PdfViewerScreen
      _navigateToPdfViewer();
    } else {
      setState(() {
        _isLoading = false;
        if (permanentlyDenied) {
          _permissionMessage = 'Some permissions are permanently denied: ${deniedPermissions.join(', ')}. Please enable them manually in app settings.';
          _showPermissionDeniedDialog(permanentlyDenied: true);
        } else {
          _permissionMessage = 'Required permissions denied: ${deniedPermissions.join(', ')}. Please grant them to use this feature.';
          _showPermissionDeniedDialog(permanentlyDenied: false);
        }
      });
    }
  }

  void _showPermissionDeniedDialog({required bool permanentlyDenied}) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must interact with the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Required'),
          content: Text(_permissionMessage),
          actions: <Widget>[
            if (permanentlyDenied)
              TextButton(
                child: const Text('Open Settings'),
                onPressed: () {
                  openAppSettings(); // Opens app settings
                  Navigator.of(context).pop(); // Close dialog
                },
              ),
            TextButton(
              child: const Text('Retry'),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _requestPermissions(); // Try requesting again
              },
            ),
            TextButton(
              child: const Text('Exit App'),
              onPressed: () {
                // You might want to exit the app or show a limited functionality view
                Navigator.of(context).pop();
                // For a real app, consider SystemNavigator.pop() or similar
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToPdfViewer() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => PdfViewerScreen(
          pdfUrl: widget.documentURL ?? '', // Replace with your actual PDF URL
          title: widget.title ?? '-',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Permissions'),
      ),
      body: Center(
        child: _isLoading
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(_permissionMessage),
          ],
        )
            : _permissionsGranted
            ? const Text('All permissions granted! Redirecting...')
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _permissionMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _requestPermissions(),
              child: const Text('Re-request Permissions'),
            ),
          ],
        ),
      ),
    );
  }
}
