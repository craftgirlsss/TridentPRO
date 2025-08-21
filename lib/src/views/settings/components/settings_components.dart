import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/colors/default.dart';

class SettingComponents {
  static Widget storageCard(String title, IconData icon, Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: CustomColor.secondaryColor),
            SizedBox(height: 8),
            Text(title),
          ],
        ),
      ),
    );
  }

  static Widget listTileItem(String title, String subtitle, IconData icon, {Function()? onTap}) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      leading: Icon(icon, size: 28),
      title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15)),
      subtitle: Text(subtitle, style: GoogleFonts.inter(color: Colors.black54)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}