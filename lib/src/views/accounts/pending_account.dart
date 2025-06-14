import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:tridentpro/src/controllers/home.dart';

import 'create_real.dart';

class PendingAccount extends StatefulWidget {
  const PendingAccount({super.key});

  @override
  State<PendingAccount> createState() => _PendingAccountState();
}

class _PendingAccountState extends State<PendingAccount> {
  HomeController homeController = Get.find();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      homeController.getPendingAccount().then((result){
        if(!result){
          print(homeController.responseMessage.value);
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => homeController.isLoading.value
        ? SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(AntDesign.loading_3_quarters_outline),
                const SizedBox(height: 5),
                Text("Getting Pending...", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700))
              ],
            ),
          )
        : homeController.pendingModel.value?.response?.length == 0
          ? SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(HeroIcons.trash),
                  SizedBox(height: 5),
                  Text("Tidak ada akun pending", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700))
                ],
              ),
            )
          : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            itemCount: homeController.pendingModel.value?.response?.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  switch(homeController.pendingModel.value?.response?[index].status){
                    case "Regol belum selesai": // Regol belum diselesaikan
                      Get.to(() => const CreateReal());
                      break;
                    case "Register": // Sudah regol, menunggu admin accepting
                      break;
                    case "Deposit New Account": // Sesudah di acc WPB, menunggu nasabah deposit
                      break;
                    case "Waiting Deposit": // Deposit nasabah dalam proses verifikasi oleh admin
                      break;
                    case "Good Fund": // Pemberian password dan username meta melalui email
                      break;
                    case "Active":
                      break;
                    default:
                      break;
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12, width: 0.6),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(homeController.pendingModel.value?.response?[index].type ?? "-", style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 18)),
                        ],
                      ),
                      const Divider(color: Colors.black12),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Product", style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 16, color: Colors.black45)),
                          Flexible(child: Text(homeController.pendingModel.value?.response?[index].product ?? "-", style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14))),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Currency", style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 16, color: Colors.black45)),
                          Flexible(child: Text(homeController.pendingModel.value?.response?[index].currency ?? "-", style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14))),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Rate", style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 16, color: Colors.black45)),
                          Flexible(child: Text(homeController.pendingModel.value?.response?[index].rate ?? "-", style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14))),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Status", style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 16, color: Colors.black45)),
                          Flexible(child: Text(homeController.pendingModel.value?.response?[index].status ?? "-", style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14))),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Date", style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 16, color: Colors.black45)),
                          Flexible(child: Text(homeController.pendingModel.value?.response?[index].dateCreated != null ? DateFormat("EEEE, dd MMM yyyy").format(DateTime.parse(homeController.pendingModel.value!.response![index].dateCreated!)) : "-", style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14))),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Time", style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 16, color: Colors.black45)),
                          Flexible(child: Text(homeController.pendingModel.value?.response?[index].dateCreated != null ? DateFormat().add_jms().format(DateTime.parse(homeController.pendingModel.value!.response![index].dateCreated!)) : "-", style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14))),
                        ],
                      ),
                    ],
                  ),
                ),
              );
        },
      ),
    );
  }
}
