import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/containers/utilities.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/helpers/variables/global_variables.dart';
import 'package:tridentpro/src/views/accounts/step_16_success.dart';
import 'components/step_position.dart';

class Step14PenyelesaianPerselisihan extends StatefulWidget {
  const Step14PenyelesaianPerselisihan({super.key});

  @override
  State<Step14PenyelesaianPerselisihan> createState() => _Step14PenyelesaianPerselisihan();
}

class _Step14PenyelesaianPerselisihan extends State<Step14PenyelesaianPerselisihan> {

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
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
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar.defaultAppBar(
            autoImplyLeading: true,
            title: "Peraturan",
            actions: [
              CupertinoButton(
                onPressed: (){},
                child: Text(LanguageGlobalVar.CANCEL.tr, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              )
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
                        onChanged:(bool? value) {},
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Simulasi Trading', style: GoogleFonts.inter(fontSize: 16.0)),
                        value: true,
                        onChanged:(bool? value) {},
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Pernyataaan Telah Berpengalaman', style: GoogleFonts.inter(fontSize: 16.0)),
                        value: true,
                        onChanged:(bool? value) {},
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Pernyataaan Pengungkapan', style: GoogleFonts.inter(fontSize: 16.0)),
                        value: true,
                        onChanged:(bool? value) {},
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Aplikasi Pembukaaan Rekening Transaksi', style: GoogleFonts.inter(fontSize: 16.0)),
                        value: true,
                        onChanged:(bool? value) {},
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Dokumen Pemberitahuan Adanya Resiko', style: GoogleFonts.inter(fontSize: 16.0)),
                        value: true,
                        onChanged:(bool? value) {},
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Peraturan Perdagangan (Trading Rules)', style: GoogleFonts.inter(fontSize: 16.0)),
                        value: true,
                        onChanged:(bool? value) {},
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Kode Akses', style: GoogleFonts.inter(fontSize: 16.0)),
                        value: true,
                        onChanged:(bool? value) {},
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Pernyataan Sumber Dana Milik Sendiri', style: GoogleFonts.inter(fontSize: 16.0)),
                        value: true,
                        onChanged:(bool? value) {},
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

