import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/controllers/trading.dart';
import 'package:get/get.dart';

import 'components/card_info_account.dart';

class DemoSection extends StatefulWidget {
  const DemoSection({super.key});

  @override
  State<DemoSection> createState() => _DemoSectionState();
}

class _DemoSectionState extends State<DemoSection> {
  TradingController tradingController = Get.put(TradingController());

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: CustomColor.defaultColor,
      onRefresh: () async {},
      child: Obx(
        () {
          if(tradingController.isLoading.value){
            return SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Center(child: Text("Getting Demo Account...")),
            );
          }else if(tradingController.tradingAccountModels.value?.response.demo?.length == 0 && tradingController.tradingAccountModels.value?.response.real?.length == 0){
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
                      CardInfoAccount(
                        isDemo: true,
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          return ListView(
            children: List.generate(tradingController.tradingAccountModels.value?.response.demo?.length ?? 0, (i){
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
                  title: Text(tradingController.tradingAccountModels.value?.response.demo?[i].login ?? "-", style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black54)),
                  subtitle: Text(tradingController.tradingAccountModels.value?.response.demo?[i].balance == null ? "\$0" : "\$${tradingController.tradingAccountModels.value!.response.demo![i].balance!.split('.').first}", style: GoogleFonts.inter(fontSize: 17, color: Colors.black45)),
                  trailing: Icon(Icons.keyboard_arrow_right_sharp, size: 25, color: CustomColor.defaultColor),
                  leading: CircleAvatar(
                    backgroundColor: CustomColor.defaultColor,
                    child: Icon(Icons.candlestick_chart, color: Colors.white),
                  ),
                ),
              );
            }),
          );
        }
      ),
    );
  }
}
