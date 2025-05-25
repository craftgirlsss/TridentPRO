import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/controllers/trading.dart';
import 'package:tridentpro/src/views/trade/components/chart_section.dart';
import 'package:get/get.dart';

class MarketDetail extends StatefulWidget {
  final String? marketName;
  const MarketDetail({super.key, this.marketName});

  @override
  State<MarketDetail> createState() => _MarketDetailState();
}

class _MarketDetailState extends State<MarketDetail> {
  TimeFrame selectedTf = TimeFrame.h1;
  TrackballBehavior? _trackballBehavior;
  List<OHLCDataModel>? _chartData;
  // late CartesianChartAnnotation _priceBox;
  TradingController tradingController = Get.put(TradingController());
  RxBool showMarket = false.obs;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      showMarket(false);
      tradingController.getMarket(market: "EURUSD").then((result){
        if(result){
          _trackballBehavior = TrackballBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
          );
          _chartData = tradingController.ohlcData;
          // _priceBox = CartesianChartAnnotation(
          //   widget: TradingProperty.buildPriceBox(0),
          //   coordinateUnit: CoordinateUnit.point,
          //   region: AnnotationRegion.chart,
          //   x: tradingController.ohlcData.last.date,         // titik X candle terakhir
          //   y: tradingController.ohlcData.last.close,
          //   horizontalAlignment: ChartAlignment.near
          // );
          showMarket(true);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(title: widget.marketName, autoImplyLeading: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F6FA),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text('EURUSD', style: GoogleFonts.inter(color: CustomColor.textThemeLightColor)),
                              Icon(Icons.keyboard_arrow_down, color: CustomColor.textThemeLightSoftColor),
                            ],
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
                          onChanged: (tf) => setState(() => selectedTf = tf!),
                          ),
                        // Container(
                        //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        //   decoration: BoxDecoration(
                        //     color: const Color(0xFFF5F6FA),
                        //     borderRadius: BorderRadius.circular(8),
                        //   ),
                        //   child: Text('H1', style: GoogleFonts.inter(color: CustomColor.textThemeLightColor)),
                        // ),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TradingProperty.iconButton(AntDesign.function_outline, (){}),
                          TradingProperty.iconButton(Icons.edit, (){}),
                          TradingProperty.iconButton(Icons.layers, (){}),
                          TradingProperty.iconButton(Icons.tune, (){}),
                          TradingProperty.iconButton(Icons.fullscreen, (){}),
                        ],
                      ),
                    )
                  ],
                ),
              ),

            // End of Tool Section

            // Chart Section
            Obx(
              () => tradingController.isLoading.value ? Container(
                width: size.width,
                height: size.height / 1.35,
                decoration: BoxDecoration(border: Border.all(color: CustomColor.textThemeDarkSoftColor)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: CustomColor.defaultColor),
                    const SizedBox(height: 10),
                    Text("Getting Market", style: GoogleFonts.inter())
                  ],
                ),
              ) : showMarket.value ? Container(
                width: size.width,
                height: size.height / 1.4,
                decoration: BoxDecoration(border: Border.all(color: CustomColor.textThemeDarkSoftColor)),
                child: buildHiloOpenClose(maximumPrice: 1.13938, minimumPrice: 1.10666)
              ) : const SizedBox(),
            )
            // End of Chart Section
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0,  horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TradingProperty.sellButton(onPressed: (){}, price: "0.000"),
            SizedBox(width: 8),
            TradingProperty.lotButton(),
            SizedBox(width: 8),
            TradingProperty.buyButton(onPressed: (){}, price: "0.000")
          ],
        ),
      ),
    );
  }

  /// Returns the cartesian High-low-open-close chart.
  SfCartesianChart buildHiloOpenClose({double? minimumPrice, double? maximumPrice, DateTime? dateMax, DateTime? dateMin}) {
    return SfCartesianChart(
      // annotations: <CartesianChartAnnotation>[_priceBox],
      plotAreaBorderWidth: 0,
      zoomPanBehavior: TradingProperty.zoomPan,
      primaryXAxis: buildDateTimeAxis(tf: selectedTf),
      primaryYAxis: NumericAxis(
        opposedPosition: true,
        minimum: minimumPrice ?? 60,
        maximum: maximumPrice ?? 140,
        interval: 3,
        borderColor: Colors.black12,
        labelFormat: r'${value}',
        axisLine: AxisLine(width: 0),
        majorGridLines: MajorGridLines(
          width: 1,                        // ketebalan garis horizontal
          dashArray: <double>[5, 3],       // pola putus-putus
          color: Colors.black12,
        ),
      ),
      series: TradingProperty.buildHiloOpenCloseSeriesAPI(chartData: _chartData),
      trackballBehavior: _trackballBehavior,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _chartData!.clear();
  }
}
