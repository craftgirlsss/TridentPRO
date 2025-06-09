import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/colors/default.dart';

class DetailDepositWithdrawal extends StatefulWidget {
  const DetailDepositWithdrawal({super.key});

  @override
  State<DetailDepositWithdrawal> createState() => _DetailDepositWithdrawalState();
}

class _DetailDepositWithdrawalState extends State<DetailDepositWithdrawal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(
        autoImplyLeading: true,
        title: "Detail Transaksi"
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(20.0)
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: CustomColor.defaultColor,
                    child: Icon(MingCute.transfer_2_fill, size: 30),
                  ),
                  const SizedBox(height: 10),
                  Text("\$120.43", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black)),
                  Text("Transfer ke Bank Admin BCA", style: GoogleFonts.inter(fontSize: 14, color: Colors.black54)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: CustomColor.defaultColor
                    ),
                    child: Text("Deposit", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(20.0)
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("Detail Transaksi", style: GoogleFonts.inter(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(width: 5),
                      Expanded(child: const Divider(color: Colors.black12))
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Transaksi ID", style: GoogleFonts.inter(fontSize: 14)),
                      Text("#238023", style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Jumlah Transaksi", style: GoogleFonts.inter(fontSize: 14)),
                      Text("\$293.43", style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Diterima", style: GoogleFonts.inter(fontSize: 14)),
                      Text("\$288.43", style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tanggal Transaksi", style: GoogleFonts.inter(fontSize: 14)),
                      Flexible(child: Text(DateFormat("dd MMM yyyy").add_jms().format(DateTime.now()), style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold), maxLines: 1)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Akun Trading", style: GoogleFonts.inter(fontSize: 14)),
                      Flexible(child: Text("2403230", style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold), maxLines: 1)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Bank Pengirim", style: GoogleFonts.inter(fontSize: 14)),
                      Flexible(child: Text("BCA", style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold), maxLines: 1)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Bank Penerima", style: GoogleFonts.inter(fontSize: 14)),
                      Flexible(child: Text("BCA", style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold), maxLines: 1)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Bukti Transfer", style: GoogleFonts.inter(fontSize: 14)),
                      Text("Lihat Gambar", style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: CustomColor.defaultColor)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
