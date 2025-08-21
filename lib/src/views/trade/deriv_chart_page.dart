import 'dart:async';
import 'dart:collection';
import 'package:deriv_chart/deriv_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tridentpro/src/components/alerts/scaffold_messanger_alert.dart';
import 'package:tridentpro/src/components/bottomsheets/material_bottom_sheets.dart';
import 'package:tridentpro/src/components/buttons/outlined_button.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/textfields/number_textfield.dart';
import 'package:tridentpro/src/controllers/trading.dart';
import 'package:tridentpro/src/views/trade/trading_order_history.dart';

import 'components/chart_section.dart';

class DerivChartPage extends StatefulWidget {
  const DerivChartPage({super.key, required this.login, this.marketName, this.balance});
  final int login;
  final String? marketName;
  final dynamic balance;

  @override
  State<DerivChartPage> createState() => _DerivChartPageState();
}

class _DerivChartPageState extends State<DerivChartPage> with WidgetsBindingObserver {
  final TradingController tradingController = Get.put(TradingController());
  final TextEditingController lotController = TextEditingController();
  final ChartController _controller = ChartController();
  String? marketSymbol; // simbol dari user
  dynamic ohlcData;
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
  bool _isPaused = false;
  AddOnsRepository<IndicatorConfig>? indicatorsRepo;
  Repository<DrawingToolConfig>? _drawingToolsRepo;
  final DrawingTools _drawingTools = DrawingTools();
  DrawingToolConfig? _selectedDrawingTool;
  RxString balanceAccount = "0".obs;

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
    // marketSymbol = widget.marketName; // simbol dari user
    // ohlcData = webSocketController.generateOHLCFromTicks(marketSymbol!, const Duration(minutes: 1));
    tradingController.getTradingAccount().then((result){
      if(tradingController.tradingAccountModels.value?.response.real?.isNotEmpty == true){
        for(int i = 0; i < tradingController.tradingAccountModels.value!.response.real!.length; i++){
          if(widget.login.toString() == tradingController.tradingAccountModels.value!.response.real?[i].login){
            balanceAccount(tradingController.tradingAccountModels.value?.response.real?[i].balance);
          }
        }
      }
    });
    Future.delayed(Duration.zero, () async {
      currentSymbol(widget.marketName ?? "GOLDUD");
      _loadChartData();
      await tradingController.getSymbols().then((result){
        TradingProperty.volumeInit(double.parse(result[0]['volume_min'].toString()));
        // TradingProperty.currentPrice();
      });
      indicatorsRepo = AddOnsRepository<IndicatorConfig>(
        createAddOn: (Map<String, dynamic> map) => IndicatorConfig.fromJson(map),
        onEditCallback: (int index) {},
        sharedPrefKey: 'R_100',
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeDrawingTools();
      });
      WidgetsBinding.instance.addObserver(this);
      _startTimer();
    });
  }

  void _startTimer() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (!_isPaused) {
        _loadChartData();
        updatePrice(currentPrice.value);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Bisa pause kalau app masuk background
    if (state == AppLifecycleState.paused) {
      _isPaused = true;
    } else if (state == AppLifecycleState.resumed) {
      _isPaused = false;
    }
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
          break;
        case TimeFrame.m1:
          granulity(60);
          break;
        case TimeFrame.m30:
          granulity(1800);
          break;
        default:
          granulity(3600);
      }

      if(selectedTf == TimeFrame.h1){

      }
      
      if (result) {
        candleCount.value = tradingController.ohlcDataDeriv.length;
        // Update current price from the last candle
        if (tradingController.ohlcDataDeriv.isNotEmpty) {
          currentPrice.value = tradingController.ohlcDataDeriv.last.close;
        }
        isLoading(false);
      } else {
        debugPrint("Failed to load chart data");
      }
    } catch (e) {
      debugPrint("Error loading chart data: $e");
      isLoading(true);
    }
  }

  void showDrawingToolsDialog() {
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

  Widget buildToolChip(String label, IconData icon) {
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
        title: Column(
          children: [
            Obx(() => Text(currentSymbol.value)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.login.toString(), style: GoogleFonts.inter(fontWeight: FontWeight.w300, color: Colors.black54)),
                const SizedBox(width: 5.0),
                Text("-"),
                const SizedBox(width: 5.0),
                Obx(() => widget.balance != null ? Text(widget.balance) : Text("\$ $balanceAccount"))
              ],
            )
          ],
        ),
        actions: [
          Obx(() => isLoading.value 
            ? Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: CustomColor.defaultColor),
                ),
              )
            : SizedBox(
            height: 30,
            child: CustomOutlinedButton.defaultOutlinedButton(
              onPressed: ()  {
                setState(() => _isPaused = true); // pause timer
                Navigator.push(context, MaterialPageRoute(builder: (_) => TradingOrderHistory(accountID: widget.login)))
                    .then((_) {
                  setState(() => _isPaused = false); // resume timer
                });
              },
              title: "History"
            )),
          ),
          const SizedBox(width: 10)
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return potraitView(size);
          } else {
            return landscapeView(size);
          }
        },
      ),
      bottomNavigationBar: OrientationBuilder(
        builder: (context, orientation) {
          if(orientation == Orientation.portrait){
            return Container(
              padding: EdgeInsets.only(top: 5,  left: 16.0, right: 16.0, bottom: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Obx(() => TradingProperty.sellButton(price: double.tryParse(currentPrice.value.toStringAsFixed(4)), onPressed: (){
                    tradingController.executionOrder(symbol: currentSymbol.value, type: "sell", login: widget.login.toString(), lot: TradingProperty.volumeInit.value.toString(), price: currentPrice.value.toString()).then((result){
                      if(result['status']){
                        CustomScaffoldMessanger.showAppSnackBar(context, message: result['message'], type: SnackBarType.success);
                      }else{
                        CustomScaffoldMessanger.showAppSnackBar(context, message: result['message'], type: SnackBarType.error);
                      }
                    });
                  })),
                  TradingProperty.lotButton(),
                  Obx(() => TradingProperty.buyButton(price: double.tryParse(currentPrice.value.toStringAsFixed(4)), onPressed: () {
                    tradingController.executionOrder(symbol: currentSymbol.value, type: "buy", login: widget.login.toString(), lot: TradingProperty.volumeInit.value.toString(), price: currentPrice.value.toString()).then((result){
                      if(result['status']){
                        CustomScaffoldMessanger.showAppSnackBar(context, message: result['message'], type: SnackBarType.success);
                      }else{
                        CustomScaffoldMessanger.showAppSnackBar(context, message: result['message'], type: SnackBarType.error);
                      }
                    });
                  }))
                ],
              ),
            );
          }
          return SizedBox();
        },
      )
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    lotController.dispose();
    super.dispose();
  }

  final previousPrice = 0.0.obs;

  void updatePrice(double newPrice) {
    previousPrice.value = currentPrice.value; // simpan harga lama
    currentPrice.value = newPrice;            // update harga baru
  }

  Widget landscapeView(Size size){
    return Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.white,
            child: Column(
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
                              debugPrint(selectedTf.name);
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
                                smoothScrolling: true,
                                defaultIntervalWidth: 100,
                                showQuoteGrid: true,
                              ),
                              dataFitEnabled: true,
                              showCrosshair: true,
                              markerSeries: MarkerSeries(
                                planets,
                                markerIconPainter: AccumulatorMarkerIconPainter(),
                                style: MarkerStyle(
                                  backgroundColor: CustomColor.secondaryColor
                                )
                              ),
                              // loadingAnimationColor: CustomColor.defaultColor,
                              showScrollToLastTickButton: true,
                              dataFitPadding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                              isLive: true,
                              theme: ChartDefaultLightTheme(),
                              drawingTools: _drawingTools,
                              mainSeries: CandleSeries(tradingController.ohlcDataDeriv),
                              // mainSeries: CandleSeries(ohlcData),
                              granularity: granulity.value,
                              showDataFitButton: true,
                              pipSize: currentSymbol.value.contains("JPY") || currentSymbol.value.contains("XAU") || currentSymbol.value.contains("GOLD") ? 3 : 5,
                              opacity: 1,
                              drawingToolsRepo: _drawingToolsRepo,
                              showCurrentTickBlinkAnimation: true,
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
          ),
        ),
        const SizedBox(width: 5.0),
        Container(
          padding: EdgeInsets.only(right:5.0),
          width: size.width / 3.3,
          height: size.height,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => TradingProperty.sellButton(price: double.tryParse(currentPrice.value.toStringAsFixed(4)), onPressed: (){
                    tradingController.executionOrder(symbol: currentSymbol.value, type: "sell", login: widget.login.toString(), lot: lotController.text, price: currentPrice.value.toString()).then((result){
                      if(result['status']){
                        CustomScaffoldMessanger.showAppSnackBar(context, message: result['message'], type: SnackBarType.success);
                      }else{
                        CustomScaffoldMessanger.showAppSnackBar(context, message: result['message'], type: SnackBarType.error);
                      }
                    });
                  })),
                  Obx(() => TradingProperty.buyButton(price: double.tryParse(currentPrice.value.toStringAsFixed(4)), onPressed: () {
                    tradingController.executionOrder(symbol: currentSymbol.value, type: "buy", login: widget.login.toString(), lot: lotController.text, price: currentPrice.value.toString()).then((result){
                      if(result['status']){
                        CustomScaffoldMessanger.showAppSnackBar(context, message: result['message'], type: SnackBarType.success);
                      }else{
                        CustomScaffoldMessanger.showAppSnackBar(context, message: result['message'], type: SnackBarType.error);
                      }
                    });
                  }))
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Jumlah Lot"),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: NumberTextField(
                            controller: lotController,
                            readOnly: true,
                            useValidator: false,
                            fieldName: "Lot Size",
                            hintText: "1.0",
                            labelText: "Lot Size",
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: CustomColor.defaultColor,
                            shape: const CircleBorder(),
                          ),
                          onPressed: () {
                            double currentLot = double.tryParse(lotController.text) ?? 1.0;
                            currentLot -= 1.0;
                            if (currentLot < 1) currentLot = 1; // optional: prevent negative lots
                            lotController.text = currentLot.toStringAsFixed(2);
                          },
                          child: const Icon(Icons.remove, color: Colors.white),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: Colors.green,
                            shape: const CircleBorder(),
                          ),
                          onPressed: () {
                            double currentLot = double.tryParse(lotController.text) ?? 1.0;
                            currentLot += 1.0;
                            lotController.text = currentLot.toStringAsFixed(2);
                          },
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Current Price: ", style: GoogleFonts.inter(fontSize: 16.0, color: CustomColor.textThemeLightColor)),
                        Obx(() {
                          Color priceColor = Colors.green; // default
                            if (currentPrice.value > previousPrice.value) {
                              priceColor = Colors.green; // naik
                            } else if (currentPrice.value < previousPrice.value) {
                              priceColor = Colors.red; // turun
                            }
                          String price = currentPrice.value.toStringAsFixed(5); // contoh 1.18757
                          List<String> parts = [
                            price.substring(0, price.length - 3),  // 1.18
                            price.substring(price.length - 3, price.length - 1), // 75
                            price.substring(price.length - 1), // 7
                          ];

                          return RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: parts[0],
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    color: priceColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: parts[1],
                                  style: GoogleFonts.inter(
                                    fontSize: 30,
                                    color: priceColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                WidgetSpan(
                                  child: Transform.translate(
                                    offset: const Offset(0, -8), // posisi naik (superscript)
                                    child: Text(
                                      parts[2],
                                      style: GoogleFonts.inter(
                                        fontSize: 18,
                                        color: priceColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                    // Obx(() => Text("Candle Count: ${candleCount.value}", style: GoogleFonts.inter(fontSize: 16.0, color: CustomColor.textThemeLightColor))),
                    // const SizedBox(height: 10),
                    // Obx(() => Text("Granularity: ${granulity.value} seconds", style: GoogleFonts.inter(fontSize: 16.0, color: CustomColor.textThemeLightColor))),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget potraitView(Size? size){
    return Column(
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
                      debugPrint(selectedTf.name);
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
                        smoothScrolling: true,
                        defaultIntervalWidth: 100,
                        showQuoteGrid: true,
                      ),
                      dataFitEnabled: true,
                      showCrosshair: true,
                      markerSeries: MarkerSeries(
                        planets,
                        markerIconPainter: AccumulatorMarkerIconPainter(),
                        style: MarkerStyle(
                          backgroundColor: CustomColor.secondaryColor
                        )
                      ),
                      // loadingAnimationColor: CustomColor.defaultColor,
                      showScrollToLastTickButton: true,
                      dataFitPadding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                      isLive: true,
                      theme: ChartDefaultLightTheme(),
                      drawingTools: _drawingTools,
                      mainSeries: CandleSeries(tradingController.ohlcDataDeriv),
                      // mainSeries: CandleSeries(ohlcData),
                      granularity: granulity.value,
                      showDataFitButton: true,
                      pipSize: currentSymbol.value.contains("JPY") || currentSymbol.value.contains("XAU") || currentSymbol.value.contains("GOLD") ? 3 : 5,
                      opacity: 1,
                      drawingToolsRepo: _drawingToolsRepo,
                      showCurrentTickBlinkAnimation: true,
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
    );
  }
}
