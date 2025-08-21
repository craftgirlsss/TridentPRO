import 'package:flutter/cupertino.dart';
import 'package:tridentpro/src/components/colors/default.dart';

class IconContainer {
  static Container defaultIconContainer({Size? size, IconData? icon}){
    return Container(
      width: size!.width / 3,
      height: size.width / 3,
      decoration: BoxDecoration(
        color: CustomColor.backgroundIcon,
        borderRadius: BorderRadius.circular(24.0)
      ),
      child: Center(
        child: Icon(icon, color: CustomColor.secondaryColor),
      ),
    );
  }
}