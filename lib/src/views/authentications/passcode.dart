import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:tridentpro/src/components/buttons/elevated_button.dart';
import 'package:tridentpro/src/components/buttons/outlined_button.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/views/mainpage.dart';

class Passcode extends StatefulWidget {
  const Passcode({super.key});

  @override
  State<Passcode> createState() => _PasscodeState();
}

class _PasscodeState extends State<Passcode> {

  final defaultPinTheme = PinTheme(
    width: 48,
    height: 48,
    textStyle: TextStyle(fontSize: 20, color: CustomColor.textThemeLightSoftColor, fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: CustomColor.textThemeDarkSoftColor),
      borderRadius: BorderRadius.circular(12.0),
    )
  );

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                    child: SizedBox(
                      width: size.width / 2,
                      child: Column(
                        children: [
                          Text(LanguageGlobalVar.SET_PASSCODE.tr, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(LanguageGlobalVar.SET_PASSCODE_TEXT.tr, style: GoogleFonts.inter(fontSize: 13, color: CustomColor.textThemeLightSoftColor), textAlign: TextAlign.center),
                        ],
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50.0),
                    child: Pinput(
                      keyboardType: TextInputType.number,
                      hapticFeedbackType: HapticFeedbackType.mediumImpact,
                      onCompleted: (value) {
                        if(value == "0000"){
                          Get.to(() => const Mainpage());
                        }
                      },
                      defaultPinTheme: defaultPinTheme,
                      length: 4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: size.width,
            height: size.width / 2.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: size.width,
                  child: DefaultButton.defaultElevatedButton(
                      onPressed: (){},
                      title: LanguageGlobalVar.SELANJUTNYA.tr
                  ),
                ),
                SizedBox(
                  width: size.width,
                  child: CustomOutlinedButton.defaultOutlinedButton(
                      title: "Atur Nanti",
                      onPressed: (){}
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
