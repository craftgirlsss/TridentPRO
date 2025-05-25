import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
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
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(
        title: "Settings",
        actions: [
          CupertinoButton(
            onPressed: (){},
            child: Icon(MingCute.exit_line, color: CustomColor.defaultColor),
          )
        ]
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/ic_launcher.png'),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white
                        ),
                        child: Icon(CupertinoIcons.camera_fill, color: CustomColor.defaultColor, size: 19)
                      ),
                    )
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(homeController.profileModel.value?.name ?? "Name", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: CustomColor.textThemeLightColor, fontSize: 18), maxLines: 1),
                    Text(homeController.profileModel.value?.email ?? "email@email.com", style: GoogleFonts.inter(color: CustomColor.textThemeLightSoftColor, fontSize: 14), maxLines: 1),
                    const SizedBox(height: 5),
                    SizedBox(
                      height: 20,
                      child: ElevatedButton(
                        onPressed: (){},
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3)
                        ),
                        child: Text("Edit Profile", style: GoogleFonts.inter(fontSize: 10, color: Colors.white))
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
    // return Container(
    //   color: CustomColor.backgroundIcon,
    //   width: size.width,
    //   height: size.height,
    //   child: Center(
    //     child: Obx(() => Text("Settings: ${homeController.profileModel.value?.name}")),
    //   ),
    // );
  }
}
