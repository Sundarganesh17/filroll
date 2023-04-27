// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/providers/story.dart';
import 'package:filroll_app/screens/animation.dart';
import 'package:filroll_app/screens/chat/screens/chat_preview_screen.dart';
import 'package:filroll_app/screens/chat/screens/chat_screen.dart';
import 'package:filroll_app/screens/feed/trial.dart';
import 'package:filroll_app/screens/notification/notificaion_page.dart';
import 'package:filroll_app/screens/profile/others_profile.dart';
import 'package:filroll_app/screens/update_soon.dart';
import 'package:filroll_app/widgets/btm_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

// ignore: camel_case_types
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  bool isLoading = true;
  String? dpUrl;
  String? dpUrl1 = '';
  bool isNoti = false;
  bool isLikeAnimating = false;
  var lastModified;
  var updatedUsernameDate;
  var updatedUsername;
  final String userUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    updateOnlineStatus(true);
    WidgetsBinding.instance.addObserver(this);
    updateStatus();
    getDp();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      updateOnlineStatus(true);
    } else {
      updateOnlineStatus(false);
    }
    super.didChangeAppLifecycleState(state);
  }

  updateOnlineStatus(bool status) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .update({'isOnline': status});
  }

  updateStatus() async {
    var snap = await FirebaseFirestore.instance
        .collection('storyOfUsers')
        .doc('123')
        .get();
    int i = 0;
    for (i; i < snap.data()!['uid'].length; i++) {
      var userList = snap.data()!['uid'];
      var uid = snap.data()!['uid'][i];
      var snap1 =
          await FirebaseFirestore.instance.collection('story').doc(uid).get();
      List list = snap1.data()!['stories'];
      var i1 = 0;
      for (i1; i1 < list.length; i1++) {
        print(DateTime.now().difference(list[i1]['dateTime'].toDate()).inHours);
        if (DateTime.now().difference(list[i1]['dateTime'].toDate()).inHours >=
            12) {
          list.removeAt(i1);
          var editedList = userList.remove(uid);
          print(editedList);
        }
      }
      if (list.length == 0) {
        await FirebaseFirestore.instance.collection('story').doc(uid).delete();
        userList.remove(uid);
        await FirebaseFirestore.instance
            .collection('storyOfUsers')
            .doc('123')
            .update({'uid': userList});
      } else {
        await FirebaseFirestore.instance
            .collection('story')
            .doc(uid)
            .update({'stories': list});
      }
      list.clear();
    }
  }

  void getDp() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(userUid).get();
    DocumentSnapshot snap1 = await FirebaseFirestore.instance
        .collection('usernameChangeRequest')
        .doc(userUid)
        .get();

    var dp = await getUrl('dp-${userUid}.jpg');
    setState(() {
      dpUrl = dp;
      dpUrl1 = (snap.data() as Map<String, dynamic>)['DPUrl'];
      isNoti = (snap.data() as Map<String, dynamic>)['notification'];
      lastModified =
          (snap.data() as Map<String, dynamic>)['lastModified'].toDate();
      if (snap1.exists) {
        updatedUsernameDate =
            (snap1.data() as Map<String, dynamic>)['dateTime'].toDate();
        updatedUsername =
            (snap1.data() as Map<String, dynamic>)['usernameWantToChange'];
      }
      isLoading = false;
    });
    if (snap1.exists) updateUsername();
  }

  updateUsername() async {
    print(updatedUsernameDate.difference(lastModified).inDays);
    if (updatedUsernameDate.difference(lastModified).inDays >= 30) {
      await FirebaseFirestore.instance.collection('users').doc(userUid).update(
          {'username': updatedUsername, 'lastModified': DateTime.now()});
      await FirebaseFirestore.instance
          .collection('usernameChangeRequest')
          .doc(userUid)
          .delete();
    }
  }

  Future<String> getUrl(String key) async {
    try {
      final result = await Amplify.Storage.getUrl(key: key);
      return result.url;
    } catch (e) {
      throw e;
    }
  }

  void timer() async {
    setState(() {
      isLikeAnimating = true;
    });
    Timer(
        Duration(seconds: 3),
        () => setState(
              () => isLikeAnimating = false,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? AnimationPage(picName: 'feed2')
        : Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                leading: Column(
                  children: [
                    GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: !dpUrl1!.contains('https')
                            ? CircleAvatar(
                                radius: 17,
                                backgroundImage: NetworkImage(dpUrl!))
                            : CircleAvatar(
                                radius: 17,
                                backgroundImage: NetworkImage(
                                  "https://as2.ftcdn.net/v2/jpg/03/31/69/91/1000_F_331699188_lRpvqxO5QRtwOM05gR50ImaaJgBx68vi.jpg",
                                ),
                              ),
                      ),
                      onTap: () {
                        Get.to(
                            OthersProfile(
                              uid: FirebaseAuth.instance.currentUser!.uid,
                            ),
                            transition: Transition.leftToRightWithFade,
                            duration: Duration(milliseconds: 500));
                      },
                    ),
                  ],
                ),
                actions: <Widget>[
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.data!.data()!['notification']) {
                          // timer();
                        }
                        return Container(
                          margin: EdgeInsets.all(2),
                          height: 20,
                          width: 20,
                          child: FittedBox(
                            child: InkWell(
                                child: snapshot.data!.data()!['notification']
                                    // ? isLikeAnimating
                                    //     ? AnimatedOpacity(
                                    //         duration: const Duration(
                                    //             milliseconds: 200),
                                    //         opacity: isLikeAnimating ? 1 : 0,
                                    //         child: LikeAnimation(
                                    //           child: Image.asset(
                                    //             "images/icons/Notification2.png",
                                    //             fit: BoxFit.fill,
                                    //           ),
                                    //           isAnimating: isLikeAnimating,
                                    //           duration: const Duration(
                                    //               milliseconds: 400),
                                    //           onEnd: () {
                                    //             setState(() {
                                    //               isLikeAnimating = false;
                                    //             });
                                    //           },
                                    //         ),
                                    //       )
                                    //     :
                                    ? Image.asset(
                                        "images/icons/Notification2.png",
                                        fit: BoxFit.fill,
                                      )
                                    : Image.asset(
                                        "images/icons/Notification.png",
                                        fit: BoxFit.fill,
                                      ),
                                onTap: () {
                                  setState(() {
                                    isNoti = false;
                                  });
                                  Get.to(NotificationScreen(),
                                      transition:
                                          Transition.rightToLeftWithFade,
                                      duration: Duration(milliseconds: 500));
                                }),
                          ),
                        );
                      }),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(2, 9, 2, 2),
                    height: 35,
                    width: 35,
                    child: FittedBox(
                      child: InkWell(
                          child: SvgPicture.asset(
                            "images/icons/Send.svg",
                            fit: BoxFit.fill,
                          ),
                          onTap: () async {
                            // Provider.of<Story>(context, listen: false)
                            //     .getPreSignedUrl();
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => const UpdateSoon()));
                            Get.to(() => ChatPreviewScreen(),
                                transition: Transition.rightToLeft);
                            // print(updatedUsernameDate
                            //     .difference(lastModified)
                            //     .inDays);
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => const UpdateSoon()));
                          }),
                    ),
                  ),
                ]),
            body: Trial(),
            bottomNavigationBar: BtmNavigationBar(),
          );
  }
}
