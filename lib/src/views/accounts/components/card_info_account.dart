import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tridentpro/src/components/buttons/elevated_button.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/containers/icon_container.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/views/accounts/create_real.dart';

Widget doesntHaveAccount({Size? size, bool? isDemo}){
  return Container(
    padding: EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconContainer.defaultIconContainer(
          size: size,
          icon: Clarity.lightbulb_solid
        ),
        const SizedBox(height: 32.0),
        Text(isDemo == true ? LanguageGlobalVar.NOT_HAVE_ACCOUNT_DEMO.tr : LanguageGlobalVar.NOT_HAVE_ACCOUNT_REAL.tr, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18.0), textAlign: TextAlign.center),
        const SizedBox(height: 8.0),
        Text(isDemo == true ? LanguageGlobalVar.NOT_HAVE_ACCOUNT_DEMO_TEXT.tr : LanguageGlobalVar.NOT_HAVE_ACCOUNT_REAL_TEXT.tr, style: GoogleFonts.inter(fontSize: 14.0, color: CustomColor.textThemeDarkSoftColor), textAlign: TextAlign.center),
        const SizedBox(height: 32.0),
        DefaultButton.defaultElevatedButton(onPressed: () => Get.to(() => const CreateReal()), title: "Buka Real Account")
      ],
    ),
  );
}