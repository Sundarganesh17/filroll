import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/screens/chat/screens/chat_preview_screen.dart';
import 'package:filroll_app/screens/chat/screens/chat_screen.dart';
import 'package:filroll_app/screens/profile/profile_popup.dart';
import 'package:filroll_app/widgets/btm_navigation_bar.dart';
import 'package:filroll_app/providers/post.dart';
import 'package:filroll_app/screens/animation.dart';
import 'package:filroll_app/screens/profile/bottom_grid_view.dart';
import 'package:filroll_app/screens/profile/edit_profile.dart';
import 'package:filroll_app/screens/profile/settings_page.dart';
import 'package:filroll_app/screens/update_soon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

class OthersProfile extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final uid;

  const OthersProfile({super.key, required this.uid});
  @override
  State<OthersProfile> createState() => _OthersProfileState();
}

class _OthersProfileState extends State<OthersProfile> {
  String? myName;
  String? myUserName;
  String? myWebsite;
  String? myBio;
  String? myDpUrl;
  String? myCpUrl;
  String? myDpUrl1;
  String? myCpUrl1;
  String? myUid;
  bool isLoading = true;
  String userUid = FirebaseAuth.instance.currentUser!.uid;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading1 = false;
  bool isPrivate = false;
  bool isReq = false;
  bool isChat = false;
  var blockList;

  @override
  void initState() {
    fetchUserData();
    getUrl1();
    checkMessageRequest();
    checkTheyTextBefore();
    super.initState();
  }

