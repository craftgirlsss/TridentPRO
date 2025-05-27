import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/controllers/home.dart';
import 'package:tridentpro/src/controllers/trading.dart';
import 'package:tridentpro/src/views/trade/market_detail.dart';

class Trade extends StatefulWidget {
  const Trade({super.key});

  @override
  State<Trade> createState() => _TradeState();
}

class _TradeState extends State<Trade> {

  RxInt selectedCategory = 1.obs;
  TextEditingController searchController = TextEditingController();
  HomeController homeController = Get.find();
  TradingController tradingController = Get.put(TradingController());
  RxBool isLoading = false.obs;
  RxList<Map<String, dynamic>> accountTrading = <Map<String, dynamic>>[].obs;

  @override
  void initState() {
    super.initState();
    () async {
      tradingController.isLoading(true);
      await tradingController.getTradingAccountV2().then((result) {
          accountTrading.value = result;
      });
      tradingController.isLoading(false);
    }();
  }

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
                    Obx(() => Text(homeController.profileModel.value?.name ?? "-", style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold,))),
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
                Text("Trade Account", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 24.0, color: CustomColor.textThemeDarkSoftColor)),
                Obx(() => tradingController.isLoading.value 
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: CustomColor.defaultColor),
                        const SizedBox(height: 10),
                      ],
                    )
                  : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: accountTrading.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: (){
                        Get.to(() => MarketDetail(login: accountTrading[index]['login']));
                      },
                      child: StockTile(
                        login: accountTrading[index]['login'].toString(),
                        balance: double.parse(accountTrading[index]['balance'].toString()),
                      ),
                    )
                  )
                ),
                const SizedBox(height: 20),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.black45, fontSize: 13)),
          SizedBox(height: 8),
          Flexible(child: Text(amount, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black), maxLines: 1)),
          SizedBox(height: 8),
          Expanded(
            child: Row(
              children: [
                Icon(Icons.trending_up, color: changeColor, size: 16),
                SizedBox(width: 4),
                Text(change, style: TextStyle(color: changeColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StockTile extends StatelessWidget {
  final String login;
  final double balance;

  const StockTile({
    required this.login,
    required this.balance,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12)
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: CustomColor.textThemeLightColor,
            child: Text("A", style: GoogleFonts.inter(color: CustomColor.textThemeDarkSoftColor, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(login, style: GoogleFonts.inter(color: CustomColor.textThemeLightColor, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Text('\$${balance.toStringAsFixed(2)}', style: GoogleFonts.inter(color: CustomColor.textThemeLightSoftColor)),
                    const SizedBox(width: 5),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

