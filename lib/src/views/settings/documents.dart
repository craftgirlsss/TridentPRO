import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/containers/utilities.dart';

class Documents extends StatefulWidget {
  const Documents({super.key});

  @override
  State<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(
        title: "",
        autoImplyLeading: true
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            UtilitiesWidget.titleContent(
              title: "Daftar Dokumen Trading",
              subtitle: "Semua dokumen mengenai akun anda ada dalam daftar dibawah ini.",
              children: List.generate(3, (i){
                return cardDocument(
                  onDownload: (){}
                );
              })
            )
          ],
        ),
      ),
    );
  }

  Widget cardDocument({String? title, String? description, Function()? onDownload}){
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.description, size: 28, color: Colors.blue),
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
            const SizedBox(height: 10),
            Text(
              description ?? "description",
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            if (onDownload != null)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onDownload,
                  icon: Icon(EvaIcons.download, color: CustomColor.defaultColor),
                  label: Text("Unduh Dokumen", style: GoogleFonts.inter(color: CustomColor.defaultColor, fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
