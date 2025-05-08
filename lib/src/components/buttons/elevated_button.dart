import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/colors/default.dart';

class DefaultButton {
  static Padding defaultElevatedButton({String? title, Function()? onPressed}){
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: SizedBox(
        height: 48,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            overlayColor: CustomColor.backgroundLightColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
            backgroundColor: CustomColor.defaultColor,
          ),
          child: Text(title ?? "Submit", style: GoogleFonts.inter(
          color: CustomColor.textThemeDarkColor,
            fontSize: 14,
            fontWeight: FontWeight.bold
          ))
        ),
      ),
    );
  }
}