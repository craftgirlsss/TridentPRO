import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tridentpro/src/controllers/trading.dart';

import 'components/position_tile.dart';

class OpenPosition extends StatefulWidget {
  const OpenPosition({super.key, this.loginID});
  final String? loginID;

  @override
  State<OpenPosition> createState() => _OpenPositionState();
}

class _OpenPositionState extends State<OpenPosition> {

  TradingController tradingController = Get.find();
  RxBool isLoading = false.obs;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      isLoading(true);
      tradingController.openOrder(login: widget.loginID!).then((result){
      });
      isLoading(false);
      timer = Timer.periodic(const Duration(seconds: 2), (_){
        tradingController.openOrder(login: widget.loginID!).then((result){
        });
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => isLoading.value ? Center(child: Text("Getting Open Order...")) : SingleChildScrollView(
        child: Column(
          children: List.generate(tradingController.openOrderModel.value?.response?.length ?? 0, (i){
            return CustomSlideAbleListTile.openListTile(
              context,
              market: tradingController.openOrderModel.value?.response?[i].symbol,
              lot: tradingController.openOrderModel.value?.response?[i].lots!.toDouble().toString(),
              orderType: tradingController.openOrderModel.value?.response?[i].orderType,
              dateTime: tradingController.openOrderModel.value?.response?[i].openTime,
              profitLoss: tradingController.openOrderModel.value?.response?[i].profit,
              currentPrice: tradingController.openOrderModel.value?.response?[i].priceCurrent,
              openPrice: tradingController.openOrderModel.value?.response?[i].openPrice,
              sl: tradingController.openOrderModel.value?.response?[i].stopLoss,
              tp: tradingController.openOrderModel.value?.response?[i].takeProfit,
              swap: tradingController.openOrderModel.value?.response?[i].swap,
              id: tradingController.openOrderModel.value?.response?[i].ticket,
            );
          })
        ),
      ),
    );
  }
}
