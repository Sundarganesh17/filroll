import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/model/notification_model.dart';
import 'package:filroll_app/providers/notification.dart';
import 'package:filroll_app/providers/post.dart';
import 'package:filroll_app/screens/animation.dart';
import 'package:filroll_app/screens/circular_progress_indicator_page.dart';
import 'package:filroll_app/screens/comments/comments.dart';
import 'package:filroll_app/screens/feed/home_screen.dart';
import 'package:filroll_app/screens/feed/open_popup.dart';
import 'package:filroll_app/screens/profile/others_profile.dart';
import 'package:filroll_app/screens/update_soon.dart';
import 'package:filroll_app/widgets/like_animation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:video_player/video_player.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:visibility_detector/visibility_detector.dart';

class Trial1 extends StatefulWidget {
  final snap;
  final index;
  const Trial1({super.key, required this.snap, this.index});

  @override
  State<Trial1> createState() => _Trial1State();
}

class _Trial1State extends State<Trial1> {
  bool isLikeAnimating = false;
  bool isLike = false;
  int commentLength = 0;
  int likeCount = 0;
  var createLikeNotification;
  String? dpUrl;
  String? dpUrl1;
  bool isLoading = true;
  bool viewDone = true;
  bool haveStatus = false;
  int view = 0;
  String? userName;
  String postOwnerDpUrl = '';
  String postOwnerUserName = '';
  String postImgUrl = '';
  String thumb = '';
  VideoPlayerController? controller;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    if (widget.snap.isVideo == true) controllerInitiation();
    hadStatus();
    getDp();
    getLikeStatus();
    getCommentsCount();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  hadStatus() async {
    var story = await FirebaseFirestore.instance
        .collection('storyOfUsers')
        .doc('123')
        .get();
    if (story.data()!['uid'].contains(widget.snap.uid)) {
      setState(() => haveStatus = true);
    }
  }

  void controllerInitiation() async {
    var postUrl = await getUrl(widget.snap.postUrl);
    controller = VideoPlayerController.network(
      postUrl,
    )..initialize().then((_) {
        setState(() {});
      });
    chewieController = ChewieController(
      videoPlayerController: controller!,
      looping: true,
    );
  }

