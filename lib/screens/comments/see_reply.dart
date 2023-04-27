import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/providers/post.dart';
import 'package:filroll_app/screens/circular_progress_indicator_page.dart';
import 'package:filroll_app/screens/profile/others_profile.dart';
import 'package:filroll_app/widgets/see_more_reply.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class SeeReply extends StatefulWidget {
  final snap;
  final postId;
  final commentOwnerDpUrl;
  final commentOwnerUsername;
  final haveStatus;
  const SeeReply(
      {super.key,
      required this.snap,
      required this.postId,
      required this.commentOwnerDpUrl,
      required this.commentOwnerUsername,
      required this.haveStatus});

  @override
  State<SeeReply> createState() => _SeeReplyState();
}

class _SeeReplyState extends State<SeeReply> {
  final _commentController = TextEditingController();
  String dpUrl = '';
  String dpUrl1 = '';
  String myDp = '';
  String userName = '';

  @override
  void initState() {
    super.initState();
    getDp();
  }

  void getDp() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    DocumentSnapshot snap1 = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.snap['uid'])
        .get();

    var dp = await getUrl('dp-${FirebaseAuth.instance.currentUser!.uid}.jpg');

    setState(() {
      dpUrl = dp;
      dpUrl1 = (snap1.data() as Map<String, dynamic>)['DPUrl'];
      myDp = (snap.data() as Map<String, dynamic>)['DPUrl'];
      userName = (snap.data() as Map<String, dynamic>)['username'];
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
    final user = FirebaseAuth.instance.currentUser;
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final size = MediaQuery.of(context).size;
    return dpUrl.isEmpty
        ? const CircularProgrssIndicatorPage()
        : Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text(
                'Replies',
                style: GoogleFonts.mPlusRounded1c(
                  color: Colors.white, wordSpacing: 0.3,
                  fontSize: 16.0,
                  //letterSpacing: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    )),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        padding: widget.haveStatus
                            ? EdgeInsets.all(2)
                            : EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: const LinearGradient(colors: [
                              Color.fromARGB(720, 114, 5, 255),
                              Color.fromARGB(167, 22, 115, 255),
                              Color(0xFF2962FF),
                            ])),
                        child: dpUrl1.contains('https')
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
                                  widget.commentOwnerDpUrl,
                                  height: 35,
                                  width: 35,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      title: Row(
                        children: [
                          Text(widget.commentOwnerUsername,
                              style: GoogleFonts.mPlusRounded1c(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              )),
                          if (widget.snap['uid'] ==
                              'E1nSlQI2yXbW0zGz7ArXP4xoe9W2')
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              height: 13,
                              width: 13,
                              child: SvgPicture.asset(
                                  'images/icons/verified41.svg'),
                            ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          widget.snap['text'],
                          style: GoogleFonts.mPlusRounded1c(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 72),
                    child: Text(
                      DateFormat('HH:mm')
                          .format(widget.snap['datePublished'].toDate()),
                      style: const TextStyle(
                          color: Color(0XFFADADAD), fontSize: 11),
                    ),
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 58, 58, 58),
                  ),
                  //SeeMoreReply(snap: widget.snap, postId: widget.postId)
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(widget.postId)
                        .collection('comments')
                        .doc(widget.snap['commentId'])
                        .collection('reply comments')
                        .orderBy('datePublished', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => SeeMoreReply(
                            snap: snapshot.data!.docs[index],
                            postId: widget.postId,
                            commentId: widget.snap['commentId']),
                        itemCount: snapshot.data!.docs.length,
                      );
                    },
                  )
                ],
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: mediaQuery.viewInsets,
                child: Row(children: [
                  Row(
                    children: [
                      Padding(
                        padding: widget.haveStatus
                            ? EdgeInsets.all(2)
                            : EdgeInsets.all(0),
                        child: Container(
                          height: size.height * 0.05,
                          width: size.width * 0.8, //color: Colors.white,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Color(0xFF212121)),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: myDp.contains('https')
                                    ? CircleAvatar(
                                        radius: 20,
                                        backgroundImage: NetworkImage(
                                          "https://as2.ftcdn.net/v2/jpg/03/31/69/91/1000_F_331699188_lRpvqxO5QRtwOM05gR50ImaaJgBx68vi.jpg",
                                        ),
                                      )
                                    : CircleAvatar(
                                        radius: 20,
                                        backgroundImage: NetworkImage(
                                          dpUrl,
                                        ),
                                      ),
                              ),
                              SizedBox(
                                width: size.width * 0.5,
                                child: TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  controller: _commentController,
                                  decoration: const InputDecoration(
                                    hintText: 'Add a reply...',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(2, 0, 0, 10),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                  color: Colors.white,
                                  onPressed: () {},
                                  icon: const Icon(
                                      Icons.sentiment_very_satisfied_rounded),
                                  iconSize: 20,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                          padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                          icon: SvgPicture.asset("images/icons/Send.svg"),
                          color: Colors.white,
                          iconSize: 9.0,
                          onPressed: () {
                            Post().postReplyComment(
                                widget.postId,
                                _commentController.text,
                                user!.uid,
                                widget.snap['commentId'],
                                userName,
                                dpUrl);

                            setState(() {
                              _commentController.text = '';
                            });
                          }),
                    ],
                  ),
                ]),
              ),
            ),
          );
  }
}
