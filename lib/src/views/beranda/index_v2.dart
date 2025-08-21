import 'dart:async';
import 'dart:math';

import 'package:country_flags/country_flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:tridentpro/src/components/alerts/scaffold_messanger_alert.dart';
import 'package:tridentpro/src/components/bottomsheets/material_bottom_sheets.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/controllers/regol.dart';
import 'package:tridentpro/src/controllers/trading.dart';
import 'package:tridentpro/src/controllers/utilities.dart';
import 'package:tridentpro/src/helpers/formatters/number_formatter.dart';
import 'package:tridentpro/src/helpers/formatters/regex_formatter.dart';
import 'package:tridentpro/src/views/accounts/account_information.dart';
import 'package:tridentpro/src/views/accounts/create_real.dart';
import 'package:tridentpro/src/views/beranda/all_trading_signals.dart';
import 'package:tridentpro/src/views/beranda/lainnya.dart';
import 'package:tridentpro/src/views/beranda/news_detail.dart';
import 'package:tridentpro/src/views/beranda/products_page.dart';
import 'package:tridentpro/src/views/trade/deposit.dart';
import 'package:tridentpro/src/views/trade/deriv_chart_page.dart';
import 'package:tridentpro/src/views/trade/withdrawal.dart';

class IndexV2 extends StatefulWidget {
  const IndexV2({super.key});

  @override
  State<IndexV2> createState() => _IndexV2State();
}

class _IndexV2State extends State<IndexV2> {
  UtilitiesController utilitiesController = Get.put(UtilitiesController());
  TradingController tradingController = Get.put(TradingController());
  RegolController regolController = Get.put(RegolController());
  RxInt selectedIndexAccountTrading = 0.obs;
  RxString selectedAccountTrading = "".obs;
  RxString selectedBalanceAccount = "0".obs;
  RxString selectedTypeAccount = "TridentPRO".obs;
  RxInt selectedEquityAccount = 0.obs;
  RxBool showHideBalance = true.obs;
  RxBool haveDemoAccount = false.obs;
  RxBool haveRealAccount = false.obs;
  Map<String, String>? flag;
  Timer? _timer;
  RxList menus = [
    {
      "app_name"  : 'Produk',
      "icon" : FontAwesome.cubes_solid
    },
    {
      "app_name"  : 'Signals',
      "icon" : FontAwesome.bolt_solid
    },
    {
      "app_name"  : 'Buat Akun',
      "icon" : FontAwesome.plus_solid
    },
    {
      "app_name"  : 'News',
      "icon" : FontAwesome.rss_solid
    },
    {
      "app_name"  : 'Lainnya',
      "icon" : FontAwesome.angles_right_solid
    },
  ].obs;

