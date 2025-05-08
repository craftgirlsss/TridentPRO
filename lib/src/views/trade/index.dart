import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/views/trade/market_detail.dart';

class Trade extends StatefulWidget {
  const Trade({super.key});

  @override
  State<Trade> createState() => _TradeState();
}

class _TradeState extends State<Trade> {

  RxInt selectedCategory = 1.obs;
  TextEditingController searchController = TextEditingController();
  RxBool isLoading = false.obs;
  List<Map<String, dynamic>> marketName = [
    {
      "market_name" : "BBCA",
      "price" : 1.900,
      "change_percent" : 0.55,
      "ohlc" : [1, 3, 2, 4, 6, 5, 7, 4, 5, 3, 7].map((e) => e.toDouble()).toList()
    },
    {
      "market_name" : "BBRI",
      "price" : 3.380,
      "change_percent" : 0.35,
      "ohlc" : [1, 3, 2, 4, 6, 5, 7, 4, 5, 3, 7].map((e) => e.toDouble()).toList()
    },
    {
      "market_name" : "BRIS",
      "price" : 2.910,
      "change_percent" : 0.73,
      "ohlc" : [1, 3, 2, 4, 6, 5, 7, 4, 5, 3, 7].map((e) => e.toDouble()).toList()
    },
  ];

  List<Map<String, dynamic>> cryptoMarketName = [
    {
      "market_name" : "BTC",
      "price" : 1.900,
      "change_percent" : -0.55,
      "ohlc" : [1, 3, 2, 4, 6, 5, 7, 4, 5, 3, 7].map((e) => e.toDouble()).toList()
    },
    {
      "market_name" : "DOGE",
      "price" : 3.380,
      "change_percent" : 0.35,
      "ohlc" : [1, 3, 2, 4, 6, 5, 7, 4, 5, 3, 7].map((e) => e.toDouble()).toList()
    },
    {
      "market_name" : "ETH",
      "price" : 2.910,
      "change_percent" : -0.73,
      "ohlc" : [1, 3, 2, 4, 6, 5, 7, 4, 5, 3, 7].map((e) => e.toDouble()).toList()
    },
  ];


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Hello Putra',
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/promotion.jpg'), // ganti sesuai path gambar
                      radius: 22,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    filled: true,
                    isDense: true,
                    fillColor: CustomColor.textThemeDarkSoftFilledColor,
                    prefixIcon: Icon(OctIcons.search, color: CustomColor.textThemeLightSoftColor),
                    hintText: 'Search',
                    hintStyle: GoogleFonts.inter(color: CustomColor.textThemeLightSoftColor, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Obx(() => isLoading.value ? const SizedBox() : FilterChip(label: Text('All', style: GoogleFonts.inter()), selected: selectedCategory.value == 1 ? true : false, onSelected: (_) => selectedCategory(1), selectedColor: selectedCategory.value == 1 ? CustomColor.defaultColor : Colors.transparent, side: BorderSide(color: CustomColor.textThemeDarkSoftFilledColor), shape: StadiumBorder())),
                    SizedBox(width: 10),
                    Obx(() => isLoading.value ? const SizedBox() : FilterChip(label: Text('Stocks', style: GoogleFonts.inter()), selected: selectedCategory.value == 2 ? true : false, onSelected: (_) => selectedCategory(2), selectedColor: selectedCategory.value == 2 ? CustomColor.defaultColor : Colors.transparent, side: BorderSide(color: CustomColor.textThemeDarkSoftFilledColor), shape: StadiumBorder())),
                    SizedBox(width: 10),
                    Obx(() => isLoading.value ? const SizedBox() : FilterChip(label: Text('Crypto', style: GoogleFonts.inter()), selected:  selectedCategory.value == 3 ? true : false, onSelected: (_) => selectedCategory(3), selectedColor:  selectedCategory.value == 3 ? CustomColor.defaultColor : Colors.transparent, side: BorderSide(color: CustomColor.textThemeDarkSoftFilledColor), shape: StadiumBorder())),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: size.width / 3,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      balanceCard('\$23,000', 'Invested Balance', '+5.39%', Colors.green.shade800),
                      SizedBox(width: 10),
                      balanceCard('\$15,000', 'Wallet Balance', '-2.12%', Colors.red.shade800),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text("Saham", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 24.0, color: CustomColor.textThemeDarkSoftColor)),
                ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: marketName.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: (){
                      Get.to(() => MarketDetail(marketName: marketName[index]['market_name']));
                    },
                    child: StockTile(
                      name: marketName[index]['market_name'],
                      price: marketName[index]['price'],
                      changePercent: marketName[index]['change_percent'],
                      data: marketName[index]['ohlc'],
                    ),
                  )
                ),
                const SizedBox(height: 20),
                Text("Crypto", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 24.0, color: CustomColor.textThemeDarkSoftColor)),
                ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: cryptoMarketName.length,
                    itemBuilder: (context, index) => StockTile(
                      name: cryptoMarketName[index]['market_name'],
                      price: cryptoMarketName[index]['price'],
                      changePercent: cryptoMarketName[index]['change_percent'],
                      data: cryptoMarketName[index]['ohlc'],
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget balanceCard(String amount, String label, String change, Color changeColor) {
    return Container(
      width: 200,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CustomColor.defaultSoftColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.black45)),
          SizedBox(height: 8),
          Text(amount, style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.trending_up, color: changeColor, size: 16),
              SizedBox(width: 4),
              Text(change, style: TextStyle(color: changeColor)),
            ],
          ),
        ],
      ),
    );
  }
}

class StockTile extends StatelessWidget {
  final String name;
  final double price;
  final double changePercent;
  final List<double> data;

  const StockTile({
    required this.name,
    required this.price,
    required this.changePercent,
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = changePercent >= 0;
    final color = isPositive ? Colors.green.shade800 : Colors.red;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CustomColor.defaultSoftColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100)
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: CustomColor.textThemeLightColor,
            child: Text(name[0], style: GoogleFonts.inter(color: CustomColor.textThemeDarkSoftColor, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.inter(color: CustomColor.textThemeLightColor, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Text('\$${price.toStringAsFixed(2)}', style: GoogleFonts.inter(color: CustomColor.textThemeLightSoftColor)),
                    const SizedBox(width: 5),
                    Text("${isPositive ? '+' : ''}${changePercent.toStringAsFixed(2)}%", style: TextStyle(color: color, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 60,
            height: 40,
            child: SfSparkLineChart(
              color: color,
              data: data,
              width: 1.0,
              axisLineWidth: 0,
              trackball: const SparkChartTrackball(),
            ),
          ),
        ],
      ),
    );
  }
}

