import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/appbars/default.dart';

import 'detail_deposit_withdrawal.dart';

class DepositWithdrawalHistory extends StatefulWidget {
  const DepositWithdrawalHistory({super.key});

  @override
  State<DepositWithdrawalHistory> createState() => _DepositWithdrawalHistoryState();
}

class _DepositWithdrawalHistoryState extends State<DepositWithdrawalHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(
        autoImplyLeading: true,
        title: "Riwayat Deposit & Withdrawal"
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: List.generate(2, (i){
            return ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.redAccent[200],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.inbox_rounded, color: Colors.white),
              ),
              title: Text("Deposit", style: GoogleFonts.inter(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
              subtitle: Text("\$100 "),
              trailing: SizedBox(
                height: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    )
                  ),
                  onPressed: (){
                    Get.to(() => const DetailDepositWithdrawal());
                  }, child: Text("Lihat", style: GoogleFonts.inter(color: Colors.white))
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
