import 'package:flutter/material.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/views/trade/components/chart_section.dart';

class MarketDetail extends StatefulWidget {
  final String? marketName;
  const MarketDetail({super.key, this.marketName});

  @override
  State<MarketDetail> createState() => _MarketDetailState();
}

class _MarketDetailState extends State<MarketDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(
        title: widget.marketName,
        autoImplyLeading: true
      ),
      body: ChartSection(),
    );
  }
}
