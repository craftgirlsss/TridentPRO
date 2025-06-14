import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/bottomsheets/material_bottom_sheets.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/controllers/utilities.dart';
import 'package:tridentpro/src/helpers/handlers/image_picker.dart';
import 'package:tridentpro/src/views/settings/send_image_chat.dart';

class Tickets extends StatefulWidget {
  const Tickets({super.key});

  @override
  State<Tickets> createState() => _TicketsState();
}

class _TicketsState extends State<Tickets> {

  RxBool isRefresh = false.obs;
  UtilitiesController utilitiesController = Get.find();
  RxInt totalMessages = 0.obs;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      utilitiesController.chatList().then((result){
        if(!result) {
          print(utilitiesController.responseMessage.value);
          return;
        }
        totalMessages(utilitiesController.ticketModel.value?.response.length);
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
          leading: GestureDetector(
            onTap: (){
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios_rounded, size: 18)),
          titleSpacing: 0,
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: CustomColor.defaultColor,
                backgroundImage: AssetImage('assets/images/face_admin.png'),
              ),
              const SizedBox(width: 10),
              Column(
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
            ],
          ),
          centerTitle: false,
          actions: [
            Obx(() => IconButton(
              tooltip: "Refresh",
              onPressed: (){
                print("ditekan");
                isRefresh(true);
                utilitiesController.chatList().then((result){
                  if(!result) {
                    print(utilitiesController.responseMessage.value);
                    return;
                  }
                  totalMessages(utilitiesController.ticketModel.value?.response.length);
                });
              }, icon: isRefresh.value ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeCap: StrokeCap.round, strokeWidth: 3, color: CustomColor.defaultColor)) : Icon(Icons.refresh_rounded)))
          ],
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
                        await utilitiesController.chatList().then((result){
                          if(!result) {
                            print(utilitiesController.responseMessage.value);
                            return;
                          }
                          totalMessages(utilitiesController.ticketModel.value?.response.length);
                        });
                      },
                      child: AnimatedList.separated(
                      reverse: true,
                      itemBuilder: (context, index, animation) {
                        if(utilitiesController.ticketModel.value?.response[index].type == "User"){
                          return Padding(
                            padding: EdgeInsets.only(left: size.width / 2.5),
                            child: ChatBubble(
                              elevation: 1,
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
                                    child: Text("Me", style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.white)),
                                  ),
                                  const Divider(color: Colors.white38),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Text(utilitiesController.ticketModel.value?.response[index].content ?? "", style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0, bottom: 18.0),
                                    child: Text(utilitiesController.ticketModel.value?.response[index].time != null ? DateFormat('dd MMM yyyy').add_jms().format(DateTime.parse(utilitiesController.ticketModel.value!.response[index].time!)) : "", style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w300, color: Colors.white)),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                        return Padding(
                          padding: EdgeInsets.only(right: size.width / 2.5),
                          child: ChatBubble(
                            elevation: 1,
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
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Text(utilitiesController.ticketModel.value?.response[index].content ?? "", style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0, bottom: 18.0),
                                  child: Text(utilitiesController.ticketModel.value?.response[index].time != null ? DateFormat('dd MMM yyyy').add_jms().format(DateTime.parse(utilitiesController.ticketModel.value!.response[index].time!)) : "", style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w300, color: Colors.black45)),
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
            const _MessageBar(),
          ],
        )
      ),
    );
  }
}


/// Set of widget that contains TextField and Button to submit message
class _MessageBar extends StatefulWidget {
  const _MessageBar({super.key});

  @override
  State<_MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<_MessageBar> {
  late final TextEditingController _textController;
  RxString urlPhoto = "".obs;

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
                  autofocus: true,
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _submitMessage(),
                tooltip: "Send Message",
                icon: const Icon(Bootstrap.send),
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

  void _submitMessage() async {
    utilitiesController.sendMessage().then((result){
      if(!result){

      }
    });
  }
}
