import 'package:flutter/material.dart';
import 'components/card_info_account.dart';

class RealSection extends StatefulWidget {
  const RealSection({super.key});

  @override
  State<RealSection> createState() => _RealSectionState();
}

class _RealSectionState extends State<RealSection> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {},
      child: ListView(
        children: [
          doesntHaveAccount(size: size)
        ],
      ),
    );
  }
}