  _videoDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [minutes, seconds].join(':');
  }

  void getDp() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    DocumentSnapshot snap1 = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.snap.uid)
        .get();
    var dp = await getUrl('dp-${widget.snap.uid}.jpg');
    var postUrl = await getUrl(widget.snap.postUrl);
    var th = await getUrl(widget.snap.thumbnail);

    setState(() {
      dpUrl = (snap.data() as Map<String, dynamic>)['DPUrl'];
      userName = (snap.data() as Map<String, dynamic>)['username'];
      dpUrl1 = (snap1.data() as Map<String, dynamic>)['DPUrl'];
      postOwnerUserName = (snap1.data() as Map<String, dynamic>)['username'];
      postOwnerDpUrl = dp;
      postImgUrl = postUrl;
      thumb = th;
      likeCount = widget.snap.likes.length;
      view = widget.snap.views.length;
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

  getLikeStatus() {
    if (widget.snap.likes.contains(FirebaseAuth.instance.currentUser!.uid)) {
      setState(() {
        isLike = true;
      });
    }
    if (widget.snap.views.contains(FirebaseAuth.instance.currentUser!.uid)) {
      setState(() {
        viewDone = false;
      });
    }
  }

  void getCommentsCount() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap.postId)
          .collection('comments')
          .get();

      commentLength = snap.docs.length;
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    controller?.pause().then((_) {
      controller?.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = FirebaseAuth.instance.currentUser!;
    var size = MediaQuery.of(context).size;

    return isLoading
        ? const AnimationPage(picName: 'feed1')
        : postOwnerDpUrl.isEmpty
            ? const AnimationPage(picName: 'feed1')
            : Column(
                children: [
                  Container(
                      color: Colors.black,
                      width: size.width,
                      child: Column(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(
                                          OthersProfile(uid: widget.snap.uid),
                                          transition: Transition.zoom,
                                          duration:
                                              Duration(milliseconds: 500));
                                    },
                                    child: SizedBox(
                                      width: size.width * 0.7,
                                      child: ListTile(
                                        visualDensity:
                                            const VisualDensity(horizontal: -4),
                                        leading: Container(
                                          margin: EdgeInsets.only(top: 3),
                                          padding: haveStatus
                                              ? EdgeInsets.all(2)
                                              : EdgeInsets.all(0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              gradient:
                                                  const LinearGradient(colors: [
                                                Color.fromARGB(
                                                    720, 114, 5, 255),
                                                Color.fromARGB(
                                                    167, 22, 115, 255),
                                                Color(0xFF2962FF),
                                              ])),
                                          child: ClipOval(
                                            child: dpUrl1!.contains('https')
                                                ? Image.network(
                                                    dpUrl1!,
                                                    height: 30,
                                                    width: 30,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.network(
                                                    postOwnerDpUrl,
                                                    height: 30,
                                                    width: 30,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        ),
                                        title: Row(
                                          children: [
                                            Text(
                                              postOwnerUserName,
                                              style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 15.0,
                                              ),
                                            ),
                                            if (widget.snap.uid ==
                                                'E1nSlQI2yXbW0zGz7ArXP4xoe9W2')
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 5),
                                                height: 13,
                                                width: 13,
                                                child: SvgPicture.asset(
                                                    'images/icons/verified41.svg'),
                                              ),
                                          ],
                                        ),
                                        subtitle: Row(
                                          children: [
                                            if (widget.snap.location.isNotEmpty)
                                              Text(
                                                widget.snap.location,
                                                style: GoogleFonts.roboto(
                                                  color: Colors.white,
                                                  fontSize: 13.0,
                                                ),
                                              ),
                                            if (widget.snap.location.isNotEmpty)
                                              const SizedBox(
                                                width: 10,
                                              ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 2),
                                              child: Text(
                                                timeago.format(
                                                    widget.snap.dateTime),
                                                style: GoogleFonts.roboto(
                                                  color:
                                                      const Color(0XFF5A5B60),
                                                  fontSize: 10.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () => {
                                      showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) => OpenPopup(
                                                postImage:
                                                    widget.snap.isVideo == true
                                                        ? thumb
                                                        : postImgUrl,
                                                uid: widget.snap.uid,
                                                postId: widget.snap.postId,
                                                postUrl: widget.snap.postUrl,
                                                isVideo: widget.snap.isVideo,
                                                thumb: widget.snap.thumbnail,
                                                likes: likeCount,
                                                views: view,
                                              )),
                                    },
                                    icon: const Icon(
                                      Icons.more_horiz,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onDoubleTap: () {
                                createLikeNotification = LikeNotificationModel(
                                    widget.snap.uid,
                                    user.uid,
                                    dpUrl,
                                    userName,
                                    widget.snap.postId,
                                    widget.snap.isVideo
                                        ? widget.snap.thumbnail
                                        : widget.snap.postUrl,
                                    'Liked your post',
                                    '',
                                    DateTime.now());
                                if (widget.snap.uid != user.uid)
                                  NotificationProvider().uploadLikeNotification(
                                      createLikeNotification,
                                      widget.snap.uid,
                                      widget.snap.postId);
                                Post().doubleTapLikePost(
                                    widget.snap.postId,
                                    widget.snap.uid,
                                    user.uid,
                                    widget.snap.likes);
                                setState(() {
                                  likeCount++;
                                });
                                setState(() {
                                  isLikeAnimating = true;
                                  isLike = true;
                                });
                              },
                              child: Stack(
                                alignment: !widget.snap.isVideo
                                    ? Alignment.center
                                    : Alignment.topLeft,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 0, 5, 12),
                                    child: VisibilityDetector(
                                      key: GlobalKey(),
                                      onVisibilityChanged: (info) {
                                        if (widget.snap.isVideo)
                                          controller!.pause();
                                        if (viewDone) {
                                          Future.delayed(Duration(seconds: 3))
                                              .then(
                                            (value) {
                                              Post().views(
                                                  widget.snap.postId,
                                                  widget.snap.uid,
                                                  user.uid,
                                                  widget.snap.views);
                                              setState(() {
                                                view++;
                                                viewDone = false;
                                              });
                                            },
                                          );
                                          // Post().views(
                                          //     widget.snap.postId,
                                          //     widget.snap.uid,
                                          //     user.uid,
                                          //     widget.snap.views);

                                          // setState(() {
                                          //   view++;
                                          //   viewDone = false;
                                          // });
                                        }
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: widget.snap.postUrl.isEmpty
                                            ? const Center(
                                                child:
                                                    CircularProgrssIndicatorPage())
                                            : widget.snap.isVideo == true
                                                ? Stack(
                                                    children: [
                                                      AspectRatio(
                                                        aspectRatio: controller!
                                                            .value.aspectRatio,
                                                        child: !controller!
                                                                .value
                                                                .isInitialized
                                                            ? const Center(
                                                                child:
                                                                    CircularProgressIndicator(),
                                                              )
                                                            : Chewie(
                                                                controller:
                                                                    chewieController!,
                                                              ),
                                                      ),
                                                      // Positioned.fill(
                                                      //   child: Align(
                                                      //     alignment: Alignment.center,
                                                      //     child: AnimatedOpacity(
                                                      //       duration: const Duration(
                                                      //           milliseconds: 200),
                                                      //       opacity: isLikeAnimating
                                                      //           ? 1
                                                      //           : 0,
                                                      //       child: LikeAnimation(
                                                      //         child: const Icon(
                                                      //           Icons.favorite,
                                                      //           color: Colors.white,
                                                      //           size: 120,
                                                      //         ),
                                                      //         isAnimating:
                                                      //             isLikeAnimating,
                                                      //         duration:
                                                      //             const Duration(
                                                      //                 milliseconds:
                                                      //                     400),
                                                      //         onEnd: () {
                                                      //           setState(() {
                                                      //             isLikeAnimating =
                                                      //                 false;
                                                      //           });
                                                      //         },
                                                      //       ),
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                    ],
                                                  )
                                                : postImgUrl.isEmpty
                                                    ? Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      )
                                                    : Image(
                                                        image: NetworkImage(
                                                            postImgUrl),
                                                        fit: BoxFit.fitWidth,
                                                        width: double.infinity,
                                                      ),
                                      ),
                                    ),
                                  ),
                                  if (!widget.snap.isVideo)
                                    AnimatedOpacity(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      opacity: isLikeAnimating ? 1 : 0,
                                      child: LikeAnimation(
                                        child: const Icon(
                                          Icons.favorite,
                                          color: Colors.white,
                                          size: 120,
                                        ),
                                        isAnimating: isLikeAnimating,
                                        duration:
                                            const Duration(milliseconds: 400),
                                        onEnd: () {
                                          setState(() {
                                            isLikeAnimating = false;
                                          });
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('posts')
                                    .doc(widget.snap.postId)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  var snap = snapshot.data!.data()!;
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        // padding:EdgeInsets.all(1.0),
                                        children: [
                                          Row(
                                            children: [
                                              LikeAnimation(
                                                isAnimating: widget.snap.likes
                                                    .contains(user.uid),
                                                smallLike: true,
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.all(3),
                                                  height: 35,
                                                  width: 35,
                                                  child: InkWell(
                                                    child: isLike
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              if (widget.snap.uid !=
                                                                  user.uid)
                                                                NotificationProvider()
                                                                    .deleteLikeNotification(
                                                                        widget
                                                                            .snap
                                                                            .uid,
                                                                        widget
                                                                            .snap
                                                                            .postId);
                                                              Post().likePost(
                                                                  widget.snap
                                                                      .postId,
                                                                  widget
                                                                      .snap.uid,
                                                                  user.uid,
                                                                  snap[
                                                                      'likes']);
                                                              setState(() {
                                                                likeCount--;
                                                                isLike =
                                                                    !isLike;
                                                              });
                                                            },
                                                            child: Container(
                                                              margin: const EdgeInsets
                                                                      .fromLTRB(
                                                                  6, 0, 6, 8),
                                                              height: 10,
                                                              width: 10,
                                                              child:
                                                                  Image.asset(
                                                                "images/icons/Stroke.png",
                                                              ),
                                                            ),
                                                          )
                                                        : GestureDetector(
                                                            onTap: () {
                                                              createLikeNotification = LikeNotificationModel(
                                                                  widget
                                                                      .snap.uid,
                                                                  user.uid,
                                                                  dpUrl,
                                                                  userName,
                                                                  widget.snap
                                                                      .postId,
                                                                  widget.snap.isVideo
                                                                      ? widget
                                                                          .snap
                                                                          .thumbnail
                                                                      : widget
                                                                          .snap
                                                                          .postUrl,
                                                                  'Liked your post',
                                                                  '',
                                                                  DateTime
                                                                      .now());
                                                              if (widget.snap.uid !=
                                                                  user.uid)
                                                                NotificationProvider()
                                                                    .uploadLikeNotification(
                                                                        createLikeNotification,
                                                                        widget
                                                                            .snap
                                                                            .uid,
                                                                        widget
                                                                            .snap
                                                                            .postId);
                                                              Post().likePost(
                                                                  widget.snap
                                                                      .postId,
                                                                  widget
                                                                      .snap.uid,
                                                                  user.uid,
                                                                  snap[
                                                                      'likes']);
                                                              setState(() {
                                                                likeCount++;
                                                                isLike =
                                                                    !isLike;
                                                              });
                                                            },
                                                            child: SvgPicture
                                                                .asset(
                                                              "images/icons/Heart.svg",
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                    onTap: () {
                                                      SystemChannels.textInput
                                                          .invokeMethod(
                                                              'TextInput.open');
                                                      FocusNode()
                                                          .requestFocus();
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.all(3),
                                                height: 35,
                                                width: 35,
                                                child: InkWell(
                                                    child: SvgPicture.asset(
                                                      "images/icons/Comment.svg",
                                                      fit: BoxFit.fill,
                                                    ),
                                                    onTap: () {
                                                      Get.to(
                                                          CommentsScreen(
                                                            postOwnerDpUrl:
                                                                postOwnerDpUrl,
                                                            postOwnerUsername:
                                                                postOwnerUserName,
                                                            snap: widget.snap,
                                                            haveStatus:
                                                                haveStatus,
                                                          ),
                                                          transition:
                                                              Transition.fade,
                                                          duration: Duration(
                                                              seconds: 1));
                                                    }),
                                              ),
                                              Container(
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        8, 2, 0, 10),
                                                height: 20,
                                                width: 25,
                                                child: SvgPicture.asset(
                                                  "images/icons/Views.svg",
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 2, 0, 10),
                                                child: Text(
                                                    "${snap['views'].length}",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                    )),
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Container(
                                            // height: 40, width: 40,
                                            height: 35, width: 35,
                                            child: InkWell(
                                                onTap: () => Navigator.of(
                                                        context)
                                                    .push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            const UpdateSoon())),
                                                child: SvgPicture.asset(
                                                  "images/icons/Send.svg",
                                                  fit: BoxFit.fill,
                                                )),
                                          ),
                                          SizedBox(
                                            width: 7,
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: Row(children: [
                                          Text('${snap['likes'].length}',
                                              style: GoogleFonts.roboto(
                                                color: Color(0XFFFFFFFF),
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w900,
                                              )),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text("Likes",
                                              style: GoogleFonts.roboto(
                                                color: Color(0XFFAFACAC),
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                              )),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Text(".",
                                                style: GoogleFonts.roboto(
                                                  color: Colors.white,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          StreamBuilder(
                                              stream: FirebaseFirestore.instance
                                                  .collection('posts')
                                                  .doc(widget.snap.postId)
                                                  .collection('comments')
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                }
                                                return Text(
                                                    "${snapshot.data!.docs.length}",
                                                    style: GoogleFonts.roboto(
                                                      color: const Color(
                                                          0XFFFFFFFF),
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ));
                                              }),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text("Comments",
                                              style: GoogleFonts.roboto(
                                                color: const Color(0XFFAFACAC),
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ]),
                                      ),
                                    ],
                                  );
                                }),
                            if (widget.snap.caption.isEmpty)
                              SizedBox(height: 15),
                            if (widget.snap.caption.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 13, top: 5, bottom: 15, right: 20),
                                child: Column(
                                  children: [
                                    ReadMoreText(
                                      widget.snap.caption,
                                      trimLines: 1,
                                      textAlign: TextAlign.start,
                                      preDataTextStyle: TextStyle(
                                          fontWeight: FontWeight.w500),
                                      style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                      colorClickableText: Color(0XFF5A5B60),
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: 'more',
                                      trimExpandedText: '.     ',
                                    ),
                                    if (widget.snap.link.isNotEmpty)
                                      const SizedBox(
                                        height: 3,
                                      ),
                                    if (widget.snap.link.isNotEmpty)
                                      Text(widget.snap.link,
                                          style: GoogleFonts.roboto(
                                            color: Colors.blue,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                          )),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ])),
                ],
              );
  }
}
