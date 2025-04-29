import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/colors/default.dart';

class CustomTheme{

  // ======== Main Default Theme ==========
  static ThemeData defaultLightTheme(){
    return ThemeData(
      appBarTheme: defaultAppbarThemeLight(),
      iconTheme: defaultIconThemeData(),
      colorScheme: ColorScheme.light(),
      elevatedButtonTheme: defaultElevatedButtonTheme(),
      brightness: Brightness.light,
      useMaterial3: true,
      dividerTheme: defaultDividerThemeDark(),
      iconButtonTheme: defaultIconButtonTheme()
      // textButtonTheme: defaultTextButtonThemeData()
    );
  }

  static ThemeData defaultDarkTheme(){
    return ThemeData(
      appBarTheme: defaultAppbarThemeDark(),
      iconTheme: defaultIconThemeData(),
      colorScheme: ColorScheme.dark(),
      elevatedButtonTheme: defaultElevatedButtonTheme(),
      brightness: Brightness.dark,
      useMaterial3: true,
      dividerTheme: defaultDividerThemeDark(),
      iconButtonTheme: defaultIconButtonTheme()
      // textButtonTheme: defaultTextButtonThemeData()
    );
  }

  // ======== Start Appbar Theme Section ==========
  static AppBarTheme defaultAppbarThemeLight(){
    return AppBarTheme(
      centerTitle: true,
      iconTheme: IconThemeData(
        color: CustomColor.defaultColor
      ),
      color: CustomColor.backgroundLightColor
    );
  }

  static AppBarTheme defaultAppbarThemeDark(){
    return AppBarTheme(
        centerTitle: true,
        iconTheme: IconThemeData(
            color: CustomColor.defaultColor
        ),
        color: CustomColor.backgroundDarkColor
    );
  }
  // ======== End Appbar Theme Section ==========


  // ======== Start Icon Theme Section ==========
  static IconThemeData defaultIconThemeData(){
    return IconThemeData(
      color: CustomColor.defaultColor,
    );
  }

  static IconThemeData defaultIconThemeDataWhite(){
    return IconThemeData(
      color: Colors.white,
    );
  }
  // ======== End Appbar Theme Section ==========


  // ======== Start Icon Theme Section ==========
  static IconButtonThemeData defaultIconButtonTheme(){
    return IconButtonThemeData(
      style: IconButton.styleFrom(
        elevation: 0,
        backgroundColor: CustomColor.defaultColor
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
}