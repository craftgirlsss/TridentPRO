import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tridentpro/src/components/buttons/elevated_button.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/views/authentications/signin.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  List<IconData> imageURL = [CupertinoIcons.phone, CupertinoIcons.add_circled_solid];
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: size.width,
              height: size.height / 1.8,
              child: PageView.builder(
                controller: pageController,
                physics: const BouncingScrollPhysics(),
                pageSnapping: true,
                itemCount: imageURL.length,
                itemBuilder: (context, index) => Container(
                  width: size.width,
                  height: size.height / 1.8,
                  color: CustomColor.backgroundIcon,
                  child: Center(
                    child: Icon(imageURL[index]),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SmoothPageIndicator(
                          controller: pageController,
                          count: imageURL.length,
                          effect: WormEffect(
                            dotHeight: 8,
                            dotWidth: 8,
                            dotColor: CustomColor.backgroundIcon,
                            type: WormType.thinUnderground,
                            activeDotColor: CustomColor.defaultColor,
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Text(LanguageGlobalVar.INTRODUCTION_TEXT.tr, style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 2),
                      ),
                    ),
                    Flexible(child: Text(LanguageGlobalVar.DESCRIPTIVE_TEXT.tr, style: GoogleFonts.inter(fontSize: 16, color: CustomColor.textThemeLightSoftColor), overflow: TextOverflow.ellipsis, maxLines: 3))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24, bottom: 24),
        child: SizedBox(
          width: size.width,
          child: DefaultButton.defaultElevatedButton(
            title: LanguageGlobalVar.SELANJUTNYA.tr,
            onPressed: () => Get.to(() => const SignIn()),
          ),
        ),
      ),
    );
  }
}
