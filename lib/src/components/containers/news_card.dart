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
                  Text("Earn Cashback!",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24
                    )
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Join ForexGuru and get 10% cashback\nwhen you fund your account today!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.arrow_forward, color: Colors.white),
                    label: Text("Register", style: GoogleFonts.inter(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColor.defaultColor,
                      foregroundColor: Colors.teal,
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