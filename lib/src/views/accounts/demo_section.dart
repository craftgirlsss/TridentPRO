import 'package:flutter/material.dart';
import 'components/card_info_account.dart';

class DemoSection extends StatefulWidget {
  const DemoSection({super.key});

  @override
  State<DemoSection> createState() => _DemoSectionState();
}

class _DemoSectionState extends State<DemoSection> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {},
      child: SizedBox(
        width: double.infinity,
        height: double.maxFinite,
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                doesntHaveAccount(isDemo: true, size: size)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
