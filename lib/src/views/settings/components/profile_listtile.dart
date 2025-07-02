import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/colors/default.dart';

Widget profileListTile({String? name, String? email, String? urlPhoto, Function()? onPressedPhoto, bool? imageOnline, Function()? onTapImage}){
  return Row(
    children: [
      GestureDetector(
        onTap: onTapImage,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: imageOnline == true ? NetworkImage(urlPhoto!) : AssetImage('assets/images/ic_launcher.png'),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white
                ),
                child: Icon(CupertinoIcons.camera_fill, color: CustomColor.defaultColor, size: 19)
              ),
            )
          ],
        ),
      ),
      const SizedBox(width: 20),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name ?? "Name", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: CustomColor.textThemeLightColor, fontSize: 18), maxLines: 1),
          Text(email ?? "email@email.com", style: GoogleFonts.inter(color: CustomColor.textThemeLightSoftColor, fontSize: 14), maxLines: 1),
          const SizedBox(height: 5),
          SizedBox(
            height: 20,
            child: ElevatedButton(
              onPressed: onPressedPhoto,
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3)
              ),
              child: Text("Edit Profile", style: GoogleFonts.inter(fontSize: 10, color: Colors.white))
            ),
          )
        ],
      )
    ],
  );
}