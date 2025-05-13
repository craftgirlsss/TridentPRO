import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/colors/default.dart';

class CustomMaterialBottomSheets {
  static void defaultBottomSheet(BuildContext context, {Size? size, List<Widget>? children, String? title, bool? isScrolledController}){
    showModalBottomSheet<void>(
      enableDrag: true,
      isDismissible: false,
      isScrollControlled: isScrolledController ?? true,
      context: context,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(12),
          height: isScrolledController == false ? 250 : size!.height - 100,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 30,
                  height: 5,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: CustomColor.defaultColor,
                    borderRadius: BorderRadius.circular(6)
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: CustomColor.defaultSoftColor,
                        shape: BoxShape.circle
                      ),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close, color: CustomColor.defaultColor, size: 17)),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Text(title ?? "Title", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 25), textAlign: TextAlign.center),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    children: children!,
                  ),
                )
              ]
            ),
          ),
        );
      },
    );
  }
}