import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/colors/default.dart';

class UtilitiesWidget {
  static Padding titleContent({required List<Widget> children, String? title, String? subtitle}){
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title ?? "Title", style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
          const SizedBox(height: 5),
          Text(subtitle ?? "Subtitle", style: GoogleFonts.inter(fontSize: 16)),
          const SizedBox(height: 20.0),
          Column(
            children: children,
          )
        ],
      ),
    );
  }

  static GestureDetector uploadPhoto({String? title, String? urlPhoto, Function()? onPressed}){
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15.0),
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black12),
          color: CustomColor.backgroundIcon,
          image: urlPhoto == null ? null : DecorationImage(image: FileImage(File(urlPhoto)), fit: BoxFit.cover)
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white60,
                  border: Border.all(color: Colors.black12),
                ),
                child: Icon(CupertinoIcons.camera_fill, color: CustomColor.defaultColor),
              ),
              const SizedBox(height: 10),
              Text("Please take photo ${title ?? ""}", style: GoogleFonts.inter(color: CustomColor.textThemeLightSoftColor, fontSize: 16.0), textAlign: TextAlign.center)
            ],
          ),
        ),
      ),
    );
  }
}