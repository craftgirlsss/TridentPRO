import 'package:flutter/cupertino.dart';
import 'package:tridentpro/src/views/trade/components/position_tile.dart';

class ClosedPosition extends StatefulWidget {
  const ClosedPosition({super.key});

  @override
  State<ClosedPosition> createState() => _ClosedPositionState();
}

class _ClosedPositionState extends State<ClosedPosition> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(3, (i){
          return CustomSlideAbleListTile.openListTile(context);
        }),
      ),
    );
  }
}
