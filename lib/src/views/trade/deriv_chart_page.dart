import 'dart:async';
import 'package:deriv_chart/deriv_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tridentpro/src/components/alerts/default.dart';
import 'package:tridentpro/src/components/bottomsheets/material_bottom_sheets.dart';
import 'package:tridentpro/src/components/buttons/outlined_button.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/controllers/trading.dart';
import 'package:tridentpro/src/views/trade/trading_order_history.dart';

import 'components/chart_section.dart';

class DerivChartPage extends StatefulWidget {
  const DerivChartPage({super.key, required this.login});
  final int login;

  @override
  State<DerivChartPage> createState() => _DerivChartPageState();
}

class _DerivChartPageState extends State<DerivChartPage> {
  final TradingController tradingController = Get.find();
  final RxBool isLoading = true.obs;
  final RxDouble currentPrice = 0.0.obs;
  final RxDouble lotSize = 0.01.obs;
  Timer? _refreshTimer;
  String currentSymbol = "GOLDUD";
  String timeframe = "H1";
  final RxInt candleCount = 0.obs;
  RxList indicators = ["SMA", "EMA", "RSI", "WMA"].obs;

  void _handleBuy() {
    Get.snackbar(
      'Buy Order',
      'Placing buy order for $currentSymbol\nLot Size: ${lotSize.value}\nPrice: ${currentPrice.value}',
      backgroundColor: Colors.green.withOpacity(0.9),
      colorText: Colors.white,
    );
  }

  void _handleSell() {
    Get.snackbar(
      'Sell Order',
      'Placing sell order for $currentSymbol\nLot Size: ${lotSize.value}\nPrice: ${currentPrice.value}',
      backgroundColor: Colors.red.withOpacity(0.9),
      colorText: Colors.white,
    );
  }

  Widget _buildTradingControls() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Lot size selector
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Lot: '),
                  Expanded(
                    child: TextFormField(
                      initialValue: lotSize.value.toString(),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (value) {
                        try {
                          final newValue = double.parse(value);
                          if (newValue > 0 && newValue <= 100) {
                            lotSize.value = newValue;
                          }
                        } catch (_) {}
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Buy button
          Expanded(
            flex: 3,
            child: ElevatedButton(
              onPressed: _handleBuy,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('BUY', style: TextStyle(fontWeight: FontWeight.bold)),
                  Obx(() => Text(currentPrice.value.toStringAsFixed(2))),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Sell button
          Expanded(
            flex: 3,
            child: ElevatedButton(
              onPressed: _handleSell,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('SELL', style: TextStyle(fontWeight: FontWeight.bold)),
                  Obx(() => Text(currentPrice.value.toStringAsFixed(2))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Initial load
    _loadChartData();
    
    // Set up periodic refresh
    _refreshTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _loadChartData();
    });
  }

  Future<void> _loadChartData() async {
    try {
      final result = await tradingController.getMarketForDerivChart(
        market: currentSymbol,
        timeframe: timeframe,
      );
      
      if (result) {
        candleCount.value = tradingController.ohlcDataDeriv.length;
        // Update current price from the last candle
        if (tradingController.ohlcDataDeriv.isNotEmpty) {
          currentPrice.value = tradingController.ohlcDataDeriv.last.close;
        }
        isLoading(false);
      } else {
        print("Failed to load chart data");
      }
    } catch (e) {
      print("Error loading chart data: $e");
      isLoading(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(currentSymbol),
        actions: [
          Obx(() => isLoading.value 
            ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : SizedBox(
            height: 30,
            child: CustomOutlinedButton.defaultOutlinedButton(
              onPressed: ()  {
                Get.to(() => TradingOrderHistory(accountID: widget.login));
              },
              title: "History"
            )),
          ),
          const SizedBox(width: 10)
        ],
      ),
      body: Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(
                  () => isLoading.value ? const SizedBox() : TradingProperty.iconButton(AntDesign.function_outline, (){
                    CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Indicators", children: List.generate(indicators.length, (i){
                      return ListTile(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        title: Text(indicators[i], style: GoogleFonts.inter()),
                      );
                    }));
                  }),
                ),
                TradingProperty.iconButton(Icons.edit, (){}),
                TradingProperty.iconButton(Icons.layers, (){}),
                TradingProperty.iconButton(Icons.tune, (){}),
                TradingProperty.iconButton(Icons.fullscreen, (){}),
              ],
            ),
          Expanded(
            child: Obx(() => isLoading.value 
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Obx(
                      () => tradingController.isLoading.value ? const SizedBox() :
                      DerivChart(
                        chartAxisConfig: ChartAxisConfig(
                          showEpochGrid: true,
                          smoothScrolling: true
                        ),
                        loadingAnimationColor: CustomColor.defaultColor,
                        isLive: true,
                        theme: ChartDefaultLightTheme(),
                        drawingTools: DrawingTools(),
                        mainSeries: CandleSeries(tradingController.ohlcDataDeriv),
                        granularity: 3600,
                        pipSize: 2,
                        activeSymbol: currentSymbol,
                        annotations: [
                          HorizontalBarrier(
                            currentPrice.value,
                            visibility: HorizontalBarrierVisibility.keepBarrierLabelVisible,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // _buildTradingControls(),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0,  horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Obx(() => TradingProperty.sellButton(price: double.tryParse(currentPrice.value.toStringAsFixed(2)), onPressed: (){
              CustomAlert.alertDialogCustomInfo(title: "Sell", message: "Apakah anda yakin ingin melanjutkan?", colorPositiveButton: Colors.red, onTap: () {
                Get.back();
                tradingController.executionOrder(symbol: currentSymbol, type: "sell", login: widget.login.toString(), lot: TradingProperty.volumeInit.value.toString()).then((result) {
                  if(result['status'] != true){
                    CustomAlert.alertError(message: result['message']);
                    return false;
                  }
                  CustomAlert.alertDialogCustomSuccess(message: result['message'], onTap: () {
                    Get.back();
                  });
                });
              });
            })),
            SizedBox(width: 8),
            TradingProperty.lotButton(),
            SizedBox(width: 8),
            Obx(() => TradingProperty.buyButton(price: double.tryParse(currentPrice.value.toStringAsFixed(2)), onPressed: () {
              CustomAlert.alertDialogCustomInfo(title: "Buy", message: "Apakah anda yakin ingin melanjutkan?", onTap: () {
                Get.back();
                tradingController.executionOrder(symbol: currentSymbol, type: "buy", login: widget.login.toString(), lot: TradingProperty.volumeInit.value.toString()).then((result) {
                  if(result['status'] != true){
                    CustomAlert.alertError(message: result['message']);
                    return false;
                  }

                  CustomAlert.alertDialogCustomSuccess(message: result['message'], onTap: () {
                    Get.back();
                  });
                });
              });
            }))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
}
