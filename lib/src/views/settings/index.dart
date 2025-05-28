import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tridentpro/src/components/alerts/default.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/controllers/home.dart';
import 'package:tridentpro/src/models/auth/profile.dart';
import 'package:tridentpro/src/views/authentications/onboarding.dart';

import 'components/profile_listtile.dart';

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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(
        title: "Settings",
        actions: [
          CupertinoButton(
            onPressed: (){
              CustomAlert.alertDialogCustomInfo(
                message: "Apakah anda yakin keluar dari aplikasi?",
                moreThanOneButton: true,
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.remove('accessToken');
                  prefs.remove('refreshToken');
                  prefs.remove('loggedIn');
                  Get.offAll(() => const Onboarding());
                },
                title: "Keluar",
                textButton: "Ya"
              );
            },
            child: Icon(MingCute.exit_line, color: CustomColor.defaultColor),
          )
        ]
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Obx(
            () => profileListTile(
                name: homeController.profileModel.value?.name,
                email: homeController.profileModel.value?.email,
                urlPhoto: 'assets/images/ic_launcher.png',
                onPressedPhoto: (){}
              ),
            )
          ],
        ),
      ),
    );
  }
}
