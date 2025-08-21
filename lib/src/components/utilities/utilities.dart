import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:url_launcher/url_launcher.dart';

class UtilitiesComponents {

  //Privacy Policy Text
  static RichText privacyPolicy(BuildContext context, {TextAlign? textAlign}){
    return RichText(
      textAlign: textAlign ?? TextAlign.center,
      text: TextSpan(
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white70),
        children: [
          const TextSpan(text: 'Dengan mendaftar, Anda menyetujui ', style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.normal,
            ),),
          TextSpan(
            text: 'Kebijakan Privasi',
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                const url = 'https://www.rrfx.com/privacy';
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                }
              },
          ),
          const TextSpan(text: ' dan ', style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.normal,
            ),),
          TextSpan(
            text: 'Syarat & Ketentuan',
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                const url = 'https://www.rrfx.com/privacy';
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                }
              },
          ),
          const TextSpan(text: ' aplikasi TridentPRO.', style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.normal,
            ),),
        ],
      ),
    );
  }

  // KaryaDeveloperIndonesia Text Recognizer
  static GestureDetector rrfx(BuildContext context){
    return GestureDetector(
        onTap: () async {
          const url = 'https://tridentprofutures.com';
          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
          }
        },
        child: Column(
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "PT. Tridentpro Investasi Berjangka ",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                  ),
                  TextSpan(
                    text: "Terlisensi dan Teregulasi oleh",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset('assets/images/bappebti.png', width: 55),
                Image.asset('assets/images/jfx.png', width: 55),
                Image.asset('assets/images/kilangberjangka.png', width: 55),
                Image.asset('assets/images/ojk.png', width: 55),
              ],
            )
          ],
        )
    );
  }
  

  static Column titlePage(BuildContext context, {String? title, String? subtitle}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset('assets/images/ic_launcher.png', width: 40),
            const SizedBox(width: 10.0),
            Text(title ?? "TridentPRO", style: GoogleFonts.inter(color: Colors.black54, fontSize: 40, fontWeight: FontWeight.w700)),
          ],
        ),
        Text(subtitle ?? "Mulai Pengalaman Trading Forex, Komoditi dan Indeks Saham jadi lebih tenang dengan strategi yang tepat bersama TridentPRO.", style: TextStyle(color: Colors.black45, fontSize: 15, fontWeight: FontWeight.w600)),
      ],
    );
  }

  static Row checkBoxAgreement(BuildContext context, {RxBool? checkedRead}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Obx(
          () => Checkbox(
            value: checkedRead?.value,
            onChanged: (value) => checkedRead?.value = !checkedRead.value,                                
            checkColor: Colors.white, // Warna icon centang
            fillColor: checkedRead?.value == true ? WidgetStatePropertyAll(CustomColor.secondaryColor) : WidgetStatePropertyAll(Colors.white),
            side: BorderSide(
              width: 1.0,
              color: checkedRead?.value == true
                ? CustomColor.secondaryColor
                : CustomColor.textThemeDarkSoftColor, // ← warna border dinamis
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
        ),
        Flexible(child: UtilitiesComponents.privacyPolicy(context, textAlign: TextAlign.start))
      ],
    );
  }
}