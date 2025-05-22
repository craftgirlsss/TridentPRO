import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/controllers/trading.dart';
import 'components/card_info_account.dart';
import 'package:get/get.dart';

import 'create_real.dart';

class RealSection extends StatefulWidget {
  const RealSection({super.key});

  @override
  State<RealSection> createState() => _RealSectionState();
}

class _RealSectionState extends State<RealSection> {
  TradingController tradingController = Get.put(TradingController());

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {},
      child: Obx(
        (){
          print(tradingController.tradingAccountModels.value?.response.real);
          if(tradingController.tradingAccountModels.value?.response.real == null){
            return SizedBox(
              width: double.infinity,
              height: double.maxFinite,
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      doesntHaveAccount(isDemo: false, size: size)
                    ],
                  ),
                ),
              ),
            );
          }
          return Obx(
            () => ListView(
              children: List.generate((tradingController.tradingAccountModels.value?.response.real?.length ?? 0) + 1, (i){
                final realAccounts = tradingController.tradingAccountModels.value?.response.real ?? [];
                if(i == realAccounts.length){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.to(() => const CreateReal());
                      },
                      icon: Icon(Icons.add_circle_outlined, color: Colors.white),
                      label: Text("Buat Akun Real Baru"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColor.defaultColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    tileColor: Colors.white,
                    onTap: (){},
                    splashColor: CustomColor.defaultColor,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: CustomColor.defaultColor, width: 0.5),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    title: Text(tradingController.tradingAccountModels.value?.response.real?[i].login ?? "-", style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black54)),
                    subtitle: Text(tradingController.tradingAccountModels.value?.response.real?[i].balance == null ? "\$0" : "\$${tradingController.tradingAccountModels.value!.response.real![i].balance!.split('.').first}", style: GoogleFonts.inter(fontSize: 17, color: Colors.black45)),
                    trailing: Icon(Icons.keyboard_arrow_right_sharp, size: 25, color: CustomColor.defaultColor),
                    leading: CircleAvatar(
                      backgroundColor: CustomColor.defaultColor,
                      child: Icon(Icons.candlestick_chart, color: Colors.white),
                    ),
                  ),
                );
              }),
            ),
          );
        }
      ),
    );
  }
}
