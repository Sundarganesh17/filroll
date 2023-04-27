import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:filroll_app/providers/post.dart';
import 'package:filroll_app/screens/feed/share_widget.dart';
import 'package:filroll_app/screens/feed/trial.dart';
import 'package:filroll_app/widgets/report_reason.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class OpenPopup extends StatefulWidget {
  final uid;
  final postId;
  final postUrl;
  final isVideo;
  final thumb;
  final postImage;
  final likes;
  final views;
  const OpenPopup(
      {Key? key,
      required this.uid,
      required this.postId,
      required this.postUrl,
      required this.isVideo,
      required this.thumb,
      required this.postImage,
      this.likes,
      this.views})
      : super(key: key);

  @override
  State<OpenPopup> createState() => _OpenPopupState();
}

class _OpenPopupState extends State<OpenPopup> {
  bool isFollowing = false;
  String userUid = FirebaseAuth.instance.currentUser!.uid;
  bool isLoading = true;
  bool isLoading1 = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  fetchUserData() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();

    setState(() {
      isFollowing =
          (snap.data() as Map<String, dynamic>)['followers'].contains(userUid);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white,
              ),
              strokeWidth: 1.0,
            ),
          )
        : SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Container(
              height: widget.uid == userUid
                  ? size.height * 0.24
                  : size.height * 0.36,
              width: size.width * 0.9,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  color: Colors.black.withOpacity(0.6)),
              child: ListView(
                shrinkWrap: false,
                children: [
                  SizedBox(
                    height: size.height * 0.04,
                    width: size.width,
                    child: Align(
                      alignment: Alignment.center,
                      child: IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Image.asset(
                            "images/icons/Vector 87.png",
                            height: 14,
                            width: 14,
                          ),
                          color: Colors.white,
                          iconSize: 20.0,
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('Saved posts')
                          .doc(widget.postId)
                          .set({
                        'postId': widget.postId,
                        'postUrl': widget.postUrl,
                        'isVideo': widget.isVideo,
                        'thumbnail': widget.thumb,
                      });
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Downloaded to FillRoll Saved!')));
                      // final tempDir = await getTemporaryDirectory();
                      // final path = '${tempDir.path}/myfile.jpg';
                      // await Dio().download(widget.postUrl, path);

                      // await GallerySaver.saveImage(path, albumName: 'FilRoll');

                      // ScaffoldMessenger.of(context).showSnackBar(
                      //     const SnackBar(content: Text('Downloaded to Gallery!')));
                    },
                    child: Container(
                      height: size.height * 0.04,
                      width: size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 13, vertical: 6),
                          height: 25,
                          width: 25,
                          child: FittedBox(
                            child: InkWell(
                              child: SvgPicture.asset(
                                "images/icons/Saved.svg",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        Text("Saved",
                            style: GoogleFonts.mPlusRounded1c(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            )),
                      ]),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent),
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShareWidget(
                                    postImage: widget.postImage,
                                    uid: widget.uid,
                                    likes: widget.likes,
                                    views: widget.views,
                                  )));
                      // final url = widget.postUrl;
                      // await Share.share('Check out my New Post here \n\n $url');
                    },
                    child: Container(
                      height: size.height * 0.04,
                      width: size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 13, vertical: 6),
                          height: 25,
                          width: 25,
                          child: FittedBox(
                            child: InkWell(
                              child: SvgPicture.asset(
                                "images/icons/Share.svg",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        Text("Share",
                            style: GoogleFonts.mPlusRounded1c(
                              color: Colors.white,
                              fontSize: 16.0,
                              //letterSpacing: 10,
                              fontWeight: FontWeight.bold,
                            ))
                      ]),
                    ),
                  ),
                  if (userUid != widget.uid)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('Favorite posts')
                            .doc(widget.postId)
                            .set({
                          'postId': widget.postId,
                          'postUrl': widget.postUrl,
                          'isVideo': widget.isVideo,
                          'thumbnail': widget.thumb,
                        });
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Successfully added to Favourite!')));
                      },
                      child: Container(
                        height: size.height * 0.04,
                        width: size.width,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            // padding:EdgeInsets.all(1.0),
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 13, vertical: 6),
                                height: 25,
                                width: 25,
                                child: FittedBox(
                                  child: InkWell(
                                    child: Image.asset(
                                      "images/icons/Favo.png",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              Text("Favourite",
                                  style: GoogleFonts.mPlusRounded1c(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    //letterSpacing: 10,
                                    fontWeight: FontWeight.bold,
                                  ))
                            ]),
                      ),
                    ),
                  // if (userUid != widget.uid)
                  //   if (!isFollowing)
                  //     Container(
                  //       height: size.height * 0.04,
                  //       width: size.width,
                  //       child: Row(children: [
                  //         Container(
                  //           margin: EdgeInsets.fromLTRB(15, 6, 11, 6),
                  //           height: 25,
                  //           width: 25,
                  //           child: FittedBox(
                  //             child: InkWell(
                  //               child: SvgPicture.asset(
                  //                 "images/icons/Not interested.svg",
                  //                 fit: BoxFit.fill,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //         Text("Not interested",
                  //             style: GoogleFonts.mPlusRounded1c(
                  //               color: Colors.white,
                  //               fontSize: 16.0,
                  //               //letterSpacing: 10,
                  //               fontWeight: FontWeight.bold,
                  //             ))
                  //       ]),
                  //     ),
                  if (userUid != widget.uid)
                    isFollowing
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent),
                            onPressed: () async {
                              setState(() {
                                isLoading1 = true;
                              });
                              await Post().followUser(userUid, widget.uid);
                              setState(() {
                                isFollowing = !isFollowing;
                                isLoading1 = false;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 2),
                              height: size.height * 0.04,
                              width: size.width,
                              child: Row(children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(15, 6, 10, 6),
                                  height: 25,
                                  width: 25,
                                  child: FittedBox(
                                    child: InkWell(
                                      child: SvgPicture.asset(
                                        "images/icons/Not interested.svg",
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                                isLoading1
                                    ? CircularProgressIndicator()
                                    : Text("Un Follow",
                                        style: GoogleFonts.mPlusRounded1c(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          //letterSpacing: 10,
                                          fontWeight: FontWeight.bold,
                                        ))
                              ]),
                            ),
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent),
                            child: Container(
                              padding: EdgeInsets.only(left: 2),
                              height: size.height * 0.04,
                              width: size.width,
                              child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  // padding:EdgeInsets.all(1.0),
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(15, 6, 10, 6),
                                      height: 25,
                                      width: 25,
                                      child: FittedBox(
                                        child: InkWell(
                                          child: SvgPicture.asset(
                                            "images/icons/Follow.svg",
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                    isLoading1
                                        ? CircularProgressIndicator()
                                        : Text("Follow",
                                            style: GoogleFonts.mPlusRounded1c(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                              //letterSpacing: 10,
                                              fontWeight: FontWeight.bold,
                                            ))
                                  ]),
                            ),
                            onPressed: () async {
                              setState(() {
                                isLoading1 = true;
                              });
                              await Post().followUser(userUid, widget.uid);
                              setState(() {
                                isFollowing = !isFollowing;
                                isLoading1 = false;
                              });
                            },
                          ),
                  if (userUid != widget.uid)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent),
                      onPressed: () {
                        Navigator.of(context).pop();
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) => ReportReason(
                            uid: widget.uid,
                            postId: widget.postId,
                            postUrl: widget.postUrl,
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 1),
                        height: size.height * 0.04,
                        width: size.width,
                        child: Row(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            // padding:EdgeInsets.all(1.0),
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(12.5, 3, 13, 1),
                                height: 25,
                                width: 25,
                                child: FittedBox(
                                  child: InkWell(
                                    child: SvgPicture.asset(
                                      "images/icons/Report.svg",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              Text("Report",
                                  style: GoogleFonts.mPlusRounded1c(
                                    color: Colors.red,
                                    fontSize: 16.0,
                                    //letterSpacing: 10,
                                    fontWeight: FontWeight.bold,
                                  ))
                            ]),
                      ),
                    ),
                  if (userUid == widget.uid)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent),
                      onPressed: () {
                        Post().deletePost(widget.postId, context);
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 1),
                        height: size.height * 0.04,
                        width: size.width,
                        child: Row(children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(12.5, 3, 12, 1),
                            height: 24,
                            width: 25,
                            child: FittedBox(
                              child: InkWell(
                                  child: Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                            ),
                          ),
                          Text("Delete",
                              style: GoogleFonts.mPlusRounded1c(
                                color: Colors.red,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ))
                        ]),
                      ),
                    ),
                ],
              ),
            ),
          );
  }
}
