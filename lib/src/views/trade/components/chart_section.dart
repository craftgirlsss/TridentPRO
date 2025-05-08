import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartSection extends StatelessWidget {
  const ChartSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return SizedBox(
      width: double.infinity,
      height: size.height / 1.7,
      child: Column(
        children: [
          // Tool Section

          // End of Tool Section

          // Chart Section

          // End of Chart Section
        ],
      ),
    );
  }
}