import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/colors/default.dart';

import 'detail_deposit_withdrawal.dart';

class DepositWithdrawalHistory extends StatefulWidget {
  const DepositWithdrawalHistory({super.key});

  @override
  State<DepositWithdrawalHistory> createState() => _DepositWithdrawalHistoryState();
}

class _DepositWithdrawalHistoryState extends State<DepositWithdrawalHistory> {

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(
        autoImplyLeading: true,
        title: "Riwayat Deposit & Withdrawal"
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Obx(
            () => Column(
            children: List.generate(listHistoryDeposit.length, (i){
              return ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: CustomColor.defaultColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(listHistoryDeposit[i]['isDeposit'] ? AntDesign.arrow_down_outline : AntDesign.arrow_up_outline, size: 30, color: Colors.white),
                ),
                title: Text(listHistoryDeposit[i]['isDeposit'] ? "Deposit" : "Withdrawal", style: GoogleFonts.inter(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                subtitle: Text("\$${listHistoryDeposit[i]['balance']}"),
                trailing: SizedBox(
                  height: 30,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      )
                    ),
                    onPressed: (){
                      Get.to(() => DetailDepositWithdrawal(isDeposit: listHistoryDeposit[i]['isDeposit']));
                    }, child: Text("Lihat", style: GoogleFonts.inter(color: Colors.white))
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
