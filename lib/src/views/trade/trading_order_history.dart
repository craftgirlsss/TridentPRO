import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/views/trade/closed_position.dart';
import 'package:tridentpro/src/views/trade/pending_position.dart';

import 'open_position.dart';

class TradingOrderHistory extends StatefulWidget {
  const TradingOrderHistory({super.key, this.accountID});
  final String? accountID;

  @override
  State<TradingOrderHistory> createState() => _TradingOrderHistoryState();
}

class _TradingOrderHistoryState extends State<TradingOrderHistory> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            dividerColor: CustomColor.defaultColor,
            automaticIndicatorColorAdjustment: true,
            labelStyle: GoogleFonts.inter(),
            physics: BouncingScrollPhysics(),
            tabs: <Widget>[
              Tab(icon: Text("Pending")),
              Tab(icon: Text("Open")),
              Tab(icon: Text("Closed")),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PendingPosition(),
            OpenPosition(),
            ClosedPosition()
          ]
        ),
      )
    );
  }
}
