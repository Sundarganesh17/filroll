import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/screens/feed/pic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ShareWidget extends StatefulWidget {
  final uid;
  final postImage;
  final likes;
  final views;
  const ShareWidget(
      {super.key, this.postImage, this.uid, this.likes, this.views});

  @override
  State<ShareWidget> createState() => _ShareWidgetState();
}

class _ShareWidgetState extends State<ShareWidget> {
  String dpUrl = '';
  String dpUrl1 = '';
  String name = '';
  String userName = '';
  bool isLoading = true;
  Uint8List? bytes;
  bool isPressed = false;
  @override
  void initState() {
    super.initState();
    getDp();
  }

  void getDp() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();

    var dp = await getUrl('dp-${widget.uid}.jpg');

    setState(() {
      dpUrl = (snap.data() as Map<String, dynamic>)['DPUrl'];
      dpUrl1 = dp;
      name = (snap.data() as Map<String, dynamic>)['name'];
      userName = (snap.data() as Map<String, dynamic>)['username'];
      isLoading = false;
    });
  }

  Future<String> getUrl(String key) async {
    try {
      final result = await Amplify.Storage.getUrl(key: key);
      return result.url;
    } catch (e) {
      throw e;
    }
  }

  Widget buildFilText() {
    return Positioned(
      top: 15,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10), topLeft: Radius.circular(10)),
        ),
        height: 50,
        child: Row(
          children: [
            SizedBox(width: 3),
            Image.asset(
              'images/homepage/Filroll.png',
              height: 38,
              width: 38,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filroll',
                    style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '@$userName',
                    style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            SizedBox(width: 3)
          ],
        ),
      ),
    );
  }

  Widget buildLikes() {
    return Positioned(
        right: 0,
        bottom: 65,
        child: Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20), topLeft: Radius.circular(20)),
          ),
          child: Row(
            children: [
              Container(
                height: 18,
                width: 18,
                child: Image.asset(
                  "images/icons/Stroke.png",
                ),
              ),
              SizedBox(width: 5),
              Text('${widget.likes}',
                  style: GoogleFonts.roboto(
                    color: Color(0XFFFFFFFF),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w900,
                  )),
              SizedBox(width: 5),
              Container(
                height: 17,
                width: 22,
                child: SvgPicture.asset(
                  "images/icons/Views.svg",
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(width: 5),
              Text("${widget.views}",
                  style: GoogleFonts.roboto(
                    color: Color(0XFFFFFFFF),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w900,
                  )),
              SizedBox(width: 5),
            ],
          ),
        ));
  }

  Widget buildContainer() {
    return Container(
        height: 480,
        width: 300,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(219, 14, 23, 112),
                  blurRadius: 4,
                  spreadRadius: 5)
            ],
            image: DecorationImage(
                image: NetworkImage(widget.postImage), fit: BoxFit.cover)),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.white.withOpacity(0.8), width: 1),
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24)),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    ClipOval(
                      child: !dpUrl.contains('https')
                          ? Image.network(
                              dpUrl1,
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              'https://as2.ftcdn.net/v2/jpg/03/31/69/91/1000_F_331699188_lRpvqxO5QRtwOM05gR50ImaaJgBx68vi.jpg',
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          '@$userName',
                          style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 2),
                      ],
                    ),
                    Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Install Now',
                            style: GoogleFonts.roboto(
                              color: Color(0XFFFFFFFF),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w900,
                            )),
                        Container(
                            height: 25,
                            width: 60,
                            child: FittedBox(
                              child: Image.asset(
                                'images/homepage/Play1.png',
                                fit: BoxFit.cover,
                              ),
                            )),
                      ],
                    ),
                    SizedBox(width: 15),
                  ],
                ),
              ),
            ),
            buildFilText(),
            buildLikes(),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                    image: AssetImage("images/homepage/Splash.png"),
                    fit: BoxFit.cover),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildContainer(),
                    SizedBox(height: 40),
                    GestureDetector(
                      child: Container(
                        height: 35,
                        width: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 3, 15, 28),
                          border: Border.all(
                              color: isPressed ? Colors.black : Colors.white,
                              width: 1),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(219, 14, 23, 112),
                                blurRadius: 4,
                                spreadRadius: 5)
                          ],
                        ),
                        child: Center(
                          child: Text('Share',
                              style: GoogleFonts.roboto(
                                color: Color(0XFFFFFFFF),
                                fontSize: 14.0,
                                fontWeight: FontWeight.w900,
                              )),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          isPressed = true;
                        });
                        final controller = ScreenshotController();
                        controller
                            .captureFromWidget(
                          InheritedTheme.captureAll(
                              context, Material(child: buildContainer())),
                        )
                            .then((capturedImage) async {
                          final appStorage =
                              await getApplicationDocumentsDirectory();
                          final file = File('${appStorage.path}/image.png');
                          file.writeAsBytes(capturedImage);
                          // Navigator.of(context).push(MaterialPageRoute(
                          //   builder: (context) => Pic(pic: capturedImage),
                          // ));
                          await Share.shareFiles(
                              ['${appStorage.path}/image.png'],
                              text:
                                  'https://play.google.com/store/apps/details?id=com.filroll_app');
                          setState(() {
                            isPressed = false;
                          });
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
