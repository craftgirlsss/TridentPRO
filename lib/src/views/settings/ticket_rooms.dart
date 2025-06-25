import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/bottomsheets/material_bottom_sheets.dart';
import 'package:tridentpro/src/components/buttons/outlined_button.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/controllers/utilities.dart';
import 'package:tridentpro/src/helpers/variables/random_color.dart';
import 'package:tridentpro/src/views/settings/tickets.dart';

class TicketRooms extends StatefulWidget {
  const TicketRooms({super.key});

  @override
  State<TicketRooms> createState() => _TicketRoomsState();
}

class _TicketRoomsState extends State<TicketRooms> {
  UtilitiesController utilitiesController = Get.find();
  RxInt selectedIndex = 1.obs;
  RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      utilitiesController.ticketList().then((result){
        print(result);
      });
    });
  }

  RxList subjectType = [
    "Masalah Teknis/Bug",
    "Pertanyaan/Informasi Umum",
    "Masalah Pembayaran/Billing",
    "Permintaan/Perubahan Akun",
    "Saran/Umpan Balik"
  ].obs;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(
        autoImplyLeading: true,
        title: "Daftar Ticket"
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Obx(
          () => Column(
            children: List.generate(utilitiesController.listTicketModel.value?.response?.length ?? 0, (i){
              if(utilitiesController.listTicketModel.value?.response?.length == 0){
                return SizedBox(
                  width: double.infinity,
                  height: size.width * 1.5,
                  child: Center(child: Text("Start new conversation :)"))
                );
              }
              return ListTile(
                onTap: (){
                  Get.to(() => Tickets(ticketCode: utilitiesController.listTicketModel.value?.response?[i].code, closed: utilitiesController.listTicketModel.value?.response?[i].status == "-1" ? false : true));
                },
                leading: CircleAvatar(
                  backgroundColor: CustomColorPicker.getRandomColor(),
                  child: Text(utilitiesController.listTicketModel.value?.response?[i].subject != null ? utilitiesController.listTicketModel.value!.response![i].subject![0] : "0"),
                ),
                title: Text(utilitiesController.listTicketModel.value?.response?[i].subject ?? "-", style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                subtitle: utilitiesController.listTicketModel.value?.response?[i].status == "1" ? Text("Closed", style: GoogleFonts.inter(fontWeight: FontWeight.w300)) : Text("Opened", style: GoogleFonts.inter(fontWeight: FontWeight.w300)),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, color: utilitiesController.listTicketModel.value?.response?[i].status == "1" ? Colors.red : Colors.green, size: 15.0),
                    Text(utilitiesController.listTicketModel.value?.response?[i].createdAt ?? "-", style: GoogleFonts.inter(fontWeight: FontWeight.w300)),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        elevation: 0.0,
        isExtended: true,
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? accessToken = prefs.getString("accessToken");
          print(accessToken);
          CustomMaterialBottomSheets.defaultBottomSheet(
            context,
            size: size,
            title: "Pilih Subjek Ticket",
            children: [
              const SizedBox(height: 10.0),
              Wrap(
                spacing: 5.0,
                children:
                List<Widget>.generate(subjectType.length, (int index) {
                  return Obx(
                    () => ChoiceChip(
                      selectedColor: CustomColor.defaultColor,
                      backgroundColor: Colors.grey.shade200,
                      side: BorderSide(color: Colors.black),
                      shape: StadiumBorder(),
                      label: Text('${subjectType[index]}'),
                      selected: selectedIndex.value == index,
                      onSelected: (bool selected) {
                        selectedIndex.value = selected ? index : 0;
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10.0),
              SizedBox(
                height: 35.0,
                child: Obx(
                  () => CustomOutlinedButton.defaultOutlinedButton(
                    title: isLoading.value ? "Membuat Ticket..." : "Mulai Tiket Sekarang",
                    onPressed: (){
                      isLoading(true);
                      utilitiesController.createTicket(subject: subjectType[selectedIndex.value]).then((result) {
                        if(result){
                          utilitiesController.ticketList().then((list){
                            Get.back();
                            String? code = utilitiesController.listTicketModel.value?.response?[0].code;
                            String? status = utilitiesController.listTicketModel.value?.response?[0].status;
                            Get.to(() => Tickets(ticketCode: code, closed: status == "-1" ? false : true));
                          });
                        }
                        isLoading(false);
                      });
                    }
                  ),
                ),
              )
            ]
          );
        },
        backgroundColor: CustomColor.defaultColor,
        child: Icon(Bootstrap.chat_right_text, color: Colors.white),
      ),
    );
  }
}
