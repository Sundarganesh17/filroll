import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/providers/messages.dart';
import 'package:filroll_app/screens/chat/screens/forward_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePopup extends StatefulWidget {
  final uid;
  const ProfilePopup({super.key, this.uid});

  @override
  State<ProfilePopup> createState() => _ProfilePopupState();
}

class _ProfilePopupState extends State<ProfilePopup> {
  String userUid = FirebaseAuth.instance.currentUser!.uid;
  var blockList;

  @override
  void initState() {
    getDetail();
    super.initState();
  }

  getDetail() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(userUid).get();

    setState(() {
      blockList = (snap.data() as Map<String, dynamic>)['blockedUsers'];
    });
  }

  @override
  Widget build(BuildContext context) {
    String userUid = FirebaseAuth.instance.currentUser!.uid;
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.23,
      width: size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        color: Colors.black.withOpacity(0.4),
      ),
      child: ListView(children: [
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userUid)
                .update({
              'blockedUsers': blockList.contains(widget.uid)
                  ? FieldValue.arrayRemove([widget.uid])
                  : FieldValue.arrayUnion([widget.uid])
            });
            Navigator.of(context).pop();
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
                      "images/icons/Not interested.svg",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Text(blockList.contains(widget.uid) ? "Unblock" : "Block",
                  style: GoogleFonts.mPlusRounded1c(
                    color: Colors.red,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  )),
            ]),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black.withOpacity(0.7)),
          onPressed: () async {},
          child: Container(
            height: size.height * 0.06,
            width: size.width,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                height: 18,
                width: 18,
                child: FittedBox(
                  child: InkWell(
                    child: Image.asset(
                      "images/icons/Report crop.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Text("Report",
                  style: GoogleFonts.mPlusRounded1c(
                    color: Colors.red,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  )),
            ]),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black.withOpacity(0.7)),
          onPressed: () async {},
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
                      "images/icons/mute.svg",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Text("Mute",
                  style: GoogleFonts.mPlusRounded1c(
                    color: Colors.white,
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
