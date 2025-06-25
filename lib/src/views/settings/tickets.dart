import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tridentpro/src/components/alerts/default.dart';
import 'package:tridentpro/src/components/alerts/scaffold_messanger_alert.dart';
import 'package:tridentpro/src/components/bottomsheets/material_bottom_sheets.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/controllers/utilities.dart';
import 'package:tridentpro/src/helpers/handlers/image_picker.dart';
import 'package:tridentpro/src/views/settings/send_image_chat.dart';

RxInt totalMessages = 0.obs;
class Tickets extends StatefulWidget {
  const Tickets({super.key, this.ticketCode, this.closed});
  final String? ticketCode;
  final bool? closed;

  @override
  State<Tickets> createState() => _TicketsState();
}

class _TicketsState extends State<Tickets> {

  RxBool isRefresh = false.obs;
  UtilitiesController utilitiesController = Get.find();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      utilitiesController.listMessageOfTicket(code: widget.ticketCode).then((result){
        if(!result) {
          return;
        }
        totalMessages(utilitiesController.messagesModel.value?.response?.length);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          automaticallyImplyLeading: true,
          forceMaterialTransparency: true,
          leading: GestureDetector(
            onTap: (){
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios_rounded, size: 18)),
          actions: [
            widget.closed == true ? const SizedBox() : IconButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                print(prefs.getString('accessToken'));
                CustomAlert.alertDialogCustomInfo(
                  onTap: (){
                    utilitiesController.closeTicket(code: widget.ticketCode).then((result){
                      if(result){
                        CustomScaffoldMessanger.showAppSnackBar(
                          context,
                          message: "Berhasil menutup pesan",
                          type: SnackBarType.success,
                        );
                        utilitiesController.ticketList();
                      }
                      Get.back();
                    });
                    Get.back();
                  },
                  title: "Informasi",
                  message: "Apakah anda yakin menutup ticket?",
                  moreThanOneButton: true
                );
              },
              icon: Row(
                children: [
                  Icon(EvaIcons.close),
                  Text("Tutup Ticket", style: GoogleFonts.inter(fontWeight: FontWeight.w700))
                ],
              )
            )
          ],
          titleSpacing: 0,
          leadingWidth: 35.0,
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: CustomColor.defaultColor,
                backgroundImage: AssetImage('assets/images/face_admin.png'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Admin TridentPRO", style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 18)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.circle, color: CustomColor.defaultColor, size: 8),
                        const SizedBox(width: 5),
                        Text("Online", style: GoogleFonts.inter(fontWeight: FontWeight.w300, fontSize: 13, color: Colors.black45)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          centerTitle: false,
        ),
        body: Column(
          children: [
            Obx(
              () => Expanded(
                child: totalMessages.value == 0
                  ? const Center(child: Text('Start your conversation now :)'))
                  : RefreshIndicator(
                  strokeWidth: 3,
                    color: CustomColor.defaultColor,
                    onRefresh: () async {
                      await utilitiesController.listMessageOfTicket(code: widget.ticketCode).then((result){
                        if(!result) {
                          return;
                        }
                        totalMessages(utilitiesController.messagesModel.value?.response?.length);
                      });
                    },
                    child: Obx(
                      () => AnimatedList.separated(
                        reverse: false,
                        primary: true,
                        itemBuilder: (context, index, animation) {
                          if(utilitiesController.messagesModel.value?.response?[index].type == "member"){
                            return Padding(
                              padding: EdgeInsets.only(left: size.width / 2.5),
                              child: ChatBubble(
                                elevation: 0.0,
                                padding: EdgeInsets.zero,
                                alignment: Alignment.bottomRight,
                                backGroundColor: CustomColor.defaultColor,
                                clipper: ChatBubbleClipper6(
                                  type: BubbleType.sendBubble,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20.0, top: 7.0),
                                      child: Text("Saya", style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.white)),
                                    ),
                                    const Divider(color: Colors.white38),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                      child: utilitiesController.messagesModel.value?.response?[index].content != null
                                        ? utilitiesController.messagesModel.value!.response![index].content!.contains("https://allmediaindo")
                                          ? CupertinoButton(padding: EdgeInsets.zero, child: Text("Lihat Gambar", style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: CustomColor.defaultColor)), onPressed: (){})
                                          : Obx(() => Text(utilitiesController.messagesModel.value?.response?[index].content ?? "", style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)))
                                        : const SizedBox()
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20.0, bottom: 18.0),
                                      child: Obx(() => Text(utilitiesController.messagesModel.value?.response?[index].time ?? "", style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w300, color: Colors.white))),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                          return Padding(
                            padding: EdgeInsets.only(right: size.width / 2.5),
                            child: ChatBubble(
                              elevation: 0.0,
                              padding: EdgeInsets.zero,
                              backGroundColor: Colors.white,
                              clipper: ChatBubbleClipper6(
                                type: BubbleType.receiverBubble
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0, top: 7.0),
                                    child: Text("Admin", style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.black45)),
                                  ),
                                  const Divider(color: Colors.black12, indent: 8.0),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                                    child: utilitiesController.messagesModel.value?.response?[index].content != null
                                      ? utilitiesController.messagesModel.value!.response![index].content!.contains("https://allmediaindo")
                                        ? CupertinoButton(padding: EdgeInsets.zero, child: Text("Lihat Gambar", style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: CustomColor.defaultColor)), onPressed: (){})
                                        : Obx(() => Text(utilitiesController.messagesModel.value?.response?[index].content ?? "", style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54)))
                                      : const SizedBox()
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0, bottom: 18.0),
                                    child: Obx(() => Text(utilitiesController.messagesModel.value?.response?[index].time ?? "", style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w300, color: Colors.black45))),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        removedSeparatorBuilder: (context, index, animation) => Icon(HeroIcons.trash),
                        separatorBuilder: (context, index, animation) {
                          return const SizedBox();
                        },
                        initialItemCount: totalMessages.value,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                            ),
                      ),
                  ),
              ),
            ),
            widget.closed == true ? const SizedBox() : _MessageBar(widget.ticketCode),
          ],
        )
      ),
    );
  }
}


