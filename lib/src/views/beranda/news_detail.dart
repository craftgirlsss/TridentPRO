import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/controllers/utilities.dart';
import 'package:tridentpro/src/helpers/formatters/regex_formatter.dart';

class NewsDetail extends StatefulWidget {
  const NewsDetail({super.key, this.idNews});
  final String? idNews;

  @override
  State<NewsDetail> createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  UtilitiesController utilitiesController = Get.find();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      utilitiesController.getNewsDetail(newsID: widget.idNews).then((result){
        if(!result){
          print(utilitiesController.responseMessage.value);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(
        autoImplyLeading: true,
        title: ""
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(
            //   height: 30,
            //   child: ElevatedButton.icon(
            //     style: ElevatedButton.styleFrom(
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(20)
            //       )
            //     ),
            //     icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            //     onPressed: (){
            //       Get.back();
            //     },
            //     label: Text("Back", style: GoogleFonts.inter(color: Colors.white))
            //   ),
            // ),
            const SizedBox(height: 10),
            Obx(() => Text(utilitiesController.newsDetail.value?.response.title ?? "News Title",style: GoogleFonts.inter(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black))),
            const SizedBox(height: 10),
            Obx(() => utilitiesController.newsDetail.value?.response.tanggal == null ? const SizedBox() : Text(DateFormat("EEEE, dd MMMM yyyy").format(DateTime.parse(utilitiesController.newsDetail.value!.response.tanggal!)),style: GoogleFonts.inter(fontSize: 15, color: Colors.black54))),
            const SizedBox(height: 10),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 5),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.redAccent[200],
                  shape: BoxShape.circle,
                  image: DecorationImage(image: AssetImage('assets/images/face_admin.png'), fit: BoxFit.scaleDown)
                ),
              ),
              title: Text("Published by", style: GoogleFonts.inter(fontSize: 15, color: Colors.black54)),
              subtitle: Obx(() => Text(utilitiesController.newsDetail.value?.response.author ?? "Admin TridentPRO", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black), maxLines: 1, overflow: TextOverflow.ellipsis)),
              // trailing: SizedBox(
              //   height: 30,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(20)
              //       )
              //     ),
              //     onPressed: (){}, child: Text("Follow", style: GoogleFonts.inter(color: Colors.white))
              //   ),
              // ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: utilitiesController.newsDetail.value?.response.picture != null ? DecorationImage(image: NetworkImage(utilitiesController.newsDetail.value!.response.picture!), fit: BoxFit.cover) : DecorationImage(image: AssetImage('assets/images/promotion.jpg'), fit: BoxFit.cover)
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Obx(
                () => Text(RegexFormatter.removeHtmlTags(utilitiesController.newsDetail.value?.response.message ?? "0"), style: GoogleFonts.inter(color: Colors.black, fontSize: 15), textAlign: TextAlign.start),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
