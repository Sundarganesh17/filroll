import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/screens/authentication/splash_screen.dart';
import 'package:filroll_app/screens/circular_progress_indicator_page.dart';
import 'package:filroll_app/screens/profile/privacy.dart';
import 'package:filroll_app/screens/profile/set_password.dart';
import 'package:filroll_app/screens/profile/saved.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'help.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isLoading = true;
  bool switchButton = false;
  String? exUserName;
  String? exName;
  String? exGmail;
  final String userUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchIsPrivate();
    fetchUserData();
  }

  fetchUserData() async {
    try {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .get();
      exName = (snap.data() as Map<String, dynamic>)['name'];
      exUserName = (snap.data() as Map<String, dynamic>)['username'];
      exGmail = (snap.data() as Map<String, dynamic>)['email'];
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchIsPrivate() async {
    var snap =
        await FirebaseFirestore.instance.collection('users').doc(userUid).get();
    setState(() {
      switchButton = (snap.data() as Map<String, dynamic>)['isPrivate'];
    });
  }

  Future<void> setPrivate() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .update({'isPrivate': true});
    await FirebaseFirestore.instance
        .collection('private accounts')
        .doc('1')
        .set({
      'privateusers': FieldValue.arrayUnion([userUid])
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Your Account is set as Private'),
      ),
    );
  }

  Future<void> setPublic() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .update({'isPrivate': false});
    await FirebaseFirestore.instance
        .collection('private accounts')
        .doc('1')
        .set({
      'privateusers': FieldValue.arrayRemove([userUid])
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
              margin: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 70),
                  Container(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                        color: const Color(0XFF232125),
                        borderRadius: BorderRadius.circular(8.44)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SvgPicture.asset(
                            "images/icons/Account.svg",
                            fit: BoxFit.fill,
                          ),
                          Text(
                            'Account',
                            style: GoogleFonts.mPlusRounded1c(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  buildTextButton("images/icons/Saved.svg", 'Saved', 19, 19,
                      () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Saved()));
                  }),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 0, 0),
                    child: TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(40, 15),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          elevation: 0,
                        ),
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          "images/icons/Shape.svg",
                          fit: BoxFit.fill,
                        ),
                        label: Text('Request Verification',
                            style: GoogleFonts.mPlusRounded1c(
                                color: const Color(0XFF757171),
                                fontSize: 15,
                                fontWeight: FontWeight.bold))),
                  ),
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  // buildEmailTextButton("images/icons/Mail.svg",
                  //     'Request for Email Change', 17, 17, () {
                  //   showDialog(
                  //     context: context,
                  //     builder: (ctx) => AlertDialog(
                  //       title: Text("Request for Email Id Change"),
                  //       content: Text(
                  //           "Once you get Approval, We'll share link through Old Email for changing New one."),
                  //       actions: <Widget>[
                  //         TextButton(
                  //           onPressed: () {
                  //             Navigator.of(ctx).pop();
                  //           },
                  //           child: Text("Cancel"),
                  //         ),
                  //         TextButton(
                  //           onPressed: () async {
                  //             await FirebaseFirestore.instance
                  //                 .collection('emailChangeRequest')
                  //                 .doc(userUid)
                  //                 .set({
                  //               'userName': exUserName,
                  //               'name': exName,
                  //               'email': exGmail,
                  //               'uid': userUid,
                  //               'dateTime': DateTime.now(),
                  //             });
                  //             Navigator.of(context).pop();
                  //             ScaffoldMessenger.of(context).showSnackBar(
                  //                 const SnackBar(
                  //                     content: Text(
                  //                         'Your Request has been Succesfully Submitted')));
                  //           },
                  //           child: Text("Ok"),
                  //         ),
                  //       ],
                  //     ),
                  //   );
                  // }),
                  SwitchListTile(
                      inactiveTrackColor: const Color.fromARGB(255, 94, 92, 92),
                      hoverColor: Colors.grey,
                      contentPadding: EdgeInsets.zero,
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 0),
                          child: TextButton.icon(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(40, 15),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                elevation: 0,
                              ),
                              onPressed: () {},
                              icon: SizedBox(
                                height: 20,
                                width: 20,
                                child: FittedBox(
                                  child: SvgPicture.asset(
                                    "images/icons/Lock new.svg",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              label: Text('Private Account',
                                  style: GoogleFonts.mPlusRounded1c(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold))),
                        ),
                      ),
                      //tileColor: Colors.white,
                      value: switchButton,
                      onChanged: (bool value) {
                        setState(() => switchButton = value);
                        switchButton ? setPrivate() : setPublic();
                      }),
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 0, 0, 8),
                    child: TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(40, 15),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          elevation: 0,
                        ),
                        onPressed: () {},
                        icon: Container(
                          height: 18,
                          width: 18,
                          child: FittedBox(
                            child: SvgPicture.asset(
                              "images/icons/Edit.svg",
                              color: Color(0XFF757171),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        label: Text('Theme',
                            style: GoogleFonts.mPlusRounded1c(
                                color: Color(0XFF757171),
                                fontSize: 15,
                                fontWeight: FontWeight.bold))),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 40,
                    width: 120,
                    //color: Color(0XFF232125),
                    decoration: BoxDecoration(
                        color: Color(0XFF232125),
                        borderRadius: BorderRadius.circular(8.44)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 18,
                            width: 18,
                            child: SvgPicture.asset(
                              "images/icons/Key.svg",
                              fit: BoxFit.fill,
                            ),
                          ),
                          Text(
                            'Security',
                            style: GoogleFonts.mPlusRounded1c(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          )
                        ]),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  buildTextButton(
                      "images/icons/Profile.svg", 'Password', 20, 20, () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SetPassword()));
                  }),
                  Padding(
                    padding: const EdgeInsets.only(left: 1),
                    child: buildPrivacyTextButton(
                        "images/icons/Opened Lock.svg", 'Privacy', 20, 20, () {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => Privacy()));
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: buildTextButton(
                        "images/icons/Playroll.svg", 'Help', 20, 20, () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Help()));
                    }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: ElevatedButton(
                        // ignore: sort_child_properties_last
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(120, 5, 120, 5),
                          child: Text(
                            "Logout",
                            style: GoogleFonts.mPlusRounded1c(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0XFF1A1920),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.44))),
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => SplashScreen(),
                          ));
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "Version 1.0",
                        style: GoogleFonts.mPlusRounded1c(
                          color: Colors.white,
                          fontSize: 13.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: ElevatedButton(
                        // ignore: sort_child_properties_last
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 176, 5),
                          child: Text(
                            "Delete Account",
                            textAlign: TextAlign.start,
                            style: GoogleFonts.mPlusRounded1c(
                              color: const Color(0XFFD07E7E),
                              fontSize: 16.0,

                              //letterSpacing: 3.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0XFF1A1920),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.44))),
                        onPressed: () {}),
                  ),
                ],
              ),
            )),
    );
  }
}

