import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/controllers/trading.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

enum TimeFrame { m1, m30, h1, h4, d1, mn1 }
DateTimeAxis buildDateTimeAxis({
  required TimeFrame tf,
  DateTime? min,
  DateTime? max,
  Color gridColor = const Color(0xFFCCCCCC),
}) {
  // fallback: pakai rentang 1 minggu terakhir bila tak diberi min/max
  min ??= DateTime.now().subtract(const Duration(days: 7));
  max ??= DateTime.now();

  switch (tf) {
    case TimeFrame.m1:
      return DateTimeAxis(
        intervalType: DateTimeIntervalType.minutes,
        interval: 1,
        dateFormat: DateFormat('HH:mm'),
        minimum: min,
        maximum: max,
        majorGridLines: MajorGridLines(
          width: 1,
          dashArray: const [4, 2],
          color: gridColor,
        ),
      );

    case TimeFrame.m30:
      return DateTimeAxis(
        intervalType: DateTimeIntervalType.minutes,
        interval: 30,
        dateFormat: DateFormat('dd MMM HH'),
        minimum: min,
        maximum: max,
        majorGridLines: MajorGridLines(
          width: 1,
          dashArray: const [4, 2],
          color: gridColor,
        ),
      );

    case TimeFrame.h1:
      return DateTimeAxis(
        intervalType: DateTimeIntervalType.hours,
        interval: 1,
        dateFormat: DateFormat('HH:mm'),
        // minimum: min,
        // maximum: max,
        // majorGridLines: MajorGridLines(
        //   width: 0,
        //   dashArray: const [4, 2],
        //   color: gridColor,
        // ),
      );

    case TimeFrame.h4:
      return DateTimeAxis(
        intervalType: DateTimeIntervalType.hours,
        interval: 4,
        dateFormat: DateFormat('HH:mm'),
        minimum: min,
        maximum: max,
        majorGridLines: MajorGridLines(
          width: 1,
          dashArray: const [4, 2],
          color: gridColor,
        ),
      );

    case TimeFrame.d1:
      return DateTimeAxis(
        intervalType: DateTimeIntervalType.days,
        interval: 1,
        dateFormat: DateFormat('dd MMM'),
        minimum: min,
        maximum: max,
        majorGridLines: MajorGridLines(
          width: 1,
          dashArray: const [4, 2],
          color: gridColor,
        ),
      );

    case TimeFrame.mn1:
      return DateTimeAxis(
        intervalType: DateTimeIntervalType.months,
        interval: 1,
        dateFormat: DateFormat('MMM yyyy'),
        minimum: min,
        maximum: max,
        majorGridLines: MajorGridLines(
          width: 1,
          dashArray: const [4, 2],
          color: gridColor,
        ),
      );
  }
}


class TradingProperty {
  static RxDouble volumeInit = 0.01.obs;
  static RxDouble currentPrice = 0.0.obs;
  static RxDouble volumeMin = 0.00.obs;
  static RxDouble volumeMax = 100.0.obs;

  static void incrementLot() {
    if((volumeInit.value + 0.01) <= volumeMax.value) {
      volumeInit.value += 0.01;
    }
  }

  static void decrementLot() {
    if((volumeInit.value - 0.01) >= volumeMin.value) {
      volumeInit.value -= 0.01;
    }
  }

  // WebSocket Connector
  static Future<void> websocketConnect() async {
    final wsUrl = Uri.parse('wss://ws.derivws.com/websockets/v3?app_id=74855');
    final channel = WebSocketChannel.connect(wsUrl);

    await channel.ready;

    channel.stream.listen((message) {
      channel.sink.add('received!');
      channel.sink.close(status.goingAway);
    });
  }

