import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/colors/default.dart';

class NewsCard {
  static ClipRRect blurredNews({Function()? onPressed}){
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/images/promotion.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200,
          ),

          // Blur and dark overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              color: Colors.black54, // dark blur
              width: double.infinity,
              height: 200,
            ),
          ),

          // Content
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text("Earn Cashback!",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      ),
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(height: 2),
                  Flexible(
                    child: Text(
                      "Join ForexGuru and get 10% cashback\nwhen you fund your account today!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.arrow_forward, color: Colors.white),
                      label: Text("Register", style: GoogleFonts.inter(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColor.defaultColor,
                        foregroundColor: Colors.teal,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}