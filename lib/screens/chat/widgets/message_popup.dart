import 'dart:ui';

import 'package:filroll_app/providers/messages.dart';
import 'package:filroll_app/screens/chat/screens/forward_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:clipboard/clipboard.dart';

class MessagePopup extends StatelessWidget {
  final snap;
  final isMe;
  const MessagePopup({super.key, this.isMe, this.snap});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.29,
      width: size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        color: Colors.black.withOpacity(0.4),
        // color: Color.fromARGB(255, 45, 48, 56)
      ),
      child: ListView(children: [
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
          onPressed: () async {
            Navigator.of(context).pop(snap['body']);
          },
          child: Container(
            height: size.height * 0.06,
            width: size.width,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                height: 20,
                width: 20,
                child: FittedBox(
                  child: InkWell(
                    child: SvgPicture.asset(
                      "images/icons/reply1.svg",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Text("Reply",
                  style: GoogleFonts.mPlusRounded1c(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  )),
            ]),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
          onPressed: () async {
            Provider.of<Messages>(context, listen: false).deleteList();
            Get.to(() => ForwardScreen(
                  messageBody: snap['body'],
                ));
          },
          child: Container(
            height: size.height * 0.06,
            width: size.width,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                height: 20,
                width: 20,
                child: FittedBox(
                  child: InkWell(
                    child: SvgPicture.asset(
                      "images/icons/forward1.svg",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Text("Forward",
                  style: GoogleFonts.mPlusRounded1c(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  )),
            ]),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
          onPressed: () async {
            FlutterClipboard.copy(snap['body']);
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied to Clipboard')));
          },
          child: Container(
            height: size.height * 0.06,
            width: size.width,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                height: 20,
                width: 20,
                child: FittedBox(
                  child: InkWell(
                    child: SvgPicture.asset(
                      "images/icons/copy1.svg",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Text("Copy",
                  style: GoogleFonts.mPlusRounded1c(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  )),
            ]),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
          onPressed: () async {
            if (isMe) {
              Navigator.of(context).pop();
              showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => MessagePopup1(snap: snap));
            } else {
              await Provider.of<Messages>(context, listen: false).deleteMessage(
                  snap['receiverUid'], snap['senderUid'], snap['msgId']);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message deleted for Me')));
            }
          },
          child: Container(
            height: size.height * 0.06,
            width: size.width,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                height: 20,
                width: 20,
                child: FittedBox(
                  child: InkWell(
                    child: SvgPicture.asset(
                      "images/icons/del1.svg",
                      fit: BoxFit.fill,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              Text("Delete",
                  style: GoogleFonts.mPlusRounded1c(
                    color: Colors.red,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  )),
            ]),
          ),
        ),
      ]),
    );
  }
}

class MessagePopup1 extends StatelessWidget {
  final snap;
  const MessagePopup1({super.key, this.snap});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.18,
      width: size.width * 0.9,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          color: Colors.black.withOpacity(0.4)),
      child: ListView(children: [
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
          onPressed: () async {
            await Provider.of<Messages>(context, listen: false).deleteforMe(
                snap['receiverUid'], snap['senderUid'], snap['msgId']);
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Message deleted for Me')));
          },
          child: Container(
            height: size.height * 0.06,
            width: size.width,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                height: 20,
                width: 20,
                child: FittedBox(
                  child: InkWell(
                    child: SvgPicture.asset(
                      "images/icons/del1.svg",
                      fit: BoxFit.fill,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              Text("Delete for Me",
                  style: GoogleFonts.mPlusRounded1c(
                    color: Colors.red,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  )),
            ]),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
          onPressed: () async {
            await Provider.of<Messages>(context, listen: false)
                .deleteforEveryone(
                    snap['receiverUid'], snap['senderUid'], snap['msgId']);
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Message deleted for Everyone')));
          },
          child: Container(
            height: size.height * 0.06,
            width: size.width,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                height: 20,
                width: 20,
                child: FittedBox(
                  child: InkWell(
                    child: SvgPicture.asset(
                      "images/icons/del1.svg",
                      fit: BoxFit.fill,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              Text("Delete for Everyone",
                  style: GoogleFonts.mPlusRounded1c(
                    color: Colors.red,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  )),
            ]),
          ),
        ),
      ]),
    );
  }
}
