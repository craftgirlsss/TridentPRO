import 'package:get/get.dart';
import 'package:tridentpro/src/service/auth_service.dart';

class CompanyController extends GetxController {
  RxBool isLoading = false.obs;
  RxString responseMessage = "".obs;
  AuthService authService = AuthService();

  String profilePerusahaan({String? acc}) {
    return "https://cabinet-tridentprofutures.techcrm.net/export/profile-perusahaan?acc=${acc ?? ''}";
  }

  String pernyataanSimulasi({String? acc}) {return "https://cabinet-tridentprofutures.techcrm.net/export/pernyataan-simulasi?acc=${acc ?? ''}";
  }

  String pernyataanPengalaman({String? acc}) {
    return "https://cabinet-tridentprofutures.techcrm.net/export/pernyataan-pengalaman?acc=${acc ?? ''}";
  }

  String aplikasiPembukaanRekening({String? acc}) {
    return "https://cabinet-tridentprofutures.techcrm.net/export/aplikasi-pembukaan-rekening?acc=${acc ?? ''}";
  }

  String dokumenPemberitahuanAdanyaResiko({String? acc}) {
    return "https://cabinet-tridentprofutures.techcrm.net/export/pemberitahuan-adanya-risiko?acc=${acc ?? ''}";
  }

  String perjanjianPemberianAmanat({String? acc}) {
    return "https://cabinet-tridentprofutures.techcrm.net/export/perjanjian-pemberian-amanat?acc=${acc ?? ''}";
  }

  String tradingRules({String? acc}) {
    return "https://cabinet-tridentprofutures.techcrm.net/export/trading-rules?acc=${acc ?? ''}";
  }

  String personalAccessPassword({String? acc}) {
    return "https://cabinet-tridentprofutures.techcrm.net/export/personal-access-password?acc=${acc ?? ''}";
  }

  String pernyataanDanaNasabah({String? acc}) {
    return "https://cabinet-tridentprofutures.techcrm.net/export/pernyataan-dana-nasabah?acc=${acc ?? ''}";
  }

  String suratPernyataanPenerimaanNasabah({String? acc}) {
    return "https://cabinet-tridentprofutures.techcrm.net/export/surat-pernyataan?acc=${acc ?? ''}";
  }

  String formulirVerifikasiKelengkapan({String? acc}) {
    return "https://cabinet-tridentprofutures.techcrm.net/export/kelengkapan-formulir?acc=${acc ?? ''}";
  }
}