import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/colors/default.dart';

class UtilitiesWidget {
  static Padding titleContent({required List<Widget> children, String? title, String? subtitle, TextAlign? textAlign}){
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title ?? "Title", style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
          const SizedBox(height: 5),
          Text(subtitle ?? "Subtitle", style: GoogleFonts.inter(fontSize: 16), textAlign: textAlign ?? TextAlign.start),
          const SizedBox(height: 20.0),
          Column(
            children: children,
          )
        ],
      ),
    );
  }

  static GestureDetector uploadPhoto({String? title, String? urlPhoto, Function()? onPressed, bool? isImageOnline}){
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15.0),
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CustomColor.backgroundIcon.withOpacity(0.5),
          image: (urlPhoto != null && urlPhoto.isNotEmpty) ? isImageOnline == true ? DecorationImage(image: NetworkImage(urlPhoto), fit: BoxFit.cover) : DecorationImage(
            image: FileImage(File(urlPhoto)),
            fit: BoxFit.cover
          ) : null
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white38,
                ),
                child: Icon(CupertinoIcons.camera_fill, color: CustomColor.secondaryColor),
              ),
              const SizedBox(height: 10),
              Text("Please take photo ${title ?? ""}", style: GoogleFonts.inter(color: CustomColor.secondaryColor, fontSize: 16.0), textAlign: TextAlign.center)
            ],
          ),
        ),
      ),
    );
  }

  static GestureDetector uploadPhotoV2({
    String? title,
    String? urlPhoto,
    Function()? onPressed,
    bool? isImageOnline,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15.0),
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CustomColor.backgroundIcon.withOpacity(0.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: (urlPhoto != null && urlPhoto.isNotEmpty)
              ? isImageOnline == true
                  ? Image.network(
                      urlPhoto,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return buildPlaceholder(title);
                      },
                    )
                  : Image.file(
                      File(urlPhoto),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return buildPlaceholder(title);
                      },
                    )
              : buildPlaceholder(title),
        ),
      ),
    );
  }

  static Widget buildPlaceholder(String? title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white38,
            ),
            child: Icon(
              CupertinoIcons.camera_fill,
              color: CustomColor.secondaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Please take photo ${title ?? ""}",
            style: GoogleFonts.inter(
              color: CustomColor.secondaryColor,
              fontSize: 16.0,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

}
