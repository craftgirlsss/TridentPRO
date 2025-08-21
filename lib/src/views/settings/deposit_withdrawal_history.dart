import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/controllers/user_controller.dart';

import 'detail_deposit_withdrawal.dart';

class DepositWithdrawalHistory extends StatefulWidget {
  const DepositWithdrawalHistory({super.key});

  @override
  State<DepositWithdrawalHistory> createState() => _DepositWithdrawalHistoryState();
}

class _DepositWithdrawalHistoryState extends State<DepositWithdrawalHistory> {

  UserController userController = Get.find();
  RxList<Map<String, dynamic>> listHistoryDeposit = <Map<String, dynamic>>[
    {
    "isDeposit": true,
    "balance": 300,
    },
    {
      "isDeposit": false,
      "balance": 100,
    },
  ].obs;

  bool isDeposit = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      userController.historyWithdrawAndDeposit().then((result){});
    });
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Riwayat Deposit & Withdrawal"),
          bottom: TabBar(
            indicator: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              )
            ),
            splashBorderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: CustomColor.backgroundIcon,
            labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w700),
            tabs: [
              Tab(text: 'Deposit'),
              Tab(text: 'Withdrawal'),
            ],
          ),
        ),
        body: TabBarView(
          physics: const BouncingScrollPhysics(),
          children: [
            buildDepositHistory(),
            buildWithdrawHistory()
          ],
        ),
        // body: SingleChildScrollView(
        //   physics: const BouncingScrollPhysics(),
        //   child: Obx(
        //     () => userController.isLoading.value ? SizedBox(
        //       width: size.width,
        //       height: size.height / 1.2,
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           const CircularProgressIndicator(color: CustomColor.defaultColor),
        //           const SizedBox(height: 10.0),
        //           const Text("Loading...")
        //         ],
        //       ),
        //     ) : Column(
        //       children: List.generate(userController.historyDepoWd.value?.response.length ?? 0, (i){
        //         final result = userController.historyDepoWd.value?.response[i];
        //         return ListTile(
        //           leading: Container(
        //             width: 50,
        //             height: 50,
        //             decoration: BoxDecoration(
        //               color: result?.type == "Deposit" || result?.type == "Deposit New Account" ? CustomColor.secondaryColor : CustomColor.defaultColor,
        //               shape: BoxShape.circle,
        //             ),
        //             child: Icon(result?.type == "Deposit" || result?.type == "Deposit New Account" ? AntDesign.arrow_down_outline : AntDesign.arrow_up_outline, size: 30, color: Colors.white),
        //           ),
        //           title: Text(result?.type ?? "-", style: GoogleFonts.inter(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
        //           subtitle: Text("${result?.amount}"),
        //           trailing: SizedBox(
        //             height: 30,
        //             child: ElevatedButton(
        //               style: ElevatedButton.styleFrom(
        //                 shape: RoundedRectangleBorder(
        //                   borderRadius: BorderRadius.circular(20)
        //                 )
        //               ),
        //               onPressed: (){
        //                 Get.to(() => DetailDepositWithdrawal(index: i, id: result?.id));
        //               }, child: Text("Lihat", style: GoogleFonts.inter(color: Colors.white))
        //             ),
        //           ),
        //         );
        //       }),
        //     ),
        //   ),
        // ),
      )
    );
  }

  Widget buildDepositHistory(){
    return SingleChildScrollView(
      child: Obx(
        () => Column(
          children: List.generate(userController.historyDepoWd.value?.response.length ?? 0, (i){
            final result = userController.historyDepoWd.value?.response[i];
            if(result?.type == "Deposit" || result?.type == "Deposit New Account"){
              return ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: CustomColor.secondaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(AntDesign.arrow_down_outline, color: Colors.white),
                ),
                title: Text(result?.type ?? "-", style: GoogleFonts.inter(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                subtitle: Text("${result?.amount}"),
                trailing: SizedBox(
                  height: 30,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColor.secondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      )
                    ),
                    onPressed: (){
                      Get.to(() => DetailDepositWithdrawal(index: i, id: result?.id));
                    }, child: Text("Lihat", style: GoogleFonts.inter(color: Colors.white))
                  ),
                ),
              );
            }
            return const SizedBox();
          }),
        ),
      ),
    );
  }

  Widget buildWithdrawHistory(){
    return SingleChildScrollView(
      child: Obx(
        () => Column(
          children: List.generate(userController.historyDepoWd.value?.response.length ?? 0, (i){
            final result = userController.historyDepoWd.value?.response[i];
            if(result?.type == "Withdrawal"){
              return ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: CustomColor.secondaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(AntDesign.arrow_up_outline, color: Colors.white),
                ),
                title: Text(result?.type ?? "-", style: GoogleFonts.inter(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                subtitle: Text("${result?.amount}"),
                trailing: SizedBox(
                  height: 30,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColor.secondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      )
                    ),
                    onPressed: (){
                      Get.to(() => DetailDepositWithdrawal(index: i, id: result?.id));
                    }, child: Text("Lihat", style: GoogleFonts.inter(color: Colors.white))
                  ),
                ),
              );
            }
            return const SizedBox();
          }),
        ),
      ),
    );
  }
}
