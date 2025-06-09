import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tridentpro/src/views/beranda/news_detail.dart';

class ForexNews extends StatefulWidget {
  const ForexNews({super.key});

  @override
  State<ForexNews> createState() => _ForexNewsState();
}

class _ForexNewsState extends State<ForexNews> {
  double itemHeight = 100.0;
  double maxVisibleItems = 3;
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Global Forex News", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(8, (index) {
                  return CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: (){
                      Get.to(() => const NewsDetail());
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Berita ke ${index + 1}", style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text("Deskripsi Berita ke ${index + 1}"),
                          SizedBox(height: 4),
                          Text("Published: ${DateFormat('MMMM, dd yyyy').format(now)}", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ListView.builder(
//   itemCount: 8,
//   shrinkWrap: true,
//   itemBuilder: (context, index) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Berita ke ${index + 1}", style: TextStyle(fontWeight: FontWeight.bold)),
//           SizedBox(height: 4),
//           Text("Deskripsi Berita ke ${index + 1}"),
//           SizedBox(height: 4),
//           Text("Published: ${DateFormat('MMMM, dd yyyy').format(now)}", style: TextStyle(color: Colors.grey)),
//         ],
//       ),
//     );
//   },
// )