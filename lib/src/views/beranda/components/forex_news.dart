import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/controllers/utilities.dart';
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
  UtilitiesController utilitiesController = Get.put(UtilitiesController());

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      utilitiesController.getNewsList().then((result){
        if(!result){
          print(utilitiesController.responseMessage.value);
        }
      });
    });
  }

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
              child: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(utilitiesController.newsModel.value?.response.length ?? 0, (index) {
                    if(utilitiesController.newsModel.value?.response[index].type == "News"){
                      return CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: (){
                          Get.to(() => NewsDetail(idNews: utilitiesController.newsModel.value?.response[index].id));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(child: Obx(() => Text(utilitiesController.newsModel.value?.response[index].title ?? "Berita ke ${index + 1}", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: CustomColor.defaultColor), maxLines: 2))),
                                    SizedBox(height: 4),
                                    Flexible(child: Obx(() => Text("Published: ${DateFormat('EEEE, dd MMMM yyyy').add_jms().format(DateTime.parse(utilitiesController.newsModel.value!.response[index].tanggal!))}", style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)))),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 5),
                              Container(
                                width: 100,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: utilitiesController.newsModel.value?.response[index].picture != null ? DecorationImage(image: NetworkImage(utilitiesController.newsModel.value!.response[index].picture!), fit: BoxFit.cover) : DecorationImage(image: AssetImage('assets/images/ic_launcher.png'), fit: BoxFit.cover)
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  }),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Text("Fundamentals & Technical Analysis", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            SingleChildScrollView(
              child: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(utilitiesController.newsModel.value?.response.length ?? 0, (index) {
                    if(utilitiesController.newsModel.value?.response[index].type != "News"){
                      return CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: (){
                          Get.to(() => NewsDetail(idNews: utilitiesController.newsModel.value?.response[index].id));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Icon(LineAwesome.newspaper, size: 30, color: CustomColor.defaultColor),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(child: Obx(() => Text(utilitiesController.newsModel.value?.response[index].title ?? "Berita ke ${index + 1}", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: CustomColor.defaultColor), maxLines: 2))),
                                    SizedBox(height: 4),
                                    Flexible(child: Obx(() => Text("Published: ${DateFormat('EEEE, dd MMMM yyyy').add_jms().format(DateTime.parse(utilitiesController.newsModel.value!.response[index].tanggal!))}", style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)))),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 5),
                              Container(
                                width: 100,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: utilitiesController.newsModel.value?.response[index].picture != null ? DecorationImage(image: NetworkImage(utilitiesController.newsModel.value!.response[index].picture!), fit: BoxFit.cover, onError: (exception, stackTrace) {
                                    print("exception => ${exception.hashCode}");
                                  }) : DecorationImage(image: AssetImage('assets/images/ic_launcher.png'), fit: BoxFit.cover)
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  }),
                ),
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