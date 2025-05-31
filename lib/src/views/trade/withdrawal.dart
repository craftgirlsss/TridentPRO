import 'package:flutter/material.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/buttons/outlined_button.dart';
import 'package:tridentpro/src/components/containers/utilities.dart';

class Withdrawal extends StatefulWidget {
  const Withdrawal({super.key});

  @override
  State<Withdrawal> createState() => _WithdrawalState();
}

class _WithdrawalState extends State<Withdrawal> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: CustomAppBar.defaultAppBar(
          title: "Withdrawal",
          autoImplyLeading: true,
          actions: [
            SizedBox(
              height: 30,
              child: CustomOutlinedButton.defaultOutlinedButton(
                  title: "Submit",
                  onPressed: (){}
              ),
            ),
            const SizedBox(width: 10)
          ]
        ),
        body: RefreshIndicator(
          onRefresh: () async {

          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                UtilitiesWidget.titleContent(
                  title: "Withdrawal",
                  subtitle: "Pastikan jumlah balance anda mencukupi untuk proses withdrawal",
                  children: [

                  ]
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
