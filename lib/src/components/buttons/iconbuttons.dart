import 'package:flutter/material.dart';

class IconButtons {
  static IconButton defaultIconButton({Function()? onPressed, IconData? icon}){
    return IconButton(
      onPressed: onPressed,
      style: IconButton.styleFrom(backgroundColor: Colors.grey.shade400),
      icon: Icon(icon, color: Colors.white),
    );
  }
}