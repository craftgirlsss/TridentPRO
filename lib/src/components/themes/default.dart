import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/colors/default.dart';

class CustomTheme{

  // ======== Main Default Theme ==========
  static ThemeData defaultLightTheme(){
    return ThemeData(
      appBarTheme: defaultAppbarThemeLight(),
      iconTheme: defaultIconThemeDataLight(),
      colorScheme: ColorScheme.light(),
      segmentedButtonTheme: defaultSegmentedButtonLight(),
      elevatedButtonTheme: defaultElevatedButtonTheme(),
      brightness: Brightness.light,
      useMaterial3: true,
      dividerTheme: defaultDividerThemeDark(),
      iconButtonTheme: defaultIconButtonThemeLight()
      // textButtonTheme: defaultTextButtonThemeData()
    );
  }

  static ThemeData defaultDarkTheme(){
    return ThemeData(
      appBarTheme: defaultAppbarThemeDark(),
      iconTheme: defaultIconThemeDataDark(),
      colorScheme: ColorScheme.dark(),
      elevatedButtonTheme: defaultElevatedButtonTheme(),
      segmentedButtonTheme: defaultSegmentedButtonDark(),
      brightness: Brightness.dark,
      useMaterial3: true,
      dividerTheme: defaultDividerThemeDark(),
      iconButtonTheme: defaultIconButtonThemeDark()
      // textButtonTheme: defaultTextButtonThemeData()
    );
  }

  // ======== Start Appbar Theme Section ==========
  static AppBarTheme defaultAppbarThemeLight(){
    return AppBarTheme(
      actionsIconTheme: defaultIconThemeDataLight(),
      foregroundColor: CustomColor.textThemeDarkColor,
      iconTheme: IconThemeData(
        color: CustomColor.textThemeLightColor
      ),
      centerTitle: true,
      elevation: 0,
      titleTextStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: CustomColor.textThemeLightColor),
    );
  }

  static AppBarTheme defaultAppbarThemeDark(){
    return AppBarTheme(
      actionsIconTheme: defaultIconThemeDataDark(),
      foregroundColor: CustomColor.textThemeDarkColor,
      iconTheme: IconThemeData(
        color: CustomColor.textThemeDarkColor
      ),
      centerTitle: true,
      elevation: 0,
      titleTextStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14),
    );
  }
  // ======== End Appbar Theme Section ==========


  // ======== Start Icon Theme Section ==========
  static IconThemeData defaultIconThemeDataLight(){
    return IconThemeData(
      color: CustomColor.defaultColor,
    );
  }

  static IconThemeData defaultIconThemeDataDark(){
    return IconThemeData(
      color: CustomColor.backgroundDarkColor,
    );
  }
  // ======== End Appbar Theme Section ==========


  // ======== Start Icon Theme Section ==========
  static IconButtonThemeData defaultIconButtonThemeLight(){
    return IconButtonThemeData(
      style: IconButton.styleFrom(
        elevation: 0,
        foregroundColor: CustomColor.textThemeLightColor
      )
    );
  }

  static IconButtonThemeData defaultIconButtonThemeDark(){
    return IconButtonThemeData(
        style: IconButton.styleFrom(
          elevation: 0,
          foregroundColor: CustomColor.textThemeDarkColor
        )
    );
  }
  // ======== End Appbar Theme Section ==========

  // ======== Start ElevatedButtonThemeData Section ==========
  static ElevatedButtonThemeData defaultElevatedButtonTheme(){
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        alignment: Alignment.center,
        elevation: 0,
        backgroundColor: CustomColor.defaultColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
        ),
        iconColor: CustomColor.textThemeLightColor,
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: CustomColor.backgroundLightColor
        )
      )
    );
  }
  // ======== End ElevatedButtonThemeData Section ==========

  // ======== Start ElevatedButtonThemeData Section ==========
  static DividerThemeData defaultDividerThemeLight(){
    return DividerThemeData(
      color: CustomColor.backgroundIcon
    );
  }

  static DividerThemeData defaultDividerThemeDark(){
    return DividerThemeData(
        color: CustomColor.textThemeDarkSoftColor
    );
  }
// ======== End ElevatedButtonThemeData Section ==========

  // ======== Start ElevatedButtonThemeData Section ==========
  static SegmentedButtonThemeData defaultSegmentedButtonDark(){
    return SegmentedButtonThemeData(
      style: ButtonStyle(
        side: WidgetStatePropertyAll(BorderSide(color: CustomColor.defaultColor)),
        textStyle: WidgetStatePropertyAll(GoogleFonts.inter(color: CustomColor.textThemeDarkSoftColor)),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return CustomColor.backgroundIconSoftDark;
          }
          return Colors.transparent;
        }),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      ),
    );
  }

  static SegmentedButtonThemeData defaultSegmentedButtonLight(){
    return SegmentedButtonThemeData(
      style: ButtonStyle(
        side: WidgetStatePropertyAll(BorderSide(color: CustomColor.defaultColor)),
        textStyle: WidgetStatePropertyAll(GoogleFonts.inter()),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return CustomColor.backgroundIcon;
          }
          return Colors.transparent;
        }),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      ),
    );
  }
// ======== End ElevatedButtonThemeData Section ==========
}