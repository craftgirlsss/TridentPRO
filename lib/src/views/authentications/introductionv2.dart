
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/containers/introduction_card.dart';
import 'package:tridentpro/src/models/auth/introduction_model.dart';
import 'package:tridentpro/src/views/authentications/introduction_screen.dart';

class Introductionv2 extends StatefulWidget {
  const Introductionv2({super.key});

  @override
  _Introductionv2State createState() => _Introductionv2State();
}

class _Introductionv2State extends State<Introductionv2> with SingleTickerProviderStateMixin {
  late PageController pageController;
  double PageOffset = 0;
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    animation = CurvedAnimation(parent: controller, curve: Curves.easeOutBack);
    pageController = PageController(viewportFraction: .8);
    pageController.addListener(() {
      setState(() {
        PageOffset = pageController.page!;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            // buildAppbar(),
            buildLogo(size),
            buildPager(size),
            // !controller.isCompleted
            //   ? Container()
            //   : buildPagerIndecator()
          ],
        ),
      ),
    );
  }

  Widget buildAppbar() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          AnimatedBuilder(
            animation: animation,
            builder: (context, snapshot) {
              return Transform.translate(
                offset: Offset(-200 * (1 - animation.value), 0),
                child: Image.asset(
                  'images/location.png',
                  width: 30,
                  height: 30,
                )
              );
            }),
          Spacer(),
          AnimatedBuilder(
            animation: animation,
            builder: (context, snapshot) {
              return Transform.translate(
                offset: Offset(200 * (1 - animation.value), 0),
                child: Image.asset(
                  'images/drawer.png',
                  width: 30,
                  height: 30,
                ),
              );
            }),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget buildLogo(Size size) {
    return Positioned(
      top: 10,
      right: size.width / 2 - 25,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, snapshot) {
          return Transform(
            transform: Matrix4.identity()
              ..translate(0.0, size.height / 2.5 * (1 - animation.value))
              ..scale(1 + (1 - animation.value)),
            origin: Offset(25, 25),
            child: GestureDetector(
              onTap: () => controller.isCompleted
                ? controller.reverse()
                : controller.forward(),
              child: Image.asset('assets/images/ic_launcher.png', width: 60, height: 60),
            ),
          );
        }
      )
    );
  }

  Widget buildPager(Size size) {
    return Container(
      margin: EdgeInsets.only(top: 70),
      height: size.height - 50,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, snapshot) {
          return Transform.translate(
            offset: Offset(400 * (1 - animation.value), 0),
            child: Stack(
              children: [
                PageView.builder(
                  itemCount: getDrinks().length,
                  controller: pageController,
                  itemBuilder: (context, index) =>
                    Bounce(
                      onTap: (){
                        print("Added");
                      },
                      child: DrinkCard(getDrinks()[index], PageOffset, index)),
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 300),
                  bottom: PageOffset >= getDrinks().length - 1.5 ? 0 : -100,
                  right: 10,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: PageOffset >= getDrinks().length - 1.5 ? 1.0 : 0.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColor.appGreen
                      ),
                      onPressed: () => Get.to(() => const IntroductionScreen()),
                      child: Text('Next', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  List<Drink> getDrinks() {
    List<Drink> list = [];
    list.add(
      Drink(
        'Smart Forex ',
        'Trading',
        'images/TiramisuBg.png',
        'images/beanTop.png',
        'images/beanSmall.png',
        'images/beanBlur.png',
        'images/3intro.png',
        'Menghadirkan platform trading yang intuitif dengan fitur-fitur canggih. Akses data real-time, analisis teknikal komperhensif, dan eksekusi order cepat untuk memaksimalkan profit Anda.',
        CustomColor.brownLight,
        CustomColor.brownDark
      )
    );

    list.add(
      Drink(
        'Platform Trading',
        'Inovatif',
        'images/GreenTeaBG.png',
        'images/green.png',
        'images/greenSmall.png',
        'images/greenBlur.png',
        'images/2intro.png',
        'Nikmati pengalaman trading forex yang cerdas dengan TridentPro. Manfaatkan sinyal traading akurat, edukasi lengkap, dan manajemen risiko terintegrasi  untuk mencapai tujuan finansial Anda.',
        CustomColor.greenLight,
        CustomColor.greenDark
      )
    );

    list.add(
      Drink(
        'Investasi Forex',
        'Mudah & Aman',
        'images/GreenMochabBG.png',
        'images/chocolateTop.png',
        'images/chocolateSmall.png',
        'images/chocolateBlur.png',
        'images/4intro.png',
        'Mulai perjalanan trading Anda bersama TridentPro. Platform aman, terpercaya, dan dirancang untuk trader pemula maupun profesional. Dapatkan potensi keuntungan optimal di pasar forex global.',
        CustomColor.brownLight,
        CustomColor.brownDark
      )
    );
    return list;
  }

  Widget buildPagerIndecator() {
    return Positioned(
      bottom: 10,
      left: 0,
      child: Row(
        children:
        List.generate(getDrinks().length, (index) => buildContainer(index)),
      ),
    );
  }

  Widget buildContainer(int index) {
    double animate = PageOffset - index;
    double size = 10;
    animate = animate.abs();
    Color? color = Colors.grey;
    if (animate < 1 && animate >= 0) {
      size = 10 + 10 * (1 - animate);
      color = ColorTween(begin: Colors.grey, end: CustomColor.appGreen).transform((1 - animate));
    }
    return Container(
      margin: EdgeInsets.all(4),
      height: size,
      width: size,
      decoration:
      BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
    );
  }
}