/// Set of widget that contains TextField and Button to submit message
class _MessageBar extends StatefulWidget {
  const _MessageBar(this.code);
  final String? code;

  @override
  State<_MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<_MessageBar> {
  late final TextEditingController _textController;
  RxString urlPhoto = "".obs;
  RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      color: Colors.grey[100],
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  CustomMaterialBottomSheets.defaultBottomSheet(
                    context,
                    size: size,
                    isScrolledController: false,
                    title: "Pilih Opsi",
                    children: [
                      ListTile(
                        onTap: () async {
                          Get.back();
                          urlPhoto(await CustomImagePicker.pickImageFromCameraAndReturnUrl(useCamera: true));
                          Get.to(() => SendImageChat(imageURL: urlPhoto.value));
                        },
                        leading: Icon(Bootstrap.camera),
                        title: Text("Kamera"),
                      ),
                      ListTile(
                        onTap: () async {
                          Get.back();
                          urlPhoto(await CustomImagePicker.pickImageFromCameraAndReturnUrl());
                          Get.to(() => SendImageChat(imageURL: urlPhoto.value));
                        },
                        leading: Icon(Bootstrap.image),
                        title: Text("Gallery"),
                      ),
                    ]
                  );
                },
                tooltip: "Attach File",
                icon: const Icon(HeroIcons.paper_clip),
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: 4,
                  minLines: 1,
                  autofocus: false,
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
              ),
              Obx(
                () => IconButton(
                  onPressed: (){
                    if(_textController.text != ""){
                      isLoading(true);
                      utilitiesController.sendMessage(
                          code: widget.code,
                          message: _textController.text
                      ).then((result){
                        if(!result){
                          CustomScaffoldMessanger.showAppSnackBar(
                            context,
                            message: "Gagal mengirim pesan",
                            type: SnackBarType.error,
                          );
                        }
                        _textController.clear();
                        isLoading(false);
                        utilitiesController.listMessageOfTicket(code: widget.code).then((result){
                          print("Fungsi dijalankan");
                          totalMessages(utilitiesController.messagesModel.value?.response?.length);
                          if(!result) {
                            return;
                          }
                        });
                      });
                    }
                  },
                  tooltip: "Send Message",
                  icon: isLoading.value ? SizedBox(
                    width: 30,
                    height: 30,
                    child: const CircularProgressIndicator(color: CustomColor.defaultColor)) : const Icon(Bootstrap.send),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  UtilitiesController utilitiesController = Get.find();

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
