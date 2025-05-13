import 'package:deriv_chart/deriv_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/views/trade/components/chart_section.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';


class MarketDetail extends StatefulWidget {
  final String? marketName;
  const MarketDetail({super.key, this.marketName});

  @override
  State<MarketDetail> createState() => _MarketDetailState();
}

class _MarketDetailState extends State<MarketDetail> {
  double volume = 0.01;

  Future<void> websocketConnect() async {
    print("WSS dijalankan");
    final wsUrl = Uri.parse('wss://ws.derivws.com/websockets/v3?app_id=74855');
    final channel = WebSocketChannel.connect(wsUrl);

    await channel.ready;
    print("WebSocket berhasil terhubung");

    channel.stream.listen((message) {
      print("Pesan diterima: $message");
      channel.sink.add('received!');
      channel.sink.close(status.goingAway);
    });
  }

  @override
  void initState() {
    super.initState();
    websocketConnect();
  }

  void incrementVolume() {
    setState(() {
      volume += 0.01;
    });
  }

  void decrementVolume() {
    setState(() {
      if (volume > 0.01) volume -= 0.01;
    });
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(
        title: widget.marketName,
        autoImplyLeading: true
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 10),
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6FA),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('H1', style: GoogleFonts.inter(color: CustomColor.textThemeLightColor)),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _iconButton(AntDesign.function_outline, (){}),
                        _iconButton(Icons.edit, (){}),
                        _iconButton(Icons.layers, (){}),
                        _iconButton(Icons.tune, (){}),
                        _iconButton(Icons.fullscreen, (){}),
                      ],
                    ),
                  )
                ],
              ),
            ),
            // End of Tool Section

            // Chart Section
            Container(
              width: size.width,
              height: size.height / 1.7,
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColor.textThemeDarkSoftColor)
              ),
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
            // Sell Button
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
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
                    Text('1.13765', style: TextStyle(color: CustomColor.textThemeDarkColor, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8),

            // Volume Selector
            Container(
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
                  Expanded(child: IconButton(onPressed: decrementVolume, icon: Icon(Icons.remove))),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Volume', style: TextStyle(fontSize: 12)),
                      Text(volume.toStringAsFixed(2), style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Expanded(child: IconButton(onPressed: incrementVolume, icon: Icon(Icons.add))),
                ],
              ),
            ),
            SizedBox(width: 8),

            // Buy Button
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
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
                    Text('1.13773', style: GoogleFonts.inter(color: CustomColor.textThemeDarkColor, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, Function() onPressed) {
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
}
