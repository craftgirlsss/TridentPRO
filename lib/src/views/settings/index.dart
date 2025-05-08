import 'package:flutter/material.dart';
import 'package:tridentpro/src/components/colors/default.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      color: CustomColor.backgroundIcon,
      width: size.width,
      height: size.height,
      child: Center(
        child: Text("Settings"),
      ),
    );
  }
}
