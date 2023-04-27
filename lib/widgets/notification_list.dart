import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:filroll_app/screens/circular_progress_indicator_page.dart';
import 'package:filroll_app/screens/notification/notifications_post_screen.dart';
import 'package:filroll_app/screens/profile/others_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class NotificationList extends StatefulWidget {
  final snap;
  const NotificationList({super.key, required this.snap});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  String notificationOwnerDpUrl = '';
  String notificationOwnerUserName = '';
  String postImg = '';
  String dpUrl = '';
  bool haveStatus = false;

  @override
  void initState() {
    super.initState();
    //hadStatus();
    getDp();
  }

  hadStatus() async {
    var story = await FirebaseFirestore.instance
        .collection('storyOfUsers')
        .doc('123')
        .get();
    if (story.data()!['uid'].contains(widget.snap['currentUserUid'])) {
      setState(() => haveStatus = true);
    }
  }

  void getDp() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.snap['currentUserUid'])
        .get();
    var dp = await getUrl('dp-${widget.snap['currentUserUid']}.jpg');
    var post = await getUrl(widget.snap['postUrl']);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'notification': false});
    setState(() {
      notificationOwnerDpUrl = dp;
      postImg = post;
      dpUrl = (snap.data() as Map<String, dynamic>)['DPUrl'];
      notificationOwnerUserName =
          (snap.data() as Map<String, dynamic>)['username'];
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

  @override
  Widget build(BuildContext context) {
    return notificationOwnerDpUrl.isEmpty
        ? const CircularProgrssIndicatorPage()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildListTile(
                  context,
                  widget.snap['currentUserUid'],
                  dpUrl,
                  notificationOwnerDpUrl,
                  notificationOwnerUserName,
                  widget.snap['body'],
                  DateFormat('dd-MMM HH:mm')
                      .format(widget.snap['dateTime'].toDate()),
                  // widget.snap['body'].contains('commented')
                  //     ? "images/icons/Comment.svg"
                  //     :
                  "images/icons/Stroke.png",
                  postImg,
                  widget.snap['text'],
                  haveStatus),
              // Padding(
              //   padding: const EdgeInsets.only(left: 74),
              //   child: GestureDetector(
              //     child: buildPhoto(postImg),
              //     onTap: () {
              //       // Navigator.of(context).push(MaterialPageRoute(
              //       //     builder: (ctx) => NotificationsPostScreen(
              //       //           postId: widget.snap['postId'],
              //       //         )));
              //     },
              //   ),
              // ),
            ],
          );
  }
}

Widget buildListTile(
    BuildContext context,
    String uid,
    String dpUrl,
    String img,
    String name,
    String action,
    String duration,
    String icon,
    String postImg,
    String comment,
    bool haveStatus) {
  var size = MediaQuery.of(context).size;
  return GestureDetector(
      onTap: () {
        Get.to(OthersProfile(uid: uid), transition: Transition.zoom);
        //   Navigator.of(context)
        //       .push(MaterialPageRoute(builder: (ctx) => OthersProfile(uid: uid)));
      },
      child: Stack(
        children: [
          ListTile(
            leading: Container(
              height: 44,
              width: 44,
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 3),
                    padding: haveStatus ? EdgeInsets.all(2) : EdgeInsets.all(0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: LinearGradient(colors: [
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
                              img,
                              height: 35,
                              width: 35,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  comment.isNotEmpty
                      ? Positioned(
                          top: haveStatus ? 25 : 22,
                          left: haveStatus ? 23 : 21,
                          child: Container(
                            child: Image.asset(
                              "images/icons/CommentNoti.png",
                              height: 21,
                              width: 21,
                            ),
                          ),
                        )
                      : Positioned(
                          top: haveStatus ? 29 : 27,
                          left: haveStatus ? 25 : 23,
                          child: Container(
                            child: SvgPicture.asset(
                              "images/icons/Stroke2.svg",
                              height: 14,
                              width: 14,
                            ),
                          ),
                        ),
                ],
              ),
            ),
            title: Row(
              children: [
                Text(name,
                    style: GoogleFonts.roboto(
                      //letterSpacing: 1,
                      color: Colors.white,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                    )),
                SizedBox(
                  width: 6,
                ),
                Text(action,
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w300,
                    )),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (comment.isNotEmpty) SizedBox(height: 2),
                  if (comment.isNotEmpty)
                    Text(
                      'comment:  "$comment"',
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  if (comment.isNotEmpty) SizedBox(height: 6),
                  Text(
                    duration,
                    style: GoogleFonts.roboto(
                      color: Colors.grey,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            trailing: SizedBox(
              height: 35,
              width: 35,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  postImg,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ));
}

Widget buildPhoto(String postUrl) {
  return Row(
    children: [
      SizedBox(
        height: 35,
        width: 35,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            postUrl,
            fit: BoxFit.fill,
          ),
        ),
      ),
      SizedBox(
        width: 10,
      ),
      // if (commentText.isNotEmpty)
      //   Text(
      //     'comment:  "$commentText"',
      //     style: GoogleFonts.roboto(
      //       color: Colors.white,
      //       fontSize: 12.0,
      //       fontWeight: FontWeight.w600,
      //     ),
      //   ),
    ],
  );
}
