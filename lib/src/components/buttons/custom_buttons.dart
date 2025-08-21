import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tridentpro/src/components/colors/default.dart';

const Color _primaryColor = Color.fromRGBO(220, 54, 20, 1.0);
const Color _darkThemeButtonColor = Color(0xFFFFFFFF);
const Color _darkThemeTextColor = Colors.black87;
const Color _whiteColor = Colors.white;

class CustomButtons {
  // Private constructor untuk mencegah instansiasi
  CustomButtons._();

  /// Button dengan background 6A3DE8 dan teks putih dengan Google Font Inter.
  static Widget buildFilledButton({
    required String text,
    VoidCallback? onPressed,
    EdgeInsetsGeometry? padding,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColor.secondaryColor,
        foregroundColor: _darkThemeTextColor,
        elevation: 0,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Contoh border radius
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  /// Outlined button dengan background transparan, border 6A3DE8, dan teks 6A3DE8.
  static Widget buildOutlinedButton({
    required String text,
    required VoidCallback onPressed,
    EdgeInsetsGeometry? padding,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: _darkThemeButtonColor, // Warna teks
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        side: const BorderSide(color: CustomColor.secondaryColor, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Contoh border radius
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: CustomColor.secondaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  /// Button dengan ikon seperti button login Google menggunakan icon_plus.
  static Widget buildIconButton({
    required String text,
    required VoidCallback onPressed,
    required IconData icon, // Menggunakan IconData dari icon_plus (misal: BOAIcons.google)
    EdgeInsetsGeometry? padding,
    Color? iconColor,
    Color? textColor,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: iconColor ?? _whiteColor,
      ),
      label: Text(
        text,
        style: GoogleFonts.inter(
          color: textColor ?? _whiteColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor, // Contoh background, bisa disesuaikan
        foregroundColor: _whiteColor,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Button khusus untuk login Google.
  static Widget buildGoogleLoginButton({
    required String text,
    required VoidCallback onPressed,
    EdgeInsetsGeometry? padding,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(
        FontAwesome.google_brand, // Ikon Google dari icon_plus
        color: Colors.black54, // Warna ikon Google yang khas
      ),
      label: Text(
        text,
        style: GoogleFonts.inter(
          color: Colors.black87, // Warna teks untuk button Google
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // Background putih untuk button Google
        foregroundColor: Colors.black87,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.grey, width: 0.5), // Border abu-abu tipis
        ),
        elevation: 0, // Sedikit shadow
      ),
    );
  }
}