import 'dart:async';
import 'dart:collection';
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
  final ChartController _controller = ChartController();
  final RxBool isLoading = true.obs;
  final RxDouble currentPrice = 0.0.obs;
  final RxDouble lotSize = 0.01.obs;
  Timer? _refreshTimer;
  RxString currentSymbol = "GOLDUD".obs;
  TimeFrame selectedTf = TimeFrame.h1;
  RxInt granulity = 3600.obs;
  final RxInt candleCount = 0.obs;
  RxList<Map<String, dynamic>> indicators = <Map<String, dynamic>>[
    {
      "name" : "MACD",
      "indicator" : MACDIndicatorConfig()
    },
    {
      "name" : "RSI",
      "indicator" : RSIIndicatorConfig()
    },
    {
      "name" : "Aligator",
      "indicator" : AlligatorIndicatorConfig()
    },
    {
      "name" : "Moving Average",
      "indicator" : MAIndicatorConfig()
    },
    {
      "name" : "Stochestic Oscillator",
      "indicator" : StochasticOscillatorIndicatorConfig()
    },
  ].obs;


  RxList<Map<String, dynamic>> drawingTools = <Map<String, dynamic>>[
    {
      "name" : "Line",
      "indicator" : LineDrawingToolConfig()
    },
    {
      "name" : "Horizontal",
      "indicator" : HorizontalDrawingToolConfig()
    },
    {
      "name" : "Vertical",
      "indicator" : VerticalDrawingToolConfig()
    },
    {
      "name" : "Ray",
      "indicator" : RayDrawingToolConfig(),
    },
    {
      "name" : "Trend",
      "indicator" : TrendDrawingToolConfig()
    },
    {
      "name" : "Rectangle",
      "indicator" : RectangleDrawingToolConfig()
    },
    {
      "name" : "Channel",
      "indicator" : ChannelDrawingToolConfig()
    },
    {
      "name" : "Fibbonaci Fan",
      "indicator" : FibfanDrawingToolConfig()
    },
  ].obs;
  final planets = SplayTreeSet<Marker>((a, b) => a.compareTo(b));


  RxBool isInitialized = false.obs;
  AddOnsRepository<IndicatorConfig>? indicatorsRepo;
  Repository<DrawingToolConfig>? _drawingToolsRepo;
  final DrawingTools _drawingTools = DrawingTools();
  DrawingToolConfig? _selectedDrawingTool;

  void _initializeDrawingTools() {
    if (isInitialized.value) {
      return;
    }

    setState(() {
      _drawingToolsRepo = AddOnsRepository<DrawingToolConfig>(
        createAddOn: (Map<String, dynamic> map) => DrawingToolConfig.fromJson(map),
        sharedPrefKey: 'drawing_tools_screen',
      );

      _drawingTools.drawingToolsRepo = _drawingToolsRepo;
      isInitialized(true);
    });
  }


  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _loadChartData();
      await tradingController.getSymbols().then((result){});
      indicatorsRepo = AddOnsRepository<IndicatorConfig>(
        createAddOn: (Map<String, dynamic> map) => IndicatorConfig.fromJson(map),
        onEditCallback: (int index) {},
        sharedPrefKey: 'R_100',
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeDrawingTools();
      });
      _refreshTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        _loadChartData();
      });
    });
  }

  Future<void> _loadChartData() async {
    try {
      final result = await tradingController.getMarketForDerivChart(
        market: currentSymbol.value,
        timeframe: selectedTf.name.toUpperCase(),
      );

      switch(selectedTf){
        case TimeFrame.h1:
          granulity(3600);
        case TimeFrame.m1:
          granulity(60);
        case TimeFrame.m30:
          granulity(1800);
        default:
          granulity(3600);
      }

      if(selectedTf == TimeFrame.h1){}
      
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

  void _showDrawingToolsDialog() {
    if (!isInitialized.value) {
      return;
    }

    _drawingTools.init();

    showDialog<void>(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: DrawingToolsDialog(
          drawingTools: _drawingTools,
        ),
      ),
    );
  }

  void _addDrawingTool() {
    if (!isInitialized.value || _selectedDrawingTool == null) {
      return;
    }

    _drawingTools.onDrawingToolSelection(_selectedDrawingTool!);
    _drawingToolsRepo?.update();
    setState(() {
      _selectedDrawingTool = null;
    });
  }

  Widget _buildToolChip(String label, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(currentSymbol.value)),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Market Symbols", children: List.generate(tradingController.symbols.length, (i){
                          return ListTile(
                            title: Text(tradingController.symbols[i]['symbol'], style: GoogleFonts.inter(color: CustomColor.textThemeLightColor)),
                            onTap: () async {
                              Get.back();
                              currentSymbol.value = tradingController.symbols[i]['symbol'];
                              await _loadChartData();
                            },
                          );
                        }));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6FA),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Obx(() => Text(currentSymbol.value, style: GoogleFonts.inter(color: CustomColor.textThemeLightColor))),
                            Icon(Icons.keyboard_arrow_down, color: CustomColor.textThemeLightSoftColor),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<TimeFrame>(
                      borderRadius: BorderRadius.circular(10),
                      elevation: 1,
                      padding: EdgeInsets.zero,
                      icon: Visibility (visible:false, child: Icon(Icons.arrow_downward)),
                      underline: SizedBox(),
                      value: selectedTf,
                      items: TimeFrame.values.map((tf) => DropdownMenuItem(
                        value: tf,
                        child: Text(tf.name.toUpperCase(), style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                      )).toList(),
                      onChanged: (tf) async {
                        // reloadMarket(timeframe: tf?.name.toUpperCase());
                        await _loadChartData();
                        setState(() {
                          selectedTf = tf!;
                        });
                        print(selectedTf.name);
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Obx(
                        () => isLoading.value ? const SizedBox() : TradingProperty.iconButton(AntDesign.function_outline, (){
                          CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Indicators", children: List.generate(indicators.length, (i){
                            return ListTile(
                              onTap: (){
                                Navigator.pop(context);
                                indicatorsRepo!.add(indicators[i]['indicator']);
                              },
                              title: Text(indicators[i]['name'], style: GoogleFonts.inter()),
                            );
                          }));
                        }),
                      ),
                      Obx(
                        () => isLoading.value ? const SizedBox() : TradingProperty.iconButton(Icons.edit, (){
                          CustomMaterialBottomSheets.defaultBottomSheet(context, size: size, title: "Drawing Tools", children: List.generate(drawingTools.length, (i){
                            return ListTile(
                              onTap: (){
                                Navigator.pop(context);
                                _selectedDrawingTool = drawingTools[i]['indicator'];
                                _selectedDrawingTool != null ? _addDrawingTool : null;
                              },
                              title: Text(drawingTools[i]['name'], style: GoogleFonts.inter()),
                            );
                          }));
                        }),
                      ),
                      TradingProperty.iconButton(Icons.layers, (){}),
                      TradingProperty.iconButton(Icons.tune, (){}),
                      TradingProperty.iconButton(Icons.fullscreen, (){}),
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Obx(() => isLoading.value
              ? Center(child: CircularProgressIndicator(color: CustomColor.defaultColor))
              : Stack(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Obx(
                      () => tradingController.isLoading.value ? const SizedBox() :
                      DerivChart(
                        key: const Key('drawing_tools_chart'),
                        indicatorsRepo: indicatorsRepo,
                        controller: _controller,
                        chartAxisConfig: ChartAxisConfig(
                          showEpochGrid: true,
                          smoothScrolling: true
                        ),
                        dataFitEnabled: true,
                        showCrosshair: true,
                        markerSeries: MarkerSeries(
                          planets,
                          markerIconPainter: AccumulatorMarkerIconPainter(),
                          style: MarkerStyle(
                            backgroundColor: Colors.white
                          )
                        ),
                        loadingAnimationColor: CustomColor.defaultColor,
                        isLive: true,
                        theme: ChartDefaultLightTheme(),
                        drawingTools: _drawingTools,
                        mainSeries: CandleSeries(tradingController.ohlcDataDeriv),
                        granularity: granulity.value,
                        pipSize: 2,
                        opacity: 0.8,
                        activeSymbol: currentSymbol.value,
                        annotations: [
                          HorizontalBarrier(
                            style: HorizontalBarrierStyle(
                              color: Colors.grey,
                              hasArrow: true,
                              arrowSize: 20,
                              titleBackgroundColor: Colors.black45,
                              hasBlinkingDot: true,
                              labelShape: LabelShape.pentagon,
                              blinkingDotColor: Colors.red,
                              secondaryBackgroundColor: Colors.black12
                            ),
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
                tradingController.executionOrder(symbol: currentSymbol.value, type: "sell", login: widget.login.toString(), lot: TradingProperty.volumeInit.value.toString()).then((result) {
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
                tradingController.executionOrder(symbol: currentSymbol.value, type: "buy", login: widget.login.toString(), lot: TradingProperty.volumeInit.value.toString()).then((result) {
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
