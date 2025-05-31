import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tridentpro/src/components/alerts/default.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/controllers/home.dart';
import 'package:tridentpro/src/views/authentications/onboarding.dart';
import 'package:tridentpro/src/views/settings/edit_profile.dart';
import 'package:tridentpro/src/views/trade/deposit.dart';
import 'package:tridentpro/src/views/trade/withdrawal.dart';

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
              onPressedPhoto: (){
                Get.to(() => const EditProfile());
              }
              ),
            ),
            const SizedBox(height: 20),

            // Storage Usage Section
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[100],
              ),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: CircularProgressIndicator(
                          value: 0.90,
                          strokeWidth: 6,
                          strokeCap: StrokeCap.round,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(CustomColor.defaultColor),
                        ),
                      ),
                      Text("90%"),
                    ],
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Kelengkapan Profile", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text("Mohon lengkapi profile anda untuk dapat melakukan pendaftaran akun trading"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Review Large Files
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              tileColor: Colors.green[50],
              leading: Icon(Icons.file_present_rounded, color: Colors.green),
              title: Text("Review Large Files"),
              subtitle: Text("Save up to 6GB by reviewing the files that take the most storage."),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            SizedBox(height: 20),

            // Frequently Opened
            Text("Frequently Opened", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                storageCard("Withdrawal", Bootstrap.box_arrow_up, (){
                  Get.to(() => const Withdrawal());
                }),
                storageCard("Deposit", Bootstrap.box_arrow_down, (){
                  Get.to(() => const Deposit());
                }),
                storageCard("Transfer", BoxIcons.bx_transfer_alt, (){}),
                storageCard("Documents", Iconsax.document_outline, (){}),
              ],
            ),
            SizedBox(height: 30),

            // All Items
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Others", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 12),
            listTileItem("Tickets", "Help your problem", LineAwesome.headset_solid),
            listTileItem("FAQ", "All Frequently Asking Question", Bootstrap.question_circle),
            listTileItem("About", "Information about this App", FontAwesome.app_store_brand),
          ],
        ),
      ),
    );
  }

  Widget storageCard(String title, IconData icon, Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: CustomColor.defaultColor),
            SizedBox(height: 8),
            Text(title),
          ],
        ),
      ),
    );
  }

  Widget listTileItem(String title, String subtitle, IconData icon) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      leading: Icon(icon, size: 28),
      title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: GoogleFonts.inter(color: Colors.black54)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}