  checkMessageRequest() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection('Requests')
          .doc(widget.uid)
          .collection('requests')
          .doc(userUid)
          .get();
      if (snap.exists) {
        setState(() {
          isReq = true;
        });
      }
    } catch (e) {}
  }

  checkTheyTextBefore() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection('chat')
          .doc(widget.uid)
          .collection('personal chats')
          .doc(userUid)
          .get();
      if (snap.exists) {
        setState(() {
          isChat = true;
        });
      }
      print('is there');
    } catch (e) {}
  }

  fetchUserData() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();
    var dp = await getUrl('dp-${widget.uid}.jpg');
    var cp = await getUrl('cp-${widget.uid}.jpg');
    setState(() {
      myDpUrl = dp;
      myCpUrl = cp;
      myDpUrl1 = (snap.data() as Map<String, dynamic>)['DPUrl'];
      myCpUrl1 = (snap.data() as Map<String, dynamic>)['CPUrl'];
      myName = (snap.data() as Map<String, dynamic>)['name'];
      myUserName = (snap.data() as Map<String, dynamic>)['username'];
      myWebsite = (snap.data() as Map<String, dynamic>)['website'];
      myBio = (snap.data() as Map<String, dynamic>)['bio'];
      if (widget.uid != userUid)
        isPrivate = (snap.data() as Map<String, dynamic>)['isPrivate'];
      followers = (snap.data() as Map<String, dynamic>)['followers'].length;
      following = (snap.data() as Map<String, dynamic>)['following'].length;
      isFollowing =
          (snap.data() as Map<String, dynamic>)['followers'].contains(userUid);
    });
    setState(() {
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

  Future getUrl1() async {
    try {
      CircleAvatar(radius: 33, backgroundImage: NetworkImage(myDpUrl!));
      print('No error');
    } catch (e) {
      print('error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return isLoading
        ? const AnimationPage(picName: 'profile1')
        : Scaffold(
            backgroundColor: Colors.black,
            body: DefaultTabController(
              length: 5,
              child: NestedScrollView(
                headerSliverBuilder: (context, _) {
                  return [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                          Stack(children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(children: [
                                    !myCpUrl1!.contains('https')
                                        ? Container(
                                            height: size.height * 0.15,
                                            width: size.width,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                image: DecorationImage(
                                                  fit: BoxFit.fitWidth,
                                                  image: NetworkImage(myCpUrl!),
                                                )),
                                          )
                                        : Container(
                                            height: size.height * 0.15,
                                            width: size.width,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                image: const DecorationImage(
                                                    fit: BoxFit.fitWidth,
                                                    image: NetworkImage(
                                                        'https://amdmediccentar.rs/wp-content/plugins/uix-page-builder/includes/uixpbform/images/default-cover-4.jpg'))),
                                          ),
                                    Positioned(
                                      top: size.height * 0.05,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 0),
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.menu,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              Get.to(const SettingsPage(),
                                                  transition: Transition
                                                      .leftToRightWithFade,
                                                  duration: Duration(
                                                      milliseconds: 500));
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             const SettingsPage()));
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, top: 2, right: 1),
                                    child: Row(
                                      children: [
                                        Text(
                                          myName!,
                                          style: GoogleFonts.mPlusRounded1c(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        if (widget.uid ==
                                            'E1nSlQI2yXbW0zGz7ArXP4xoe9W2')
                                          Container(
                                            margin: EdgeInsets.only(left: 3),
                                            height: 15,
                                            width: 15,
                                            child: SvgPicture.asset(
                                                'images/icons/verified41.svg'),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8,
                                        top: 0,
                                      ),
                                      child: Text(
                                        '@$myUserName',
                                        style: GoogleFonts.mPlusRounded1c(
                                            color: const Color(0XFF1673FF),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      )),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 2, left: 8),
                                    child: myWebsite != null
                                        ? GestureDetector(
                                            onTap: () async {
                                              // ignore: deprecated_member_use
                                              if (await canLaunch(
                                                  'https://${myWebsite!}')) {
                                                // ignore: deprecated_member_use
                                                await launch(
                                                    'https://${myWebsite!}',
                                                    forceWebView: true,
                                                    enableJavaScript: true);
                                              }
                                            },
                                            child: Text(
                                              myWebsite!,
                                              style: GoogleFonts.roboto(
                                                  color: Colors.blue,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        : Text(
                                            '',
                                            style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500),
                                          ),
                                  ),
                                  Container(
                                    width: size.width * 0.7,
                                    padding:
                                        const EdgeInsets.only(left: 8, top: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        myBio != null
                                            ? ReadMoreText(
                                                myBio!,
                                                trimLines: 2,
                                                preDataTextStyle:
                                                    const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                style: GoogleFonts.roboto(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                colorClickableText:
                                                    const Color(0XFF5A5B60),
                                                trimMode: TrimMode.Line,
                                                trimCollapsedText: 'more',
                                                trimExpandedText: '.     ',
                                              )
                                            : Text(
                                                '',
                                                style: GoogleFonts.roboto(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      if (userUid == widget.uid)
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                            height: 34,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color: Colors.white,
                                            ),
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    side: const BorderSide(
                                                        width: 2,
                                                        color: Colors.white),
                                                    backgroundColor:
                                                        Colors.black,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20))),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const EditProfile()));
                                                },
                                                child: Text(
                                                  "Edit Profile",
                                                  style: GoogleFonts
                                                      .mPlusRounded1c(
                                                    color: Colors.white,
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )),
                                          ),
                                        ),
                                      if (userUid != widget.uid)
                                        isFollowing
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: isLoading1
                                                    ? const CircularProgressIndicator()
                                                    : Container(
                                                        height: 34,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(25),
                                                          color: Colors.white,
                                                        ),
                                                        child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                                side: const BorderSide(
                                                                    width: 2,
                                                                    color: Colors
                                                                        .white),
                                                                backgroundColor:
                                                                    Colors
                                                                        .black,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20))),
                                                            onPressed:
                                                                () async {
                                                              setState(() {
                                                                isLoading1 =
                                                                    true;
                                                              });
                                                              await Post()
                                                                  .followUser(
                                                                      userUid,
                                                                      widget
                                                                          .uid);
                                                              setState(() {
                                                                isFollowing =
                                                                    !isFollowing;
                                                                followers--;
                                                                isLoading1 =
                                                                    false;
                                                              });
                                                            },
                                                            child: Text(
                                                              "Un Follow",
                                                              style: GoogleFonts
                                                                  .mPlusRounded1c(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            )),
                                                      ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: isLoading1
                                                    ? const CircularProgressIndicator()
                                                    : Container(
                                                        height: 34,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(25),
                                                          color: Colors.white,
                                                        ),
                                                        child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                                side: const BorderSide(
                                                                    width: 2,
                                                                    color: Colors
                                                                        .white),
                                                                backgroundColor:
                                                                    Colors
                                                                        .black,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20))),
                                                            onPressed:
                                                                () async {
                                                              setState(() {
                                                                isLoading1 =
                                                                    true;
                                                              });
                                                              await Post()
                                                                  .followUser(
                                                                      userUid,
                                                                      widget
                                                                          .uid);
                                                              setState(() {
                                                                isFollowing =
                                                                    !isFollowing;
                                                                followers++;
                                                                isLoading1 =
                                                                    false;
                                                              });
                                                            },
                                                            child: Text(
                                                              "Follow",
                                                              style: GoogleFonts
                                                                  .mPlusRounded1c(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            )),
                                                      ),
                                              ),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            3, 8, 0, 0),
                                        height: 35,
                                        width: 35,
                                        child: InkWell(
                                            child: SvgPicture.asset(
                                              "images/icons/Chat.svg",
                                              fit: BoxFit.fill,
                                            ),
                                            onTap: () {
                                              Get.to(() => widget.uid == userUid
                                                  ? ChatPreviewScreen()
                                                  : ChatScreen(
                                                      uid: widget.uid,
                                                      dp: !myDpUrl1!
                                                              .contains('https')
                                                          ? myDpUrl
                                                          : myDpUrl1,
                                                      userName: myUserName,
                                                      isChat: isChat,
                                                      isReq: isReq,
                                                    ));
                                            }),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            10, 0, 0, 0),
                                        height: 22.5,
                                        width: 22.5,
                                        child: InkWell(
                                            child: SvgPicture.asset(
                                              "images/icons/New Share.svg",
                                              fit: BoxFit.fill,
                                            ),
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const UpdateSoon()));
                                            }),
                                      ),
                                      if (widget.uid != userUid)
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              15, 0, 0, 0),
                                          height: 22.5,
                                          width: 22.5,
                                          child: InkWell(
                                              child: SvgPicture.asset(
                                                "images/icons/Settings.svg",
                                                fit: BoxFit.fill,
                                              ),
                                              onTap: () {
                                                showModalBottomSheet(
                                                    context: context,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    builder: (context) =>
                                                        ProfilePopup(
                                                            uid: widget.uid));
                                                // Navigator.of(context).push(
                                                //     MaterialPageRoute(
                                                //         builder: (context) =>
                                                //             const UpdateSoon()));
                                              }),
                                        ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.all(10),
                                          height: size.height * 0.049,
                                          width: size.width * 0.27,
                                          child: Row(
                                            children: [
                                              Container(
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 0, 0, 6),
                                                height: 20,
                                                width: 24,
                                                child: InkWell(
                                                    child: SvgPicture.asset(
                                                      "images/icons/Peoples.svg",
                                                      fit: BoxFit.fill,
                                                    ),
                                                    onTap: () {}),
                                              ),
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 6),
                                                      child: Text(
                                                        "Followers",
                                                        style: GoogleFonts
                                                            .mPlusRounded1c(
                                                          color: Colors.white,
                                                          wordSpacing: 0.3,
                                                          fontSize: 12.0,
                                                          //letterSpacing: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 7),
                                                      child: Text(
                                                        "$followers",
                                                        style: GoogleFonts
                                                            .mPlusRounded1c(
                                                          color: Colors.white,
                                                          wordSpacing: 0.3,
                                                          fontSize: 10.0,
                                                          //letterSpacing: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    )
                                                  ])
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(10),
                                          height: size.height * 0.049,
                                          width: size.width * 0.30,
                                          child: Row(
                                            children: [
                                              Container(
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 0, 0, 5),
                                                height: 23,
                                                width: 23,
                                                child: InkWell(
                                                    child: SvgPicture.asset(
                                                      "images/icons/Peopleround.svg",
                                                      fit: BoxFit.fill,
                                                    ),
                                                    onTap: () {}),
                                              ),
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 6),
                                                      child: Text(
                                                        "Following",
                                                        style: GoogleFonts
                                                            .mPlusRounded1c(
                                                          color: Colors.white,
                                                          wordSpacing: 0.3,
                                                          fontSize: 12.0,
                                                          //letterSpacing: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 7),
                                                      child: Text(
                                                        "$following",
                                                        style: GoogleFonts
                                                            .mPlusRounded1c(
                                                          color: Colors.white,
                                                          wordSpacing: 0.3,
                                                          fontSize: 10.0,
                                                          //letterSpacing: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    )
                                                  ])
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ]),
                            Positioned(
                              top: size.height * 0.11,
                              right: size.width * 0.09,
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 3),
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: !myDpUrl1!.contains('https')
                                    ? CircleAvatar(
                                        radius: 33,
                                        backgroundImage: NetworkImage(myDpUrl!))
                                    : const CircleAvatar(
                                        radius: 33,
                                        backgroundImage: NetworkImage(
                                          "https://as2.ftcdn.net/v2/jpg/03/31/69/91/1000_F_331699188_lRpvqxO5QRtwOM05gR50ImaaJgBx68vi.jpg",
                                        ),
                                      ),
                              ),
                            ),
                          ]),
                          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        ],
                      ),
                    ),
                  ];
                },
                body: isPrivate
                    ? Center(
                        child: Container(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: FittedBox(
                                child: SvgPicture.asset(
                                  "images/icons/Lock new.svg",
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'This Account is Private',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ],
                        )),
                      )
                    : Column(
                        children: <Widget>[
                          Material(
                            color: Colors.black,
                            child: TabBar(
                              labelColor: Colors.white,
                              labelStyle: GoogleFonts.mPlusRounded1c(
                                color: Colors.white,
                                fontSize: 9,
                                //letterSpacing: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              unselectedLabelColor: Colors.grey[400],
                              indicatorWeight: 1,
                              tabs: [
                                Tab(
                                  text: 'Photo',
                                  icon: SvgPicture.asset(
                                    "images/icons/Image.svg",
                                    height: 23,
                                    width: 25,
                                  ),
                                ),
                                Tab(
                                  text: 'Short',
                                  icon: SvgPicture.asset(
                                    "images/icons/Roll.svg",
                                    height: 23,
                                    width: 25,
                                  ),
                                ),
                                Tab(
                                  text: 'Favorite',
                                  icon: SvgPicture.asset(
                                    "images/icons/Star.svg",
                                    height: 23,
                                    width: 30,
                                  ),
                                ),
                                Tab(
                                  text: 'Video',
                                  icon: SvgPicture.asset(
                                    "images/icons/Video.svg",
                                    height: 21,
                                    width: 15,
                                  ),
                                ),
                                Tab(
                                  text: '#Tag',
                                  icon: SvgPicture.asset(
                                    "images/icons/Hashtag.svg",
                                    height: 23,
                                    width: 25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                BottomGridView(
                                  uid: widget.uid,
                                ),
                                const BottomGridView1(post: 'shorts'),
                                const BottomGridView3(),
                                BottomGridViewForVideos(uid: widget.uid),
                                const BottomGridView1(post: 'Tag'),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            bottomNavigationBar: const BtmNavigationBar(),
          );
  }
}
