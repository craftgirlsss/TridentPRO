import 'package:flutter/material.dart';
import 'package:tridentpro/src/components/colors/default.dart';

class IconButtons {
  static IconButton defaultIconButton({Function()? onPressed, IconData? icon}){
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: CustomColor.defaultColor),
    );
  }
}