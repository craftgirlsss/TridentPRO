import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/views/accounts/index.dart';
import 'package:tridentpro/src/views/beranda/index_v2.dart';
import 'package:tridentpro/src/views/settings/index.dart';
import 'package:tridentpro/src/views/trade/index_v2.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    // const Beranda(),
    const IndexV2(),
    const Accounts(),
    // const Trade(),
    const MetaQuotesPage(),
    const Settings(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: Container(
          color: Colors.white,
          child: BottomNavigationBar(
            selectedLabelStyle: GoogleFonts.inter(fontSize: 14),
            unselectedLabelStyle: GoogleFonts.inter(fontSize: 14),
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(ZondIcons.explore),
                label: LanguageGlobalVar.HOME.tr,
              ),
              BottomNavigationBarItem(
                icon: Icon(BoxIcons.bx_dollar),
                label: LanguageGlobalVar.TRADING_ACCOUNT.tr,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.stacked_line_chart),
                label: "Markets",
              ),
              BottomNavigationBarItem(
                icon: Icon(Bootstrap.person_fill_gear),
                label: 'Settings',
              ),
            ],
            currentIndex: _selectedIndex,
            elevation: 0,
            showSelectedLabels: true,
            type: BottomNavigationBarType.fixed,
            unselectedFontSize: 12,
            selectedItemColor: CustomColor.secondaryColor,
            unselectedIconTheme: IconThemeData(color: CustomColor.secondaryBackground),
            selectedIconTheme: IconThemeData(size: 25, color: CustomColor.secondaryColor),
            unselectedItemColor: CustomColor.secondaryBackground,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
