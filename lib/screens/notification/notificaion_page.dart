import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/providers/notification.dart';
import 'package:filroll_app/screens/animation.dart';
import 'package:filroll_app/widgets/notification_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var noti;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  fetchNotifications() async {
    await Provider.of<NotificationProvider>(context, listen: false)
        .getUserNotification();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    noti = Provider.of<NotificationProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoading
          ? AnimationPage(picName: 'noti')
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(3, 40, 2, 1),
                      child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          iconSize: 24.0,
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 2, 1),
                      child: Text("Your ",
                          style: GoogleFonts.mPlusRounded1c(
                            color: Colors.white,
                            fontSize: 25.0,
                            //letterSpacing: 10,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 1, 2, 1),
                      child: Text("Notifications ",
                          style: GoogleFonts.mPlusRounded1c(
                            color: Colors.white,
                            fontSize: 25.0,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 2, 1),
                      child: Text("Today",
                          style: GoogleFonts.mPlusRounded1c(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('notification')
                          .orderBy('dateTime', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return AnimationPage(picName: 'noti');
                        }
                        return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) => NotificationList(
                                  snap: snapshot.data!.docs[index].data(),
                                ));
                      },
                    )
                  ]),
            ),
    );
  }
}
