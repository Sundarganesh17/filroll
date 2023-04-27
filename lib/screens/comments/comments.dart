import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/model/notification_model.dart';
import 'package:filroll_app/providers/notification.dart';
import 'package:filroll_app/providers/post.dart';
import 'package:filroll_app/screens/circular_progress_indicator_page.dart';
import 'package:filroll_app/screens/profile/others_profile.dart';
import 'package:filroll_app/widgets/comments_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CommentsScreen extends StatefulWidget {
  final postOwnerDpUrl;
  final postOwnerUsername;
  final snap;
  final haveStatus;
  const CommentsScreen(
      {Key? key,
      required this.postOwnerDpUrl,
      required this.postOwnerUsername,
      required this.snap,
      required this.haveStatus})
      : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  bool isVisible = false;
  bool istext = false;
  final _commentController = TextEditingController();
  String dpUrl = '';
  String dpUrl1 = '';
  String myDp = '';
  String userName = '';
  var createCommentNotification;

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
        .doc(widget.snap.uid)
        .get();
    var dp = await getUrl('dp-${FirebaseAuth.instance.currentUser!.uid}.jpg');

    setState(() {
      dpUrl = dp;
      dpUrl1 = (snap1.data() as Map<String, dynamic>)['DPUrl'];
      myDp = (snap.data() as Map<String, dynamic>)['DPUrl'];
      userName = (snap.data() as Map<String, dynamic>)['username'];
      var followers = (snap.data() as Map<String, dynamic>)['followers'];
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
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final MediaQueryData mediaQuery = MediaQuery.of(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      //padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Comments',
            style: GoogleFonts.mPlusRounded1c(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: dpUrl.isEmpty
          ? const Center(
              child: CircularProgrssIndicatorPage(),
            )
          : SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OthersProfile(
                                  uid: widget.snap.uid,
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
                                widget.postOwnerDpUrl,
                                height: 35,
                                width: 35,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    title: Row(
                      children: [
                        Text(widget.postOwnerUsername,
                            style: GoogleFonts.mPlusRounded1c(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            )),
                        if (widget.snap.uid == 'E1nSlQI2yXbW0zGz7ArXP4xoe9W2')
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
                      child: Text(widget.snap.caption,
                          style: GoogleFonts.mPlusRounded1c(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                ),
                const Divider(
                  color: Color.fromARGB(255, 58, 58, 58),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(widget.snap.postId)
                      .collection('comments')
                      .orderBy('datePublished', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => CommentsList(
                        postId: widget.snap.postId,
                        snap: snapshot.data!.docs[index],
                      ),
                      itemCount: snapshot.data!.docs.length,
                    );
                  },
                )
              ]),
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: mediaQuery.viewInsets,
          child: Row(children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Container(
                    height: size.height * 0.05,
                    width: size.width * 0.8, //color: Colors.white,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: const Color(0xFF212121)),
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
                            style: const TextStyle(color: Colors.white),
                            controller: _commentController,
                            decoration: const InputDecoration(
                                hintText: 'Send your Comments...',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                                contentPadding:
                                    EdgeInsets.fromLTRB(2, 0, 0, 10)),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
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
                    onPressed: () async {
                      createCommentNotification = CommentNotificationModel(
                          widget.snap.uid,
                          FirebaseAuth.instance.currentUser!.uid,
                          dpUrl,
                          userName,
                          widget.snap.postId,
                          widget.snap.isVideo
                              ? widget.snap.thumbnail
                              : widget.snap.postUrl,
                          'commented on your post',
                          _commentController.text,
                          DateTime.now());
                      NotificationProvider().uploadCommentNotification(
                          createCommentNotification,
                          widget.snap.uid,
                          widget.snap.postId);
                      Post().postComment(widget.snap.postId,
                          _commentController.text, user!.uid, userName, dpUrl);

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
