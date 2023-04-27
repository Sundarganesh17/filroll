import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/screens/profile/others_profile.dart';
import 'package:filroll_app/screens/profile/report.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../providers/post.dart';
import '../screens/circular_progress_indicator_page.dart';

class SeeMoreReply extends StatefulWidget {
  final snap;
  final postId;
  final commentId;
  const SeeMoreReply(
      {super.key,
      required this.snap,
      required this.postId,
      required this.commentId});

  @override
  State<SeeMoreReply> createState() => _SeeMoreReplyState();
}

class _SeeMoreReplyState extends State<SeeMoreReply> {
  bool isLike = false;
  String dpUrl = '';
  String commentOwnerDpUrl = '';
  String commentOwnerUserName = '';
  bool haveStatus = false;

  @override
  void initState() {
    super.initState();
    hadStatus();
    getDp();
    getLikeStatus();
    print(widget.snap['uid']);
  }

  void getDp() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.snap['uid'])
        .get();
    var dp = await getUrl('dp-${widget.snap['uid']}.jpg');

    setState(() {
      commentOwnerDpUrl = dp;
      dpUrl = (snap.data() as Map<String, dynamic>)['DPUrl'];
      commentOwnerUserName = (snap.data() as Map<String, dynamic>)['username'];
    });
  }

  hadStatus() async {
    var story = await FirebaseFirestore.instance
        .collection('storyOfUsers')
        .doc('123')
        .get();
    if (story.data()!['uid'].contains(widget.snap['uid'])) {
      setState(() => haveStatus = true);
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

  getLikeStatus() {
    if (widget.snap['likes'].contains(FirebaseAuth.instance.currentUser!.uid)) {
      setState(() {
        isLike = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return commentOwnerDpUrl.isEmpty
        ? const CircularProgrssIndicatorPage()
        : Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OthersProfile(
                                  uid: widget.snap['uid'],
                                )));
                  },
                  child: ListTile(
                    leading: Container(
                      padding:
                          haveStatus ? EdgeInsets.all(2) : EdgeInsets.all(0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: const LinearGradient(colors: [
                            Color.fromARGB(720, 114, 5, 255),
                            Color.fromARGB(167, 22, 115, 255),
                            Color(0xFF2962FF),
                          ])),
                      child: dpUrl.contains('https')
                          ? ClipOval(
                              child: Image.network(
                                "https://as2.ftcdn.net/v2/jpg/03/31/69/91/1000_F_331699188_lRpvqxO5QRtwOM05gR50ImaaJgBx68vi.jpg",
                                height: 35,
                                width: 35,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipOval(
                              child: Image.network(
                                commentOwnerDpUrl,
                                height: 35,
                                width: 35,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    title: Row(
                      children: [
                        Text(commentOwnerUserName,
                            style: GoogleFonts.mPlusRounded1c(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            )),
                        if (widget.snap['uid'] ==
                            'E1nSlQI2yXbW0zGz7ArXP4xoe9W2')
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            height: 13,
                            width: 13,
                            child:
                                SvgPicture.asset('images/icons/verified41.svg'),
                          ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        widget.snap['text'],
                        style: GoogleFonts.mPlusRounded1c(
                          color: Colors.white,
                          fontSize: 10.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    trailing: Container(
                      width: 50,
                      child: Row(
                        children: [
                          isLike
                              ? GestureDetector(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        top: 4, left: 6, right: 4, bottom: 3),
                                    height: 15,
                                    width: 15,
                                    child: FittedBox(
                                      child: InkWell(
                                        child: Image.asset(
                                          "images/icons/Stroke.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Post().likeReplyComment(
                                        widget.postId,
                                        FirebaseAuth.instance.currentUser!.uid,
                                        widget.snap['likes'],
                                        widget.commentId,
                                        widget.snap['commentId']);
                                    setState(() {
                                      isLike = !isLike;
                                    });
                                  },
                                )
                              : GestureDetector(
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 7.5),
                                    height: 25,
                                    width: 25,
                                    child: FittedBox(
                                      child: InkWell(
                                        child: SvgPicture.asset(
                                          "images/icons/Heart.svg",
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Post().likeReplyComment(
                                        widget.postId,
                                        FirebaseAuth.instance.currentUser!.uid,
                                        widget.snap['likes'],
                                        widget.commentId,
                                        widget.snap['commentId']);
                                    setState(() {
                                      isLike = !isLike;
                                    });
                                  },
                                ),
                          const SizedBox(
                            width: 8,
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minHeight: 2),
                            color: Colors.white,
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => Report(
                                        uid: widget.snap['uid'],
                                        postId: widget.postId,
                                        commentId: widget.commentId,
                                      ));
                            },
                            icon: const Icon(Icons.more_vert_outlined),
                            iconSize: 17,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 75),
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        DateFormat('dd-MMM HH:mm')
                            .format(widget.snap['datePublished'].toDate()),
                        style: const TextStyle(
                            color: Color(0XFFADADAD), fontSize: 11),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    // TextButton(
                    //   style: TextButton.styleFrom(
                    //     padding: EdgeInsets.zero,
                    //     minimumSize: const Size(40, 15),
                    //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    //     elevation: 0,
                    //   ),
                    //   onPressed: () {},
                    //   child: Text(
                    //     "",
                    //     style: GoogleFonts.roboto(
                    //       color: Color(0XFFADADAD),
                    //       fontSize: 10.0,
                    //       fontWeight: FontWeight.w900,
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(
                      width: 8,
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      color: const Color(0XFFADADAD),
                      onPressed: () {},
                      icon: const Icon(Icons.sentiment_very_satisfied_rounded),
                      iconSize: 16,
                    )
                  ]),
                ),
              ],
            ),
          );
  }
}
