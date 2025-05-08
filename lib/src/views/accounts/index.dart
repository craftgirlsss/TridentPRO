import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/buttons/iconbuttons.dart';
import 'package:tridentpro/src/components/languages/language_variable.dart';
import 'package:tridentpro/src/views/accounts/demo_section.dart';
import 'package:tridentpro/src/views/accounts/real_section.dart';

class Accounts extends StatefulWidget {
  const Accounts({super.key});

  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  String selected = "Real";

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: CustomAppBar.defaultAppBar(
          title: LanguageGlobalVar.TRADING_ACCOUNT.tr,
          autoImplyLeading: true,
          actions: <Widget>[
            IconButtons.defaultIconButton(
              onPressed: (){},
              icon: OctIcons.search
            )
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<String>(
                        segments: const <ButtonSegment<String>>[
                          ButtonSegment(
                            value: 'Real',
                            label: Text('Real'),
                          ),
                          ButtonSegment(
                            value: 'Demo',
                            label: Text('Demo'),
                          ),
                        ],
                        selected: <String>{selected},
                        onSelectionChanged: (newSelection) {
                          setState(() {
                            selected = newSelection.first;
                          });
                        },
                        multiSelectionEnabled: false,
                        showSelectedIcon: false,
                      ),
                    ),
                  ],
                ),
              ),
            )
          )
        ),
        body: selected == "Demo" ? DemoSection() : RealSection()
      ),
    );
  }
}