Widget buildPrivacyTextButton(
    String iconUrl, String buttonName, double h, double w, dynamic onPressed) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    child: TextButton.icon(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size(40, 15),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          elevation: 0,
        ),
        onPressed: onPressed,
        icon: Container(
          height: h,
          width: w,
          child: FittedBox(
            child: SvgPicture.asset(
              color: Color(0XFF757171),
              iconUrl,
              fit: BoxFit.fill,
            ),
          ),
        ),
        label: Text(buttonName,
            style: GoogleFonts.mPlusRounded1c(
                color: Color(0XFF757171),
                fontSize: 15,
                fontWeight: FontWeight.bold))),
  );
}

Widget buildTextButton(
    String iconUrl, String buttonName, double h, double w, dynamic onPressed) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    child: TextButton.icon(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size(40, 15),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          elevation: 0,
        ),
        onPressed: onPressed,
        icon: Container(
          height: h,
          width: w,
          child: FittedBox(
            child: SvgPicture.asset(
              iconUrl,
              fit: BoxFit.fill,
            ),
          ),
        ),
        label: Text(buttonName,
            style: GoogleFonts.mPlusRounded1c(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold))),
  );
}

Widget buildEmailTextButton(
    String iconUrl, String buttonName, double h, double w, dynamic onPressed) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    child: TextButton.icon(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size(40, 15),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          elevation: 0,
        ),
        onPressed: onPressed,
        icon: Container(
          height: h,
          width: w,
          child: FittedBox(
            child: SvgPicture.asset(
              iconUrl,
              fit: BoxFit.fill,
            ),
          ),
        ),
        label: Text(buttonName,
            style: GoogleFonts.mPlusRounded1c(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold))),
  );
}
