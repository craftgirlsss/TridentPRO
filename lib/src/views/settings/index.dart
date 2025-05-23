import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/controllers/home.dart';
import 'package:tridentpro/src/models/auth/profile.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  HomeController homeController = Get.find();

  @override
  void initState() {
    super.initState();
    homeController.profile();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      color: CustomColor.backgroundIcon,
      width: size.width,
      height: size.height,
      child: Center(
        child: Obx(() => Text("Settings: ${homeController.profileModel.value?.name}")),
      ),
    );
  }
}
