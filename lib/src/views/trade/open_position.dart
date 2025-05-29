import 'package:flutter/cupertino.dart';

import 'components/position_tile.dart';

class OpenPosition extends StatefulWidget {
  const OpenPosition({super.key});

  @override
  State<OpenPosition> createState() => _OpenPositionState();
}

class _OpenPositionState extends State<OpenPosition> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          children: List.generate(3, (i){
            return CustomSlideAbleListTile.openListTile(context);
          }
        )
      ),
    );
  }
}
