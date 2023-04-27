// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:filroll_app/model/notification_model.dart';
// import 'package:filroll_app/providers/notification.dart';
// import 'package:filroll_app/providers/post.dart';
// import 'package:filroll_app/screens/feed%20screens/open_popup.dart';
// import 'package:filroll_app/screens/profile%20screens/others_profile.dart';
// import 'package:filroll_app/widgets/like_animation.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:readmore/readmore.dart';

// class NotificationsPostScreen extends StatefulWidget {
//   final postId;
//   const NotificationsPostScreen({super.key, required this.postId});

//   @override
//   State<NotificationsPostScreen> createState() =>
//       _NotificationsPostScreenState();
// }

// class _NotificationsPostScreenState extends State<NotificationsPostScreen> {
//   bool isLikeAnimating = false;
//   bool isLike = false;
//   int commentLength = 0;
//   var createLikeNotification;
//   String? dpUrl;
//   String? userName;
//   String? caption;
//   String? dateTime;
//   dynamic likes;
//   String? location;
//   String? postUrl;
//   String? uid;
//   var snaps;

//   @override
//   void initState() {
//     super.initState();
//     getDp();
//     getLikeStatus();
//     getCommentsCount();
//   }

//   void getDp() async {
//     DocumentSnapshot snap = await FirebaseFirestore.instance
//         .collection('posts')
//         .doc(widget.postId)
//         .get();

//     setState(() {
//       snaps = snap;
//       dpUrl = (snap.data() as Map<String, dynamic>)['dpUrl'];
//       userName = (snap.data() as Map<String, dynamic>)['username'];
//       caption = (snap.data() as Map<String, dynamic>)['caption'];
//       dateTime = (snap.data() as Map<String, dynamic>)['dateTime'];
//       likes = (snap.data() as Map<String, dynamic>)['likes'];
//       location = (snap.data() as Map<String, dynamic>)['location'];
//       postUrl = (snap.data() as Map<String, dynamic>)['postUrl'];
//       uid = (snap.data() as Map<String, dynamic>)['uid'];
//       if ((snap.data() as Map<String, dynamic>)['likes']
//           .contains(FirebaseAuth.instance.currentUser!.uid)) {
//         setState(() {
//           isLike = true;
//         });
//       }
//     });
//   }

//   getLikeStatus() {}

//   void getCommentsCount() async {
//     try {
//       QuerySnapshot snap = await FirebaseFirestore.instance
//           .collection('posts')
//           .doc(widget.postId)
//           .collection('comments')
//           .get();

