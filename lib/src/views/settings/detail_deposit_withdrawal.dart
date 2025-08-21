import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:tridentpro/src/components/alerts/scaffold_messanger_alert.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/controllers/user_controller.dart';

class DetailDepositWithdrawal extends StatefulWidget {
  const DetailDepositWithdrawal({super.key, this.index, this.id});
  final int? index;
  final String? id;

  @override
  State<DetailDepositWithdrawal> createState() => _DetailDepositWithdrawalState();
}

class _DetailDepositWithdrawalState extends State<DetailDepositWithdrawal> {
  RxBool isDeposit = false.obs;
  UserController user = Get.find();
  RxInt indexSelected = 0.obs;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      indexSelected(widget.index);
      user.historyTransactionDetail(id: widget.id).then((result){
        if(!result){
          CustomScaffoldMessanger.showAppSnackBar(context, message: user.responseMessage.value, type: SnackBarType.error);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(
        autoImplyLeading: true,
        title: "Detail Transaksi"
      ),
      body: Obx(
        () => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: user.isLoading.value ? SizedBox(
            width: size.width,
            height: size.height / 1.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(color: CustomColor.secondaryColor, strokeWidth: 0.5,),
                const SizedBox(height: 10.0),
                const Text("Loading...")
              ],
            ),
          ) : Column(
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
                    Obx(
                      () => CircleAvatar(
                        radius: 30,
                        backgroundColor: CustomColor.secondaryColor,
                        child: user.transactionDetail.value?.type == "Withdrawal" ? Icon(AntDesign.arrow_up_outline, size: 30) : Icon(AntDesign.arrow_down_outline, size: 30),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(() => Text(user.historyDepoWd.value?.response[indexSelected.value].amountReceived ?? '0', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black))),
                    Obx((){
                      if(user.transactionDetail.value?.type == "Deposit"){
                        return Text("Transfer ke Bank Admin ${user.transactionDetail.value?.bankAdmin?.name}", style: GoogleFonts.inter(fontSize: 12, color: Colors.black54), textAlign: TextAlign.center);
                      }
                      return Text("Transfer ke Bank User ${user.transactionDetail.value?.bankUser?.name}", style: GoogleFonts.inter(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center);
                    },),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: CustomColor.secondaryColor
                      ),
                      child: Obx(() => Text(user.transactionDetail.value?.type ?? '-', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold))),
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
                        Text(
                          "Transaksi ID",
                          style: GoogleFonts.inter(fontSize: 14),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Obx(() {
                              final fullId = user.transactionDetail.value?.id ?? "0";
                              final displayedId = fullId.length > 5 ? "${fullId.substring(0, 5)}..." : fullId;
                              return Text(
                                displayedId,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              );
                            }),
                            GestureDetector(
                              onTap: () {
                                final fullId = user.transactionDetail.value?.id ?? "0";
                                Clipboard.setData(ClipboardData(text: fullId));
                                CustomScaffoldMessanger.showAppSnackBar(context, message: "Berhasil copy ID transaksi", type: SnackBarType.success);
                              },
                              child: Icon(Iconsax.copy_outline, size: 15, color: CustomColor.secondaryColor),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Jumlah Transaksi", style: GoogleFonts.inter(fontSize: 14)),
                        Obx(() => Text(user.transactionDetail.value?.amountReceived ?? "0", style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold))),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tanggal Transaksi", style: GoogleFonts.inter(fontSize: 14)),
                        Flexible(child: Obx(() => user.transactionDetail.value?.datetime != null ? Text(DateFormat("EEEE, dd MMM yyyy").format(DateTime.parse(user.transactionDetail.value!.datetime!)), style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold), maxLines: 1) : Text('-'))),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Waktu", style: GoogleFonts.inter(fontSize: 14)),
                        Flexible(child: Obx(() => user.transactionDetail.value?.datetime != null ? Text(DateFormat().add_jms().format(DateTime.parse(user.transactionDetail.value!.datetime!)), style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold), maxLines: 1) : Text('-'))),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Akun Trading", style: GoogleFonts.inter(fontSize: 14)),
                        Flexible(child: Obx(() => Text(user.transactionDetail.value?.login ?? "0", style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold), maxLines: 1))),
                      ],
                    ),
                  ],
                ),
              ),
        
        
              const SizedBox(height: 10),
              Obx(() => user.transactionDetail.value?.type == "Deposit" ? Container(
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
                        Text("Bank Admin", style: GoogleFonts.inter(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(width: 5),
                        Expanded(child: const Divider(color: Colors.black12))
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nama Bank", style: GoogleFonts.inter(fontSize: 14)),
                        Flexible(child: Obx(() => Text(user.transactionDetail.value?.bankAdmin?.name ?? "-", style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold), maxLines: 1))),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nomor Rekening Bank", style: GoogleFonts.inter(fontSize: 14)),
                        Flexible(child: Obx(() => Text(user.transactionDetail.value?.bankAdmin?.accountNumber ?? "-", style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold), maxLines: 1))),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ) : const SizedBox()),
        
        
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
                        Text("Bank Nasabah", style: GoogleFonts.inter(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(width: 5),
                        Expanded(child: const Divider(color: Colors.black12))
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nama Bank", style: GoogleFonts.inter(fontSize: 14)),
                        Flexible(child: Obx(() => Text(user.transactionDetail.value?.bankUser?.name ?? "-", style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold), maxLines: 1))),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nomor Rekening Bank", style: GoogleFonts.inter(fontSize: 14)),
                        Flexible(child: Obx(() => Text(user.transactionDetail.value?.bankUser?.accountNumber ?? "-", style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold), maxLines: 1))),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nama Pemilik Rekening", style: GoogleFonts.inter(fontSize: 14)),
                        Obx(() => Text(user.transactionDetail.value!.bankUser?.accountName ?? "-", style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold), maxLines: 1)),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