  void startTradingSignalTimer() {
    final now = DateTime.now();

    // hanya jalan kalau weekday 1–5 (Senin–Jumat)
    if (now.weekday >= 1 && now.weekday <= 5) {
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        _runTradingSignal();
      });
    } else {
      debugPrint("Hari ini weekend, timer tidak dijalankan");
    }
  }

  @override
  void initState() {
    super.initState();
    tradingController.getTradingAccount().then((result){
      _runTradingSignal();
      if(tradingController.tradingAccountModels.value?.response.real?.isNotEmpty == true){
        haveDemoAccount(true);
        haveRealAccount(true);
        selectedAccountTrading(tradingController.tradingAccountModels.value?.response.real?[0].login);
        selectedIndexAccountTrading(0);
        selectedBalanceAccount(tradingController.tradingAccountModels.value?.response.real?[0].balance);
        selectedTypeAccount(tradingController.tradingAccountModels.value?.response.real?[0].namaTipeAkun);
        selectedEquityAccount(tradingController.tradingAccountModels.value?.response.real?[0].marginFree);
      }else{
        haveRealAccount(false);
        if(tradingController.tradingAccountModels.value?.response.demo?.isNotEmpty == true){
          haveDemoAccount(true);
        }else{
          haveDemoAccount(false);
        }
      }
      startTradingSignalTimer();
    });
  }

  void _runTradingSignal() {
    utilitiesController.getTradingSignals().then((result) {
      if (!result) {
        CustomScaffoldMessanger.showAppSnackBar(
          context,
          message: utilitiesController.responseMessage.value,
          type: SnackBarType.warning,
        );
      }
      utilitiesController.getNewsList();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // hentikan timer saat widget dihapus
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.1),
      appBar: AppBar(
        forceMaterialTransparency: true,
        leadingWidth: size.width / 2,
        leading: Obx(
          () => CupertinoButton(
            onPressed: tradingController.tradingAccountModels.value?.response.real?.isEmpty == true ? null : (){
              CustomMaterialBottomSheets.defaultBottomSheet(context, title: "Pilih Akun Trading", size: size, children: List.generate(tradingController.tradingAccountModels.value?.response.real?.length ?? 0, (i){
                final account = tradingController.tradingAccountModels.value?.response.real?[i];
                return ListTile(
                  subtitle: Text("${account?.currency} - ${account?.login ?? "-"}", style: GoogleFonts.inter(fontWeight: FontWeight.w400, color: Colors.black45)),
                  title: Text("${account?.namaTipeAkun ?? "-"} (1:${NumberFormatter.cleanNumber(account?.leverage ?? '0')})", style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                  onTap: (){
                    Get.back();
                    selectedAccountTrading(tradingController.tradingAccountModels.value?.response.real?[i].login);
                    selectedIndexAccountTrading(i);
                    selectedBalanceAccount(tradingController.tradingAccountModels.value?.response.real?[i].balance);
                    selectedTypeAccount(tradingController.tradingAccountModels.value?.response.real?[i].namaTipeAkun);
                    selectedEquityAccount(tradingController.tradingAccountModels.value?.response.real?[i].marginFree);
                  },
                  leading: Icon(Icons.group, color: CustomColor.secondaryColor),
                  trailing: Icon(AntDesign.arrow_right_outline, color: CustomColor.secondaryColor),
                );
              }));
            },
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                CircleAvatar(backgroundImage: AssetImage('assets/images/ic_launcher.png'), radius: 20, backgroundColor: Colors.white),
                const SizedBox(width: 3.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(selectedTypeAccount.value, style: GoogleFonts.inter(fontWeight: FontWeight.w800, color: Colors.black, fontSize: 15), maxLines: 1)),
                    Obx(() => Text(selectedAccountTrading.value, style: GoogleFonts.inter(fontWeight: FontWeight.w400, color: Colors.black45, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis))
                  ],
                ),
                const SizedBox(width: 5.0),
                Icon(Icons.keyboard_arrow_down_rounded, color: CustomColor.secondaryColor)
              ],
            ),
          ),
        ),
        actions: [
          // CupertinoButton(child: Icon(EvaIcons.bell_outline, size: 25, color: CustomColor.secondaryColor), onPressed: (){
          //   Get.to(() => const NotificationsPage());
          // })
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await tradingController.getTradingAccount().then((result){
            utilitiesController.getTradingSignals().then((result){
              if(!result){
                CustomScaffoldMessanger.showAppSnackBar(context, message: utilitiesController.responseMessage.value, type: SnackBarType.warning);
              }
              utilitiesController.getNewsList();
            });
            if(tradingController.tradingAccountModels.value?.response.real?.isNotEmpty == true){
              haveDemoAccount(true);
              haveRealAccount(true);
              selectedAccountTrading(tradingController.tradingAccountModels.value?.response.real?[0].login);
              selectedIndexAccountTrading(0);
              selectedBalanceAccount(tradingController.tradingAccountModels.value?.response.real?[0].balance);
              selectedTypeAccount(tradingController.tradingAccountModels.value?.response.real?[0].namaTipeAkun);
              selectedEquityAccount(tradingController.tradingAccountModels.value?.response.real?[0].marginFree);
            }else{
              haveRealAccount(false);
              if(tradingController.tradingAccountModels.value?.response.demo?.isNotEmpty == true){
                haveDemoAccount(true);
              }else{
                haveDemoAccount(false);
              }
            }
          });
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(16.0),
                width: double.infinity,
                height: size.width / 2.3,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.black26, width: 0.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 1.0,
                      offset: Offset(2.0, 2.0)
                    )
                  ]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Total Balance", style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black54)),
                              Obx(
                                () => CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: selectedAccountTrading.value == "" ? null : (){
                                    showHideBalance.value = !showHideBalance.value;
                                  },
                                  child: Row(
                                    children: [
                                      Obx(() => Text(showHideBalance.value ? "******" : selectedBalanceAccount.value, style: GoogleFonts.inter(fontSize: 25, fontWeight: FontWeight.w800, color: Colors.black))),
                                      const SizedBox(width: 5.0),
                                      Obx(() => showHideBalance.value ? Icon(Icons.lock_outline_rounded, color: Colors.black45, size: 20.0) : Icon(Icons.lock_open_rounded, color: Colors.black45, size: 20.0))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Obx(
                                () => CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: haveRealAccount.value ? (){
                                    Get.to(() => Deposit());
                                  } : (){
                                    CustomScaffoldMessanger.showAppSnackBar(context, message: "Anda belum memiliki akun real", type: SnackBarType.info);
                                  },
                                  child: Column(
                                    children: [
                                      Icon(FontAwesome.circle_arrow_down_solid, size: 30, color: CustomColor.secondaryColor),
                                      const SizedBox(height: 10.0),
                                      Text("Deposit", style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black54))
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20.0),
                              Obx(
                                () => CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: haveRealAccount.value ? (){
                                    Get.to(() => Withdrawal());
                                  } : (){
                                    CustomScaffoldMessanger.showAppSnackBar(context, message: "Anda belum memiliki akun real", type: SnackBarType.info);
                                  },
                                  child: Column(
                                    children: [
                                      Icon(FontAwesome.circle_arrow_up_solid, size: 30, color: CustomColor.secondaryColor),
                                      const SizedBox(height: 10.0),
                                      Text("Withdraw", style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black54))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 50.0,
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            CustomColor.secondaryColor.withOpacity(0.3),
                            CustomColor.secondaryColor.withOpacity(0.2),
                            CustomColor.secondaryColor.withOpacity(0.1),
                          ]
                        )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text("Free Margin: ", style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 17, color: Colors.black)),
                              Obx(() => Text("\$${selectedEquityAccount.value}", style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 17, color: Colors.black))),
                            ],
                          ),
                          Obx(
                            () => CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: haveRealAccount.value ? (){
                                Get.to(() => AccountInformation(loginID: selectedAccountTrading.value));
                              } : () {
                                CustomScaffoldMessanger.showAppSnackBar(context, message: "Anda belum memiliki akun real", type: SnackBarType.info);
                              },
                              child: Text("Lihat Detail", style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 17, color: CustomColor.secondaryColor)),
                            ),
                          )
                        ],
                      )
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 16.0),
                padding: EdgeInsets.symmetric(vertical: 24.0),
                width: double.infinity,
                color: Colors.white,
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(menus.length, (i) {
                      return Expanded(
                        child: CupertinoButton(
                          onPressed: () {
                            final condition = menus[i]['app_name'];
                            if(condition == "Produk"){
                             Get.to(() => const ProductsPage()); 
                            }else if(condition == "Signals"){
                              Get.to(() => const AllTradingSignals());
                            }else if(condition == "Buat Akun"){
                              if(haveDemoAccount.value){
                                Get.to(() => const CreateReal());
                              }else{
                                CustomScaffoldMessanger.showAppSnackBar(context, message: "Anda belum memiliki akun demo, anda akan membuatnya sekarang", type: SnackBarType.info);
                                regolController.createDemoAccount().then((result) {
                                  if(result){
                                    CustomScaffoldMessanger.showAppSnackBar(context, message: "Akun demo berhasil dibuat", type: SnackBarType.success);
                                    tradingController.getTradingAccount().then((result) {
                                      if(result){
                                        haveDemoAccount(true);
                                      }else{
                                        CustomScaffoldMessanger.showAppSnackBar(context, message: tradingController.responseMessage.value, type: SnackBarType.error);
                                        haveDemoAccount(false);
                                      }
                                    });
                                  }else{
                                    CustomScaffoldMessanger.showAppSnackBar(context, message: regolController.responseMessage.value, type: SnackBarType.error);
                                  }
                                }); 
                              }
                            }else if(condition == "Lainnya"){
                              Get.to(() => Lainnya());
                            }else{
                              debugPrint("ERROR ROUTES DIRECTION");
                            }
                          },
                          padding: EdgeInsets.zero,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: CustomColor.backgroundIcon.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  menus[i]['icon'],
                                  color: CustomColor.secondaryColor,
                                  size: 22, // kecilin icon
                                ),
                              ),
                              SizedBox(height: 4),
                              Obx(() => Text(
                                menus[i]['app_name'],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 12, // kecilin font
                                  color: CustomColor.secondaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                              )),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 16.0),
                padding: EdgeInsets.all(16.0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Trading Signal", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 20)),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Text("Lihat Semua", style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: CustomColor.secondaryColor),), onPressed: (){
                            Get.to(() => const AllTradingSignals());
                          })
                      ]
                    ),
                    const SizedBox(height: 10.0),
                    Obx(
                      () => Column(
                        children: List.generate(min(3, utilitiesController.tradingSignal.value?.message?.length ?? 0), (i){
                          flag = RegexFormatter.getFlagsFromPairName(utilitiesController.tradingSignal.value?.message?[i].symbol ?? "EURUSD");
                          final analysis = utilitiesController.tradingSignal.value?.message?[i].analysis;
                          return buildCard(
                            context, size,
                            upper: analysis?.indicators?.bollingerBands?.upper.toString(),
                            lower: analysis?.indicators?.bollingerBands?.lower.toString(),
                            recommendation: utilitiesController.tradingSignal.value?.message?[i].analysis?.recommendation,
                            marketName: utilitiesController.tradingSignal.value?.message?[i].symbol,
                            flagPair: flag?['flag_one'],
                            flagPaired: flag?['flag_two'],
                            bid: analysis?.currentPrice?.bid.toString(),
                            ask: analysis?.currentPrice?.ask.toString(),
                            date: analysis?.lastUpdate != null ? DateFormat("EEEE, dd MMMM yyyy hh:mm:ss").format(DateTime.parse(analysis!.lastUpdate!)) : "-",
                            stopLoss: analysis?.tradingSuggestions?.stopLoss.toString(),
                          );
                        }),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 16.0),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("News", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 20)),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Text("Lihat Semua", style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: CustomColor.secondaryColor),), onPressed: (){}
                        )
                      ]
                    ),
                    const SizedBox(height: 10.0),
                    Obx(
                      () => Column(
                        children: List.generate(min(3, utilitiesController.newsModel.value?.response.length ?? 0), (i){
                          final result = utilitiesController.newsModel.value?.response;
                          if(result?[i].type == "News"){
                            return CupertinoButton(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              onPressed: (){
                                Get.to(() => NewsDetail(idNews: result?[i].id));
                              },
                              child: Container(
                                color: Colors.white,
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        result?[i].picture != null ? Image.network(result![i].picture!, width: 60, fit: BoxFit.cover) : Image.asset('assets/images/logo-rrfx-2.png', width: 60),
                                        const SizedBox(width: 10.0),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('News', style: GoogleFonts.inter(color: Colors.black45)),
                                              Text(result?[i].title ?? '-', style: GoogleFonts.inter(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600), maxLines: 3),
                                              const SizedBox(height: 5.0),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text('Admin', style: GoogleFonts.inter(color: Colors.black45, fontSize: 13.0)),
                                                  Icon(OctIcons.dot, size: 13.0, color: Colors.black45),
                                                  Flexible(child: result?[i].tanggal != null ? Text(DateFormat('EEEE, dd MMMM yyyy').add_jm().format(DateTime.parse(result![i].tanggal!)), style: GoogleFonts.inter(color: Colors.black45, fontSize: 13.0), maxLines: 1, overflow: TextOverflow.ellipsis) : Text(DateFormat('EEEE, dd MMMM yyyy').add_jm().format(DateTime.now()), style: GoogleFonts.inter(color: Colors.black45, fontSize: 13.0), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    const Divider(color: Colors.black12)
                                  ],
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        }),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 16.0),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Fundamentals", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 20)),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Text("Lihat Semua", style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: CustomColor.secondaryColor),), onPressed: (){}
                        )
                      ]
                    ),
                    const SizedBox(height: 10.0),
                    Obx(
                      () => Column(
                        children: List.generate(min(3, utilitiesController.newsModel.value?.response.length ?? 0), (i){
                          final result = utilitiesController.newsModel.value?.response;
                          if(utilitiesController.newsModel.value?.response[i].type != "News"){
                            return CupertinoButton(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              onPressed: (){
                                Get.to(() => NewsDetail(idNews: result?[i].id));
                              },
                              child: Container(
                                color: Colors.white,
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        result?[i].picture != null ? Image.network(result![i].picture!, width: 60, fit: BoxFit.cover) : Image.asset('assets/images/logo-rrfx-2.png', width: 60),
                                        const SizedBox(width: 10.0),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Fundamentals', style: GoogleFonts.inter(color: Colors.black45)),
                                              Text(result?[i].title ?? '-', style: GoogleFonts.inter(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600), maxLines: 3),
                                              const SizedBox(height: 5.0),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text('Admin', style: GoogleFonts.inter(color: Colors.black45, fontSize: 13.0)),
                                                  Icon(OctIcons.dot, size: 13.0, color: Colors.black45),
                                                  Flexible(child: result?[i].tanggal != null ? Text(DateFormat('EEEE, dd MMMM yyyy').add_jm().format(DateTime.parse(result![i].tanggal!)), style: GoogleFonts.inter(color: Colors.black45, fontSize: 13.0), maxLines: 1, overflow: TextOverflow.ellipsis) : Text(DateFormat('EEEE, dd MMMM yyyy').add_jm().format(DateTime.now()), style: GoogleFonts.inter(color: Colors.black45, fontSize: 13.0), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    const Divider(color: Colors.black12)
                                  ],
                                ),
                              ),
                            ); 
                          }
                          return const SizedBox();
                        }),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(BuildContext context, Size size, {String? marketName, String? flagPair, String? flagPaired, String? date, String? stopLoss, String? bid, String? recommendation, String? ask, String? sma10, String? sma20, String? sma50, String? priceVsSMA, String? histogram, String? signalLine, String? macdLine, String? upper, String? lower, String? middle, String? pricePosition, String? rsi, String? signalSummaryRSI, String? signalSummaryMACD, String? signalSummarySMA, String? signalSummaryBollingerBands, List? tradingAccountUser}){
    Color? color;
    IconData? icon;
    switch(recommendation!.toUpperCase()){
      case "BUY":
        color = Colors.green.shade400;
        icon = OctIcons.arrow_up_right;
        break;
      case "STRONG SELL":
        color = Colors.pink;
        icon = OctIcons.arrow_down_right;
        break;
      case "STRONG BUY":
        color = Colors.green;
        icon = OctIcons.arrow_up_right;
        break;
      case "SELL":
        color = Colors.red;
        icon = OctIcons.arrow_down_right;
        break;
      case "NEUTRAL":
        color = Colors.purple;
        icon = Icons.line_axis;
        break;
      default:
        color = Colors.blue;
        break;
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 40,
                          child: Stack(
                            children: [
                              Positioned(
                                right: 0,
                                child: CountryFlag.fromCountryCode(
                                  flagPaired ?? 'CH',
                                  width: 28,
                                  shape: const Circle(),
                                ),
                              ),
                              CountryFlag.fromCountryCode(
                                flagPair ?? 'AU',
                                width: 28,
                                shape: const Circle(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        Text(marketName ?? "AUDCHF", style: GoogleFonts.inter(fontWeight: FontWeight.w800))
                      ],
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Iconsax.clock_outline, color: Colors.black45, size: 12.0),
                          const SizedBox(width: 3.0),
                          Flexible(child: Text(date ?? '', overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 10.0)))
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Take Profit
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bid",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          bid ?? "0.0",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 15.0),
                    // Stop Loss
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ask",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          ask ?? "0.0",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 15.0),
                    // Sumber
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "High",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          upper ?? '0.0',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 15.0),
                    // Sumber
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Low",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          lower ?? "0.0",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text("Potensi"),
              CupertinoButton(
                onPressed: (){
                  if(haveRealAccount.value){
                    if(selectedAccountTrading.value != ""){
                      Get.to(() => DerivChartPage(login: int.parse(selectedAccountTrading.value), marketName: marketName));
                    }else{
                      CustomScaffoldMessanger.showAppSnackBar(context, message: "Anda belum memiliki atau memilih akun trading");
                    }
                  }else{
                    CustomScaffoldMessanger.showAppSnackBar(context, message: "Anda belum memiliki akun real", type: SnackBarType.info);
                  }
                },
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: color
                  ),
                  child: Icon(icon, color: Colors.white, size: 30)
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}