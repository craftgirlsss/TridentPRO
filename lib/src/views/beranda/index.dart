import 'package:flutter/material.dart';
import 'package:tridentpro/src/views/beranda/components/resource_and_learning.dart';
import 'components/forex_news.dart';
import 'components/promotion.dart';

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda>{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scrollbar(
        radius: Radius.circular(20),
        thickness: 7,
        interactive: true,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              const PromotionSection(),
              const SizedBox(height: 40),
              ForexNews(),
              const SizedBox(height: 40),
              LearningSection()
            ],
          ),
        ),
      ),
    );
  }
}
