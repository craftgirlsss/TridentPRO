import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NewsDetail extends StatefulWidget {
  const NewsDetail({super.key});

  @override
  State<NewsDetail> createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset('assets/images/bg_papper.jpeg', fit: BoxFit.cover)
          ),
          Container(
            color: Colors.black26,
            width: double.infinity,
            height: double.infinity,
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                SizedBox(
                  height: 30,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      )
                    ),
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: (){
                      Get.back();
                    },
                    label: Text("Back", style: GoogleFonts.inter(color: Colors.white))
                  ),
                ),
                const SizedBox(height: 10),
                Text("Demand for Indian generic drugs skyrockets in China amid Covid surge",style: GoogleFonts.inter(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 10),
                Text(DateFormat("EEEE, dd MMMM yyyy").format(DateTime.now()),style: GoogleFonts.inter(fontSize: 15, color: Colors.white)),
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
                  title: Text("Published by", style: GoogleFonts.inter(fontSize: 12, color: Colors.white)),
                  subtitle: Text("Admin TridentPRO", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: SizedBox(
                    height: 30,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        )
                      ),
                      onPressed: (){}, child: Text("Follow", style: GoogleFonts.inter(color: Colors.white))
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(image: AssetImage('assets/images/promotion.jpg'), fit: BoxFit.cover)
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("""
The demand for Indian generic drugs has shot up in China amid the massive COVID surge in the country, with Chinese experts cautioning that fake versions of these drugs are flooding the market. China's National Health Security Administration said on Sunday that Pfizer's, Paxlovid oral medication.
                """, style: GoogleFonts.inter(color: Colors.white), textAlign: TextAlign.justify),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