  static Widget buildPriceBox(double price, Color? color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        // color: price >= previousPrice ? Colors.green : Colors.red,
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        price.toStringAsFixed(5),
        style: const TextStyle(color: Colors.white, fontSize: 11),
      ),
    );
  }

  static CartesianChartAnnotation buildPriceBoxAnnotation(double price, num x) {
    return CartesianChartAnnotation(
      widget: buildPriceBox(price, Colors.green),
      coordinateUnit: CoordinateUnit.point,
      region: AnnotationRegion.chart,
      x: x, // titik candle terakhir
      y: price, // level harga
      horizontalAlignment: ChartAlignment.near, // nempel ke kanan
    );
  }

  static CartesianChartAnnotation buildPriceLineAnnotation(double price) {
    return CartesianChartAnnotation(
      widget: Container(
        width: double.infinity,          // bentang penuh (akan dipotong chart)
        height: 1,
        color: Colors.redAccent,         // samakan warna dengan kotak (opsional)
      ),
      coordinateUnit: CoordinateUnit.logicalPixel, // pakai pixel agar mendatar
      region: AnnotationRegion.chart,
      x: 0,
      y: price,
      horizontalAlignment: ChartAlignment.center, // bentang full lebar chart
    );
  }

  static final ZoomPanBehavior zoomPan = ZoomPanBehavior(
    enablePinching: true,         // pinch-zoom (2-finger) di ponsel / trackpad
    enablePanning: true,          // drag grafik untuk menggeser (pan)
    enableMouseWheelZooming: true,// zoom pakai scroll wheel / trackpad scroll
    enableDoubleTapZooming: true, // double-tap untuk zoom-in
    zoomMode: ZoomMode.xy ,        // X saja, Y saja, atau keduanya (xy)
  );

  static Widget iconButton(IconData icon, Function() onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6FA),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 20, color: Colors.black54),
      ),
    );
  }

  // OHLC Series
  static List<HiloOpenCloseSeries<OHLCDataModel, DateTime>> buildHiloOpenCloseSeriesAPI({List<OHLCDataModel>? chartData}) {
    return <HiloOpenCloseSeries<OHLCDataModel, DateTime>>[
      HiloOpenCloseSeries<OHLCDataModel, DateTime>(
        animationDuration: 0,
        dataSource: chartData,
        xValueMapper: (OHLCDataModel sales, _) => sales.date as DateTime,
        lowValueMapper: (OHLCDataModel data, int index) => data.low,
        highValueMapper: (OHLCDataModel data, int index) => data.high,
        openValueMapper: (OHLCDataModel data, int index) => data.open,
        closeValueMapper: (OHLCDataModel data, int index) => data.close,
        showIndicationForSameValues: true,
        name: 'EURUSD',
      ),
    ];
  }

  // Candle Series
  static List<CartesianSeries<OHLCDataModel, DateTime>> buildCandleSeries({List<OHLCDataModel>? chartCandleData}) {
    return <CartesianSeries<OHLCDataModel, DateTime>>[
      CandleSeries<OHLCDataModel, DateTime>(
        dataSource: chartCandleData,
        xValueMapper: (OHLCDataModel data, int index) => data.date,
        highValueMapper: (OHLCDataModel data, int index) => data.high,
        lowValueMapper: (OHLCDataModel data, int index) => data.low,
        openValueMapper: (OHLCDataModel data, int index) => data.open,
        closeValueMapper: (OHLCDataModel data, int index) => data.close,
        width: 1,
        borderRadius: BorderRadius.zero,
        spacing: 0.1,
        isVisibleInLegend: true,
        enableSolidCandles: true,
        bearColor: Colors.red,
        bullColor: Colors.green,
      )
    ];
  }

  static Expanded sellButton({Function()? onPressed, double? price = 0.000}){
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.symmetric(vertical: 8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Sell', style: GoogleFonts.inter(color: CustomColor.textThemeDarkColor, fontWeight: FontWeight.bold)),
            Text(price.toString(), style: TextStyle(color: CustomColor.textThemeDarkColor, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  static Expanded buyButton({Function()? onPressed, double? price = 0.000}){
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.symmetric(vertical: 8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Buy', style: GoogleFonts.inter(color: CustomColor.textThemeDarkColor, fontWeight: FontWeight.bold)),
            Text(price.toString(), style: TextStyle(color: CustomColor.textThemeDarkColor, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  static Container lotButton(){
    return Container(
      width: 130,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: IconButton(onPressed: decrementLot, icon: Icon(Icons.remove))),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Volume', style: TextStyle(fontSize: 12)),
              Obx(() => Text(volumeInit.value.toStringAsFixed(2), style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          Expanded(child: IconButton(onPressed: incrementLot, icon: Icon(Icons.add))),
        ],
      ),
    );
  }


  static List<double> calculateRSI(List<double> data, int period) {
    List<double> rsi = [];
    List<double> gains = [];
    List<double> losses = [];

    for (int i = 1; i < data.length; i++) {
      double change = data[i] - data[i - 1];
      gains.add(change > 0 ? change : 0);
      losses.add(change < 0 ? -change : 0);
    }

    for (int i = 0; i < gains.length; i++) {
      if (i + 1 < period) {
        rsi.add(0);
      } else {
        double avgGain = gains.sublist(i + 1 - period, i + 1).reduce((a, b) => a + b) / period;
        double avgLoss = losses.sublist(i + 1 - period, i + 1).reduce((a, b) => a + b) / period;

        double rs = avgLoss == 0 ? 100 : avgGain / avgLoss;
        rsi.add(100 - (100 / (1 + rs)));
      }
    }

    // Tambahkan 0 ke awal biar panjang sama dengan data
    rsi.insert(0, 0);
    return rsi;
  }

  static List<double> calculateWMA(List<double> data, int period) {
    List<double> wma = [];

    for (int i = 0; i < data.length; i++) {
      if (i + 1 < period) {
        wma.add(0);
      } else {
        double weightedSum = 0;
        int weightTotal = 0;

        for (int j = 0; j < period; j++) {
          int weight = period - j;
          weightedSum += data[i - j] * weight;
          weightTotal += weight;
        }

        wma.add(weightedSum / weightTotal);
      }
    }

    return wma;
  }

  static List<double> calculateEMA(List<double> data, int period) {
    List<double> ema = [];
    double multiplier = 2 / (period + 1);
    double? prevEma;

    for (int i = 0; i < data.length; i++) {
      if (i + 1 < period) {
        ema.add(0);
      } else if (i + 1 == period) {
        double sum = 0;
        for (int j = 0; j < period; j++) {
          sum += data[j];
        }
        prevEma = sum / period;
        ema.add(prevEma);
      } else {
        prevEma = (data[i] - prevEma!) * multiplier + prevEma;
        ema.add(prevEma);
      }
    }

    return ema;
  }

  static List<double> calculateSMA(List<double> data, int period) {
    List<double> sma = [];

    for (int i = 0; i < data.length; i++) {
      if (i + 1 < period) {
        sma.add(0); // Belum cukup data
      } else {
        double sum = 0;
        for (int j = i - period + 1; j <= i; j++) {
          sum += data[j];
        }
        sma.add(sum / period);
      }
    }

    return sma;
  }
}