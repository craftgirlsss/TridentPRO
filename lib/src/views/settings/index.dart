import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tridentpro/src/components/alerts/default.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/controllers/authentication.dart';
import 'package:tridentpro/src/controllers/home.dart';
import 'package:tridentpro/src/controllers/user_controller.dart';
import 'package:tridentpro/src/helpers/handlers/image_picker.dart';
import 'package:tridentpro/src/views/accounts/step_14_dokumen_persetujuan.dart';
import 'package:tridentpro/src/views/authentications/signin.dart';
import 'package:tridentpro/src/views/settings/deposit_withdrawal_history.dart';
import 'package:tridentpro/src/views/settings/edit_profile.dart';
import 'package:tridentpro/src/views/settings/faq.dart';
import 'package:tridentpro/src/views/settings/image_viewer_page.dart';
import 'package:tridentpro/src/views/settings/ticket_rooms.dart';
import 'package:tridentpro/src/views/trade/deposit.dart';
import 'package:tridentpro/src/views/trade/internal_transfer.dart';
import 'package:tridentpro/src/views/trade/withdrawal.dart';
import 'about_app.dart';
import 'components/profile_listtile.dart';
import 'components/settings_components.dart';
import 'documents.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  HomeController homeController = Get.find();
  AuthController authController = Get.find();
  RxString selectedImage = "".obs;
  UserController userController = Get.put(UserController());

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
            onPressed: () async {
              userController.getProfile();
              CustomAlert.alertDialogCustomInfo(
                message: "Apakah anda yakin keluar dari aplikasi?",
                moreThanOneButton: true,
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  print(prefs.getString("accessToken"));
                  prefs.remove('accessToken');
                  prefs.remove('refreshToken');
                  prefs.remove('loggedIn');
                  Get.offAll(() => const SignIn());
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
              changedImage: selectedImage.value != "" ? true : false,
              name: homeController.profileModel.value?.name,
              email: homeController.profileModel.value?.email,
              imageOnline: homeController.profileModel.value?.urlPhoto != null ? true : false,
              urlPhoto: selectedImage.value != "" ? selectedImage.value : homeController.profileModel.value?.urlPhoto != null ? homeController.profileModel.value!.urlPhoto : 'assets/images/ic_launcher.png',
              onPressedEdit: (){
                Get.to(() => const EditProfile());
              },
              onPressedPhoto: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageViewerPage(
                      imageUrl: selectedImage.value != "" ? selectedImage.value : homeController.profileModel.value?.urlPhoto != null ? homeController.profileModel.value!.urlPhoto : 'assets/images/ic_launcher.png',
                      title: '${homeController.profileModel.value?.name}\'s Profile Picture',
                    ),
                  ),
                );
              },
              onTapImage: () async {
                print("pressed");
                selectedImage(await CustomImagePicker.pickImageFromCameraAndReturnUrl());
                print(selectedImage.value);
                userController.updateAvatar(urlImage: selectedImage.value).then((result) {
                  if(result){
                    setState(() {
                      userController.getProfile().then((r){
                        print(r);
                      });
                    });
                  }
                });}
              ),
            ),
            const SizedBox(height: 20),

            // Storage Usage Section
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.green[50],
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

            // // Review Large Files
            // ListTile(
            //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            //   tileColor: Colors.green[50],
            //   leading: Icon(Icons.file_present_rounded, color: Colors.green),
            //   title: Text("Review Large Files"),
            //   subtitle: Text("Save up to 6GB by reviewing the files that take the most storage."),
            //   trailing: Icon(Icons.arrow_forward_ios, size: 16),
            //   onTap: () {},
            // ),
            // SizedBox(height: 20),

            // Frequently Opened
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Frequently Opened", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SettingComponents.storageCard("Withdrawal", Bootstrap.box_arrow_up, (){
                  Get.to(() => const Withdrawal());
                }),
                SettingComponents.storageCard("Deposit", Bootstrap.box_arrow_down, (){
                  Get.to(() => const Deposit());
                }),
                SettingComponents.storageCard("Transfer", BoxIcons.bx_transfer_alt, (){
                  Get.to(() => const InternalTransfer());
                }),
                // SettingComponents.storageCard("Internal Documents", ZondIcons.document, (){
                //   Get.to(() => const Step14PenyelesaianPerselisihan());
                // }),
                SettingComponents.storageCard("Documents", Iconsax.document_outline, (){
                  Get.to(() => const Documents());
                }),
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
            SettingComponents.listTileItem("Riwayat Deposit Withdrawal", "Semua riwayat deposit akun trading anda", AntDesign.transaction_outline, onTap: (){
              Get.to(() => const DepositWithdrawalHistory());
            }),
            SettingComponents.listTileItem("Tickets", "Help your problem", LineAwesome.headset_solid, onTap: () async {
              // SharedPreferences prefs = await SharedPreferences.getInstance();
              // prefs.getString('accessToken');
              // Get.to(() => const Tickets());
              Get.to(() => const TicketRooms());
            }),
            SettingComponents.listTileItem("FAQ", "All Frequently Asking Question", Bootstrap.question_circle, onTap: (){
              Get.to(() => const Faq());
            }),
            SettingComponents.listTileItem("About", "Information about this App", FontAwesome.app_store_brand, onTap: (){
              Get.to(() => const AboutApp());
            }),
          ],
        ),
      ),
    );
  }
}