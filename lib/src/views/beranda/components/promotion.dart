// Promotion Section Home
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/containers/news_card.dart';

class PromotionSection extends StatefulWidget {
  const PromotionSection({super.key});

  @override
  State<PromotionSection> createState() => _PromotionSectionState();
}

class _PromotionSectionState extends State<PromotionSection> {
  PageController pageControllerPromo = PageController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          width: size.width,
          height: size.width / 2,
          child: PageView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: 3,
            pageSnapping: true,
            controller: pageControllerPromo,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: NewsCard.blurredNews(onPressed: (){}),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: SmoothPageIndicator(
            controller: pageControllerPromo,
            count: 3,
            effect: WormEffect(
              dotHeight: 5,
              dotWidth: 20,
              type: WormType.thinUnderground,
              activeDotColor: CustomColor.defaultColor,
            ),
          ),
        ),
      ],
    );
  }
}
