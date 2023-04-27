import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/providers/push_notification.dart';
import 'package:filroll_app/screens/chat/screens/add_chat_screen.dart';
import 'package:filroll_app/screens/chat/screens/chat_screen.dart';
import 'package:filroll_app/screens/chat/widgets/chat_preview_widget.dart';
import 'package:filroll_app/screens/chat/widgets/forward_widget.dart';
import 'package:filroll_app/screens/circular_progress_indicator_page.dart';
import 'package:filroll_app/screens/search/search_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:uuid/uuid.dart';

class ChatPreviewScreen extends StatefulWidget {
  const ChatPreviewScreen({super.key});

  @override
  State<ChatPreviewScreen> createState() => _ChatPreviewScreenState();
}

class _ChatPreviewScreenState extends State<ChatPreviewScreen> {
  bool isRequestPage = false;
  bool isSearch = false;
  final searchController = TextEditingController();
  final String userUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    Provider.of<PushNotification>(context, listen: false)
        .initialiseNotifications();
    super.initState();
  }

  Widget buildSearchResult() {
    return Container(
      height: 400,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('chat')
              .doc(userUid)
              .collection('personal chats')
              .where('userName', isGreaterThanOrEqualTo: searchController.text)
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return searchController.text.isEmpty
                ? SizedBox()
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length >= 4
                        ? 4
                        : snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return ChatPreviewWidget(
                        snap: snapshot.data!.docs[index],
                        from: 'search',
                      );
                    },
                  );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black,
          leading: Row(children: [
            SizedBox(width: 25),
            InkWell(
              child: Icon(Icons.arrow_back),
              onTap: () => Navigator.of(context).pop(),
            ),
          ]),
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => AddChatScreen());
              },
              icon: SvgPicture.asset(
                "images/icons/pl.svg",
              ),
              color: Colors.white,
            ),
          ]),
      body: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 3, bottom: 3),
                      child: Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.only(right: 50),
                        height: 27,
                        width: 188,
                        decoration: BoxDecoration(
                            color: Color(0XFFDCDDE0),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          onTap: () {
                            setState(() {
                              isSearch = true;
                            });
                          },
                          controller: searchController,
                          style: GoogleFonts.mPlusRounded1c(
                              fontSize: 14,
                              color: Color.fromARGB(255, 101, 99, 99),
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                              hintText: 'Search',
                              border: InputBorder.none,
                              hintStyle: GoogleFonts.mPlusRounded1c(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 101, 99, 99),
                                  fontWeight: FontWeight.bold),
                              contentPadding:
                                  EdgeInsets.fromLTRB(10, 0, 0, 12)),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isSearch = false;
                          isRequestPage = false;
                        });
                      },
                      child: Container(
                        height: 27,
                        width: 75,
                        decoration: BoxDecoration(
                            color: isRequestPage
                                ? Colors.black
                                : Color.fromARGB(255, 49, 49, 49),
                            borderRadius: BorderRadius.circular(9)),
                        child: Center(
                          child: Text(
                            'Chat',
                            style: GoogleFonts.mPlusRounded1c(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isSearch = false;
                          isRequestPage = true;
                        });
                      },
                      child: Container(
                        height: 27,
                        width: 75,
                        decoration: BoxDecoration(
                            color: isRequestPage
                                ? Color.fromARGB(255, 49, 49, 49)
                                : Colors.black,
                            borderRadius: BorderRadius.circular(9)),
                        child: Center(
                          child: Text(
                            'Requests',
                            style: GoogleFonts.mPlusRounded1c(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                isSearch
                    ? buildSearchResult()
                    : isRequestPage
                        ? Expanded(
                            child: Container(
                                margin: EdgeInsets.fromLTRB(15, 10, 10, 5),
                                child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('Requests')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .collection('requests')
                                      .orderBy('dateTime', descending: true)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                          strokeWidth: 1.0,
                                        ),
                                      );
                                    }
                                    if (snapshot.data!.docs.length == 0) {
                                      return Container(
                                        margin: EdgeInsets.only(
                                            top: size.height * 0.26,
                                            bottom: size.height * 0.4),
                                        child: Column(
                                          children: [
                                            Center(
                                                child: SvgPicture.asset(
                                              'images/icons/empty.svg',
                                            )),
                                            Text(
                                              'No Message Requests',
                                              style: GoogleFonts.mPlusRounded1c(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          return MyWidget1(
                                              snap: snapshot.data!.docs[index]
                                                  .data());
                                        });
                                  },
                                )),
                          )
                        // Container(
                        //     margin: EdgeInsets.only(
                        //         top: size.height * 0.3, bottom: size.height * 0.4),
                        //     child: Center(
                        //         child: SvgPicture.asset(
                        //       'images/icons/empty.svg',
                        //     )),
                        //   )
                        : Expanded(
                            child: Container(
                                margin: EdgeInsets.fromLTRB(15, 10, 10, 5),
                                child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('chat')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .collection('personal chats')
                                      .orderBy('dateTime', descending: true)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                          strokeWidth: 1.0,
                                        ),
                                      );
                                    }
                                    if (snapshot.data!.docs.length == 0) {
                                      return Container(
                                        margin: EdgeInsets.only(
                                            top: size.height * 0.26,
                                            bottom: size.height * 0.4),
                                        child: Column(
                                          children: [
                                            Center(
                                                child: SvgPicture.asset(
                                              'images/icons/empty.svg',
                                            )),
                                            Text(
                                              'No Messages Yet',
                                              style: GoogleFonts.mPlusRounded1c(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          return ChatPreviewWidget(
                                            snap: snapshot.data!.docs[index]
                                                .data(),
                                            from: '',
                                          );
                                        });
                                  },
                                )),
                          )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyWidget1 extends StatefulWidget {
  final snap;
  const MyWidget1({super.key, this.snap});

  @override
  State<MyWidget1> createState() => _MyWidget1State();
}

class _MyWidget1State extends State<MyWidget1> {
  String dpUrl = '';
  String dpUrl1 = '';
  String userName = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getDp();
  }

  void getDp() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.snap['uid'])
        .get();
    var dp = await getUrl('dp-${widget.snap['uid']}.jpg');
    if (mounted)
      setState(() {
        dpUrl = (snap.data() as Map<String, dynamic>)['DPUrl'];
        dpUrl1 = dp;
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

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CircularProgrssIndicatorPage()
        : InkWell(
            onTap: () => Get.to(() => ChatScreen1(
                  dp: dpUrl.contains('http')
                      ? "https://as2.ftcdn.net/v2/jpg/03/31/69/91/1000_F_331699188_lRpvqxO5QRtwOM05gR50ImaaJgBx68vi.jpg"
                      : dpUrl1,
                  userName: userName,
                  uid: widget.snap['uid'],
                  isPrivate: false,
                  isReq: true,
                  date: widget.snap['dateTime'],
                )),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Card(
                  color: Colors.black,
                  child: Row(
                    children: [
                      dpUrl.contains('http')
                          ? CircleAvatar(
                              backgroundColor: Color.fromARGB(255, 39, 38, 38),
                              radius: 20,
                              backgroundImage: NetworkImage(
                                "https://as2.ftcdn.net/v2/jpg/03/31/69/91/1000_F_331699188_lRpvqxO5QRtwOM05gR50ImaaJgBx68vi.jpg",
                              ),
                            )
                          : CircleAvatar(
                              backgroundColor: Color.fromARGB(255, 39, 38, 38),
                              radius: 20,
                              backgroundImage: NetworkImage(
                                dpUrl1,
                              ),
                            ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Spacer(),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.more_horiz,
                            color: Colors.white,
                          ))
                    ],
                  )),
            ),
          );
  }
}