//       commentLength = snap.docs.length;
//     } catch (e) {
//       print(e.toString());
//     }
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     final User user = FirebaseAuth.instance.currentUser!;
//     var size = MediaQuery.of(context).size;
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           Container(
//               color: Colors.black,
//               width: size.width,
//               child: Column(children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       width: double.infinity,
//                       child: Row(
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => OthersProfile(
//                                             uid: uid,
//                                           )));
//                             },
//                             child: Container(
//                               width: size.width * 0.6,
//                               child: ListTile(
//                                 visualDensity: VisualDensity(horizontal: -4),
//                                 leading: Container(
//                                   padding: const EdgeInsets.all(2),
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(50),
//                                       gradient: const LinearGradient(colors: [
//                                         Color.fromARGB(720, 114, 5, 255),
//                                         Color.fromARGB(167, 22, 115, 255),
//                                         Color(0xFF2962FF),
//                                       ])),
//                                   child: ClipOval(
//                                     child: Image.network(
//                                       dpUrl!,
//                                       height: 35,
//                                       width: 35,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                 ),
//                                 title: Text(
//                                   userName!,
//                                   style: GoogleFonts.roboto(
//                                     color: Colors.white,
//                                     fontSize: 15.0,
//                                   ),
//                                 ),
//                                 subtitle: Row(
//                                   children: [
//                                     if (location!.isNotEmpty)
//                                       Text(
//                                         location!,
//                                         style: GoogleFonts.roboto(
//                                           color: Colors.white,
//                                           fontSize: 13.0,
//                                         ),
//                                       ),
//                                     if (location!.isNotEmpty)
//                                       const SizedBox(
//                                         width: 10,
//                                       ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(top: 2),
//                                       child: Text(
//                                         dateTime!,
//                                         style: GoogleFonts.roboto(
//                                           color: Color(0XFF5A5B60),
//                                           fontSize: 10.0,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Spacer(),
//                           IconButton(
//                             onPressed: () => {
//                               showModalBottomSheet(
//                                   context: context,
//                                   backgroundColor: Colors.transparent,
//                                   builder: (context) => OpenPopup(
//                                         uid: uid,
//                                         postId: widget.postId,
//                                         postUrl: postUrl,
//                                         isVideo: (snaps.data()
//                                             as Map<String, dynamic>)['isVideo'],
//                                         thumb: (snaps.data() as Map<String,
//                                             dynamic>)['thumbnail'],
//                                       )),
//                             },
//                             icon: const Icon(
//                               Icons.more_horiz,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     GestureDetector(
//                       onDoubleTap: () {
//                         createLikeNotification = LikeNotificationModel(
//                             uid,
//                             FirebaseAuth.instance.currentUser!.uid,
//                             dpUrl,
//                             userName,
//                             widget.postId,
//                             postUrl,
//                             'Liked your post',
//                             '',
//                             DateTime.now());

//                         NotificationProvider().uploadLikeNotification(
//                             createLikeNotification,
//                             uid!,
//                             (snaps.data() as Map<String, dynamic>)['postId']);
//                         Post()
//                             .doubleTapLikePost(widget.postId, user.uid, likes);
//                         setState(() {
//                           isLikeAnimating = true;
//                           isLike = true;
//                         });
//                       },
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(5, 0, 5, 12),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(10),
//                               child: Image(
//                                 image: NetworkImage(postUrl!),
//                                 fit: BoxFit.fitWidth,
//                                 width: double.infinity,
//                                 //width: size.width,
//                               ),
//                             ),
//                           ),
//                           AnimatedOpacity(
//                             duration: const Duration(milliseconds: 200),
//                             opacity: isLikeAnimating ? 1 : 0,
//                             child: LikeAnimation(
//                               // ignore: sort_child_properties_last
//                               child: const Icon(
//                                 Icons.favorite,
//                                 color: Colors.white,
//                                 size: 120,
//                               ),
//                               isAnimating: isLikeAnimating,
//                               duration: const Duration(milliseconds: 400),
//                               onEnd: () {
//                                 setState(() {
//                                   isLikeAnimating = false;
//                                 });
//                               },
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     // ),

//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       // padding:EdgeInsets.all(1.0),
//                       children: [
//                         Row(
//                           children: [
//                             LikeAnimation(
//                               isAnimating: likes.contains(user.uid),
//                               smallLike: true,
//                               child: Container(
//                                 margin: EdgeInsets.all(3),
//                                 height: 35,
//                                 width: 35,
//                                 child: InkWell(
//                                   child: isLike
//                                       ? GestureDetector(
//                                           onTap: () {
//                                             Post().likePost(
//                                                 widget.postId, user.uid, likes);
//                                             setState(() {
//                                               isLike = !isLike;
//                                             });
//                                           },
//                                           child: Container(
//                                             margin: const EdgeInsets.fromLTRB(
//                                                 6, 0, 6, 8),
//                                             height: 10,
//                                             width: 10,
//                                             child: Image.asset(
//                                               "images/icons/Stroke.png",
//                                             ),
//                                           ),
//                                         )
//                                       : GestureDetector(
//                                           onTap: () {
//                                             Post().likePost(
//                                                 widget.postId, user.uid, likes);
//                                             setState(() {
//                                               isLike = !isLike;
//                                             });
//                                           },
//                                           child: SvgPicture.asset(
//                                             "images/icons/Heart.svg",
//                                             fit: BoxFit.fill,
//                                           ),
//                                         ),
//                                   onTap: () {
//                                     SystemChannels.textInput
//                                         .invokeMethod('TextInput.open');
//                                     FocusNode().requestFocus();
//                                   },
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               margin: EdgeInsets.all(3),
//                               height: 35,
//                               width: 35,
//                               child: InkWell(
//                                   child: SvgPicture.asset(
//                                     "images/icons/Comment.svg",
//                                     fit: BoxFit.fill,
//                                   ),
//                                   onTap: () {
//                                     // Navigator.of(context).push(
//                                     //     MaterialPageRoute(
//                                     //         builder: (context) =>
//                                     //             CommentsScreen(snap: snaps)));
//                                   }),
//                             ),
//                             Container(
//                               margin: EdgeInsets.fromLTRB(8, 2, 0, 10),
//                               height: 20,
//                               width: 25,
//                               child: InkWell(
//                                   child: SvgPicture.asset(
//                                 "images/icons/Views.svg",
//                                 fit: BoxFit.fill,
//                               )),
//                             ),
//                             const Padding(
//                               padding: EdgeInsets.fromLTRB(10, 2, 0, 10),
//                               child: Text("680",
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.grey,
//                                   )),
//                             ),
//                           ],
//                         ),
//                         Spacer(),
//                         Container(
//                           // height: 40, width: 40,
//                           height: 35, width: 35,
//                           child: InkWell(
//                               child: SvgPicture.asset(
//                             "images/icons/Send.svg",
//                             fit: BoxFit.fill,
//                           )),
//                         ),
//                       ],
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 12.0),
//                       child: Row(children: [
//                         Text("${likes.length}",
//                             style: GoogleFonts.roboto(
//                               color: Color(0XFFFFFFFF),
//                               fontSize: 12.0,
//                               fontWeight: FontWeight.w900,
//                             )),
//                         const SizedBox(
//                           width: 4,
//                         ),
//                         Text("Likes",
//                             style: GoogleFonts.roboto(
//                               color: Color(0XFFAFACAC),
//                               fontSize: 12.0,
//                               fontWeight: FontWeight.bold,
//                             )),
//                         const SizedBox(
//                           width: 2,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 5),
//                           child: Text(".",
//                               style: GoogleFonts.roboto(
//                                 color: Colors.white,
//                                 fontSize: 12.0,
//                                 fontWeight: FontWeight.bold,
//                               )),
//                         ),
//                         const SizedBox(
//                           width: 4,
//                         ),
//                         Text("$commentLength",
//                             style: GoogleFonts.roboto(
//                               color: const Color(0XFFFFFFFF),
//                               fontSize: 12.0,
//                               fontWeight: FontWeight.w900,
//                             )),
//                         const SizedBox(
//                           width: 4,
//                         ),
//                         Text("Comments",
//                             style: GoogleFonts.roboto(
//                               color: const Color(0XFFAFACAC),
//                               fontSize: 12.0,
//                               fontWeight: FontWeight.bold,
//                             )),
//                       ]),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                           left: 13, top: 5, bottom: 25, right: 20),
//                       child: Column(
//                         children: [
//                           ReadMoreText(
//                             caption!,
//                             trimLines: 1,
//                             textAlign: TextAlign.start,
//                             preDataTextStyle:
//                                 TextStyle(fontWeight: FontWeight.w500),
//                             style: GoogleFonts.roboto(
//                                 color: Colors.white,
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w500),
//                             colorClickableText: Color(0XFF5A5B60),
//                             trimMode: TrimMode.Line,
//                             trimCollapsedText: 'more',
//                             trimExpandedText: '.     ',
//                           ),
//                         ],
//                       ),
//                     ),
//                     // Padding(
//                     //   padding: const EdgeInsets.only(
//                     //       left: 12, top: 5, bottom: 10),
//                     //   child: Row(
//                     //       mainAxisAlignment: MainAxisAlignment.start,
//                     //       children: [
//                     //         Text("Welcome to the gift of the best",
//                     //             style: GoogleFonts.roboto(
//                     //               color: Color(0XFFFFFFFF),
//                     //               fontSize: 12.0,
//                     //               fontWeight: FontWeight.w900,
//                     //             )),
//                     //         SizedBox(
//                     //           // height: 20,
//                     //           // width: 50,
//                     //           child: TextButton(
//                     //             style: TextButton.styleFrom(
//                     //               padding: EdgeInsets.zero,
//                     //               minimumSize: Size(40, 15),
//                     //               tapTargetSize:
//                     //                   MaterialTapTargetSize.shrinkWrap,
//                     //               elevation: 0,
//                     //               primary: Colors.white,
//                     //             ),
//                     //             onPressed: () {},
//                     //             child: Text(
//                     //               "more",
//                     //               style: GoogleFonts.roboto(
//                     //                 color: Color(0XFF5A5B60),
//                     //                 fontSize: 10.0,
//                     //                 fontWeight: FontWeight.w900,
//                     //               ),
//                     //             ),
//                     //           ),
//                     //         )
//                     //       ]),
//                     // )
//                   ],
//                 ),
//               ])),
//           // if (index == 2) Container(color: Colors.black, child: plus()),
//           // if (index == 4) Container(color: Colors.black, child: roll()),
//         ],
//       ),
//     );
//   }
// }
