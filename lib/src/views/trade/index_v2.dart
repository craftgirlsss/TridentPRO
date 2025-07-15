import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tridentpro/src/components/bottomsheets/material_bottom_sheets.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/controllers/trading.dart';
import 'package:tridentpro/src/controllers/utilities.dart';
import 'package:get/get.dart';
import 'package:tridentpro/src/helpers/formatters/currency.dart';
import 'deriv_chart_page.dart';

class MetaQuotesPage extends StatefulWidget {
  const MetaQuotesPage({super.key});

  @override
  State<MetaQuotesPage> createState() => _MetaQuotesPageState();
}

class _MetaQuotesPageState extends State<MetaQuotesPage> {
  final double appBarHeight = 66.0;
  Timer? _refreshTimer;
  UtilitiesController utilitiesController = Get.put(UtilitiesController());
  TradingController tradingController = Get.find();
  RxInt selectedIndexAccountTrading = 0.obs;
  RxString selectedAccountTrading = "-".obs;
  RxString selectedBalanceAccount = "0".obs;


  int lengthString = 0;

  // cari titik dari angka 1.42423
  // hitung berapa karakter dari belakang titik
  // jika lebih dari sama dengan 2, ambil 3 dari belakang
  // ambil 2 karakter dari 3 karakter di belakang
  //

  Future<void> loadTradingAccount() async {
    tradingController.accountTrading.value = await tradingController.getTradingAccountV2().then((result) => result);
  }


  @override
  void initState() {
    super.initState();
    if(tradingController.accountTrading.isNotEmpty){
      print("Masuk ke IF karena accountTrading isNotEmpty");
      Future.delayed(Duration.zero, (){
        loadTradingAccount().then((result){
          selectedAccountTrading(tradingController.accountTrading[0]['login'].toString());
          selectedIndexAccountTrading(0);
          selectedBalanceAccount(tradingController.accountTrading[0]['balance'].toString());
        });
        utilitiesController.getMarketPrice().then((r){
          if(r){
            _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
              utilitiesController.getMarketPrice();
            });
          }
        });
      });
    }
    print("Masuk ke ELSE karena accountTrading isEmpty");
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).padding.top;
    final size = MediaQuery.of(context).size;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          actionsPadding: EdgeInsets.zero,
          backgroundColor: CustomColor.defaultColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon(Clarity.bars_line, color: Colors.white),
              Row(
                children: [
                  Icon(Icons.wallet, color: Colors.white),
                  const SizedBox(width: 5.0),
                  Text("My Digital Currency", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                ],
              ),
              CupertinoButton(
                onPressed: (){
                  CustomMaterialBottomSheets.defaultBottomSheet(context, title: "Pilih Akun Trading", size: size, children: List.generate(tradingController.accountTrading.length, (i){
                    return Obx(
                      () => ListTile(
                        title: Text(tradingController.accountTrading[i]['login'] != null ? tradingController.accountTrading[i]['login'].toString() : "0"),
                        onTap: (){
                          Get.back();
                          selectedAccountTrading(tradingController.accountTrading[i]['login'].toString());
                          selectedIndexAccountTrading(i);
                          selectedBalanceAccount(tradingController.accountTrading[i]['balance'].toString());
                        },
                        leading: Icon(TeenyIcons.candle_chart, color: CustomColor.defaultColor),
                        trailing: Icon(AntDesign.arrow_right_outline, color: CustomColor.defaultColor),
                      ),
                    );
                  }));
                },
                padding: EdgeInsets.zero,
                child: Icon(Bootstrap.person_fill_gear, color: Colors.white)
              ),
            ],
          ),
          pinned: true,
          expandedHeight: 210.0,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: CustomColor.defaultColor,
              padding: EdgeInsets.only(top: appBarHeight),
              height: appBarHeight + paddingTop,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Balance", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white60)),
                    Obx(() => Text(selectedAccountTrading.value, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white))),
                    Obx(() => Text("\$${selectedBalanceAccount.value}", style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white))),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text("+24.93%", style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.white70)),
                    //     Icon(Bootstrap.arrow_up, color: Colors.white70, size: 14)
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),

        Obx(
          () => utilitiesController.marketModel.value?.message.length == null ? SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  width: 200,
                  height: size.height / 1.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.candlestick_chart_rounded, color: CustomColor.defaultColor),
                      const SizedBox(height: 10),
                      Text("Tidak ada market"),
                    ],
                  ),
                ),
              ]
            ),
          ) : SliverList(
            delegate: SliverChildListDelegate(
              List.generate(utilitiesController.marketModel.value?.message.length ?? 0, (i){
                // PriceParts bid = processAndExtractPriceParts(utilitiesController.marketModel.value?.message[i].bid != null ? utilitiesController.marketModel.value!.message[i].bid.toString() : "0", currency: utilitiesController.marketModel.value?.message[i].currency ?? "EURUSD");
                // PriceParts ask = processAndExtractPriceParts(utilitiesController.marketModel.value?.message[i].ask != null ? utilitiesController.marketModel.value!.message[i].ask.toString() : "0", currency: utilitiesController.marketModel.value?.message[i].currency ?? "EURUSD");
                return CupertinoButton(
                  onPressed: (){
                    Get.to(() => DerivChartPage(login: tradingController.accountTrading[selectedIndexAccountTrading.value]['login'] ?? 0, marketName: utilitiesController.marketModel.value?.message[i].currency));
                  },
                  padding: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() => Text(utilitiesController.marketModel.value?.message[i].currency ?? "EURUSD", style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 17))),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.space_bar_rounded, size: 12, color: Colors.black38),
                                const SizedBox(width: 3),
                                Text(utilitiesController.marketModel.value?.message[i].spread != null ? utilitiesController.marketModel.value!.message[i].spread.toString() : "0", style: GoogleFonts.inter(fontWeight: FontWeight.w400, color: Colors.black38, fontSize: 10))
                              ],
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // BID Price
                                PriceDisplayWidget(
                                  fullPriceString: formatPrices(utilitiesController.marketModel.value?.message[i].bid != null ? utilitiesController.marketModel.value!.message[i].bid.toString() : "0", currency: "USD"), // Hasilnya "1.15490"
                                ),
                                const SizedBox(width: 10),
                                // ASK Price
                                PriceDisplayWidget(
                                  fullPriceString: formatPrices(utilitiesController.marketModel.value?.message[i].ask != null ? utilitiesController.marketModel.value!.message[i].ask.toString() : "0", currency: "USD"), // Hasilnya "1.15490"
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() => Text("L: ${utilitiesController.marketModel.value?.message[i].low != null ? utilitiesController.marketModel.value!.message[i].low.toString() : '0'}", style: GoogleFonts.inter(fontWeight: FontWeight.w400, color: Colors.black38, fontSize: 10))),
                                const SizedBox(width: 10),
                                Obx(() => Text("H: ${utilitiesController.marketModel.value?.message[i].high != null ? utilitiesController.marketModel.value!.message[i].high.toString() : '0'}", style: GoogleFonts.inter(fontWeight: FontWeight.w400, color: Colors.black38, fontSize: 10))),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              })
            )
          ),
        )
      ],
    );
  }
}


