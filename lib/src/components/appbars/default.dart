import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tridentpro/src/components/colors/default.dart';

class CustomAppBar {
  static AppBar defaultAppBar({String? title, List<Widget>? actions, bool? autoImplyLeading, PreferredSize? bottom}){
    return AppBar(
      title: Text(title ?? "AppBar"),
      surfaceTintColor: CustomColor.backgroundIcon,
      actions: actions,
      leading: autoImplyLeading == true ? IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back_ios_new_rounded)) : const SizedBox(),
      bottom: bottom,
    );
  }
}