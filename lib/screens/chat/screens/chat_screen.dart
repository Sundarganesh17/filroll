import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/model/message_model.dart';
import 'package:filroll_app/providers/messages.dart';
import 'package:filroll_app/providers/profile/file_storage.dart';
import 'package:filroll_app/screens/chat/widgets/chat_bubble.dart';
import 'package:filroll_app/screens/chat/widgets/message_popup.dart';
import 'package:filroll_app/widgets/report_reason.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:swipe_to/swipe_to.dart';

class ChatScreen extends StatefulWidget {
  final uid;
  final dp;
  final userName;
  final isChat;
  final isReq;
  const ChatScreen(
      {super.key, this.uid, this.dp, this.userName, this.isChat, this.isReq});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  bool isRec = false;
  bool isRecInit = false;
  String path = '';
  FlutterSoundRecorder? _soundRecorder;
  bool isSwipe = false;
  String reply = '';
  bool isDot = false;
  bool sayHi = false;
  final String userUid = FirebaseAuth.instance.currentUser!.uid;
  String currentUserName = '';
  final ScrollController messageController = ScrollController();

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    getDp();
  }

  void getDp() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(userUid).get();

    setState(() {
      currentUserName = (snap.data() as Map<String, dynamic>)['username'];
    });
  }

  void openAudio() async {
    await _soundRecorder!.openRecorder();
  }

  @override
  void dispose() {
    super.dispose();
    _soundRecorder!.closeRecorder();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.4),
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.transparent,
        leading: Row(children: [
          SizedBox(width: 25),
          InkWell(
            child: Icon(Icons.arrow_back),
            onTap: () => Navigator.of(context).pop(),
          ),
        ]),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                widget.dp,
              ),
            ),
            SizedBox(width: 7),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName,
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 3,
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text('');
                      }
                      return snapshot.data!.data()!['isOnline']
                          ? Row(
                              children: [
                                CircleAvatar(
                                    backgroundColor: Colors.blue, radius: 2),
                                SizedBox(width: 3),
                                Text(
                                  'online',
                                  style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            )
                          : SizedBox();
                    }),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isDot = !isDot;
                });
              },
              icon: Icon(Icons.more_vert, color: Colors.white)),
        ],
      ),
      body: GestureDetector(
        onTap: isDot
            ? () {
                setState(() {
                  isDot = false;
                });
              }
            : () {},
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.all(5),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chat')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('personal chats')
                    .doc(widget.uid)
                    .collection('messages')
                    .orderBy('dateTime', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  // if (snapshot.connectionState == ConnectionState.waiting) {
                  //   return Center(child: CircularProgressIndicator());
                  // }
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    messageController.jumpTo(0);
                  });
                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var snap = snapshot.data!.docs[index];
                      return SwipeDetector(
                        onSwipeLeft: (offset) {
                          setState(() {
                            reply = snap['body'];
                            isSwipe = true;
                          });
                        },
                        child: InkWell(
                          onTap: () {
                            // snap['reply'] == snap['body'] {
                            // }
                          },
                          onLongPress: () {
                            showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (context) => MessagePopup(
                                      snap: snapshot.data!.docs[index],
                                      isMe: snapshot.data!.docs[index]
                                              ['senderUid'] ==
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                    )).then((value) {
                              setState(() {
                                if (value != null) {
                                  reply = value;
                                  isSwipe = true;
                                }
                              });
                            });
                          },
                          child: ChatBubble(
                            isSwipe: isSwipe,
                            snap: snapshot.data!.docs[index],
                            isMe: snapshot.data!.docs[index]['senderUid'] ==
                                FirebaseAuth.instance.currentUser!.uid,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            if (isSwipe)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        width: size.width * 0.824,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(0XFF1A1920),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              width: 5,
                              height: 35,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              reply.contains('Images')
                                  ? '🖼️ Photo'
                                  : reply.contains('Audio')
                                      ? '🎤 Audio'
                                      : reply,
                              style: TextStyle(color: Colors.white),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  isSwipe = false;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (isRec)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    width: size.width * 0.825,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Color(0XFF1A1920),
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: InkWell(
                              child: SvgPicture.asset(
                                "images/icons/Audio Delete.svg",
                                fit: BoxFit.fill,
                                // color: Colors.grey,
                                height: 28,
                                width: 28,
                              ),
                              onTap: () async {
                                await _soundRecorder!.stopRecorder();
                                setState(() {
                                  isRec = false;
                                });
                              },
                            ),
                          ),
                          Container(
                            width: 200,
                            child: isRecInit
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      '- - - - - - - - - - - - - - - -',
                                      style: TextStyle(
                                          color: Color(0XFF2F69FE),
                                          fontSize: 30),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 4),
                                    child: Wave(),
                                  ),
                          ),
                          InkWell(
                            child: Icon(
                              Icons.arrow_upward_rounded,
                              color: isRecInit ? Colors.grey : Colors.white,
                              size: 30,
                            ),
                            onTap: () async {
                              setState(() {
                                isRecInit = true;
                              });
                              await _soundRecorder!.stopRecorder();
                              final url = await Provider.of<FileStorage>(
                                      context,
                                      listen: false)
                                  .uploadPostImage(
                                      'Audio', File(path), const Uuid().v1());
                              setState(() {
                                isRecInit = false;
                                isRec = false;
                              });
                              Provider.of<Messages>(context, listen: false)
                                  .uploadMessage(
                                      url,
                                      widget.uid,
                                      widget.userName,
                                      currentUserName,
                                      'Audio',
                                      reply);
                            },
                          ),
                        ]),
                  ),
                ),
              ),
            if (isDot)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isDot = false;
                      });
                    },
                    child: Container(
                      height: 150,
                      width: 120,
                      margin: EdgeInsets.only(right: 20),
                      padding: EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 38, 37, 37),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                              topRight: Radius.circular(0),
                              topLeft: Radius.circular(20))),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              child: Text(
                                'Block                    ',
                                style: TextStyle(color: Colors.white),
                              ),
                              onTap: () async {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(userUid)
                                    .update({
                                  'blockedUsers':
                                      FieldValue.arrayUnion([widget.uid])
                                });
                                Navigator.of(context).pop('Block');
                              },
                            ),
                            InkWell(
                                child: Text(
                                  'Report                    ',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onTap: () {
                                  showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (context) =>
                                        ReportReasonforMessages(
                                      uid: widget.uid,
                                    ),
                                  );
                                  setState(() {
                                    isDot = false;
                                  });
                                }),
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('chat')
                                  .doc(userUid)
                                  .collection('personal chats')
                                  .doc(widget.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Text(
                                    'Mute                    ',
                                    style: TextStyle(color: Colors.white),
                                  );
                                }
                                return InkWell(
                                  onTap: () async {
                                    await FirebaseFirestore.instance
                                        .collection('chat')
                                        .doc(userUid)
                                        .collection('personal chats')
                                        .doc(widget.uid)
                                        .update({
                                      'isMute': snapshot.data!['isMute']
                                          ? false
                                          : true,
                                    });
                                    setState(() {
                                      isDot = false;
                                    });
                                  },
                                  child: Text(
                                    snapshot.data!['isMute']
                                        ? 'Un Mute                    '
                                        : 'Mute                    ',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              },
                            ),
                            InkWell(
                              onTap: () async {
                                await FirebaseFirestore.instance
                                    .collection('chat')
                                    .doc(userUid)
                                    .collection('personal chats')
                                    .doc(widget.uid)
                                    .collection('messages')
                                    .get()
                                    .then((snapshot) {
                                  for (DocumentSnapshot ds in snapshot.docs) {
                                    ds.reference.delete();
                                  }
                                  ;
                                });
                                setState(() {
                                  isDot = false;
                                });
                              },
                              child: Text(
                                'Clear Chat                    ',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
      bottomNavigationBar: widget.isChat
          ? SafeArea(
              child: Padding(
                padding: mediaQuery.viewInsets,
                child: Container(
                  margin: EdgeInsets.only(left: 8, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: size.height * 0.05,
                        width: size.width * 0.825,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0XFF625C5C)),
                            borderRadius: BorderRadius.circular(13),
                            color: Color(0x625C5C)),
                        child: Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.81,
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                controller: _messageController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  hintText: 'Send Message...',
                                  border: InputBorder.none,
                                  hintStyle: GoogleFonts.mPlusRounded1c(
                                    fontSize: 14,
                                    color: isRec ? Colors.red : Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  contentPadding: EdgeInsets.only(top: 3),
                                  prefixIcon: const Icon(
                                    Icons.sentiment_satisfied_alt_outlined,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  suffixIcon: Container(
                                    width: 70,
                                    child: Row(
                                      children: [
                                        Spacer(),
                                        InkWell(
                                          child: Container(
                                            margin: EdgeInsets.only(right: 9),
                                            child: SvgPicture.asset(
                                              "images/icons/Messenger Icon.svg",
                                              fit: BoxFit.fill,
                                              color: Colors.grey,
                                              height: 28,
                                              width: 28,
                                            ),
                                          ),
                                          onTap: () async {
                                            final imageFile =
                                                await ImagePicker().pickImage(
                                              source: ImageSource.gallery,
                                            );
                                            final url =
                                                await Provider.of<FileStorage>(
                                                        context,
                                                        listen: false)
                                                    .uploadPostImage(
                                                        'Images',
                                                        File(imageFile!.path),
                                                        const Uuid().v1());
                                            Provider.of<Messages>(context,
                                                    listen: false)
                                                .uploadMessage(
                                                    url,
                                                    widget.uid,
                                                    widget.userName,
                                                    currentUserName,
                                                    'Image',
                                                    reply);
                                          },
                                        ),
                                        InkWell(
                                          child: Container(
                                            margin: EdgeInsets.only(right: 3),
                                            child: SvgPicture.asset(
                                              "images/icons/Mic.svg",
                                              fit: BoxFit.fill,
                                              color: isRec
                                                  ? Colors.red
                                                  : Colors.grey,
                                              height: 24,
                                              width: 24,
                                            ),
                                          ),
                                          onTap: () async {
                                            // setState(() {
                                            //   isRec = !isRec;
                                            // });
                                            var tempDir =
                                                await getTemporaryDirectory();
                                            //if (isRec) {
                                            setState(() {
                                              path =
                                                  '${tempDir.path}/filroll.aac';
                                              //isRecInit = true;
                                            });
                                            // await _soundRecorder!.stopRecorder();
                                            // final url =
                                            //     await Provider.of<FileStorage>(
                                            //             context,
                                            //             listen: false)
                                            //         .uploadPostImage(
                                            //             'Audio',
                                            //             File(path),
                                            //             const Uuid().v1());
                                            // setState(() {
                                            //   isRecInit = false;
                                            //   isRec = false;
                                            // });
                                            // await FirebaseFirestore.instance
                                            //     .collection('chat')
                                            //     .doc()
                                            //     .set({
                                            //   'text': url,
                                            //   'dateTime': DateTime.now(),
                                            //   'uid': FirebaseAuth
                                            //       .instance.currentUser!.uid
                                            // });
                                            //} else {
                                            await _soundRecorder!
                                                .openRecorder()
                                                .then((e) async {
                                              await _soundRecorder!
                                                  .startRecorder(toFile: path);
                                              return 'ok';
                                            });
                                            setState(() {
                                              isRec = true;
                                            });
                                            // }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Color(0XFF1F57E7),
                                shape: BoxShape.circle),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 8, right: 2),
                                child: SvgPicture.asset(
                                  "images/icons/Send.svg",
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          onTap: () async {
                            if (_messageController.text.isNotEmpty) {
                              var msg = _messageController.text;
                              _messageController.clear();
                              Provider.of<Messages>(context, listen: false)
                                  .uploadMessage(
                                      msg,
                                      widget.uid,
                                      widget.userName,
                                      currentUserName,
                                      'text',
                                      reply);
                              setState(() {
                                isSwipe = false;
                                reply = '';
                              });
                            }
                          }),
                      SizedBox(width: 5),
                    ],
                  ),
                ),
              ),
            )
          : widget.isReq
              ? Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 10),
                  child: Text(
                    '${widget.userName} has to accept your request to continue chat',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : sayHi
                  ? Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 10),
                      child: Text(
                        '${widget.userName} has to accept your request to continue chat',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          sayHi = true;
                        });
                        Provider.of<Messages>(context, listen: false)
                            .sendRequest(widget.uid, widget.userName);
                      },
                      child: Text('Send Message Request'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 19, 52, 79)),
                    ),
    );
  }
}

class Wave extends StatelessWidget {
  List<Color> colors = [
    Color(0XFF1F57E7),
    Color(0XFF1F57E7),
    Color(0XFF1F57E7),
    Color(0XFF1F57E7)
  ];
  List<int> duration = [400, 800, 600, 500, 900];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
          20,
          (index) => WaveAnim(
              duration: duration[index % 5], color: colors[index % 4])),
    );
  }
}

class WaveAnim extends StatefulWidget {
  final int duration;
  final Color color;
  const WaveAnim({super.key, required this.duration, required this.color});

  @override
  State<WaveAnim> createState() => _WaveAnimState();
}

class _WaveAnimState extends State<WaveAnim>
    with SingleTickerProviderStateMixin {
  Animation<double>? animation;
  AnimationController? animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.duration));
    final curvedAnimation =
        CurvedAnimation(parent: animationController!, curve: Curves.easeInCirc);
    animation = Tween<double>(begin: 0, end: 100).animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      });
    animationController!.repeat(reverse: true, max: 1);
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      width: 2.54,
      height: animation!.value,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: widget.color,
      ),
    );
  }
}

class ChatScreen1 extends StatefulWidget {
  final uid;
  final dp;
  final userName;
  final isPrivate;
  final isReq;
  final date;
  const ChatScreen1(
      {super.key,
      this.uid,
      this.dp,
      this.userName,
      this.isPrivate,
      this.isReq,
      this.date});

  @override
  State<ChatScreen1> createState() => _ChatScreen1State();
}

class _ChatScreen1State extends State<ChatScreen1> {
  final _messageController = TextEditingController();
  bool isRec = false;
  bool isRecInit = false;
  String path = '';
  FlutterSoundRecorder? _soundRecorder;
  bool isSwipe = false;
  String reply = '';
  bool isDot = false;
  bool sayHi = false;
  final String userUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    //openAudio();
  }

  void openAudio() async {
    await _soundRecorder!.openRecorder();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _soundRecorder!.closeRecorder();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: Colors.black,
          leading: Row(children: [
            SizedBox(width: 25),
            InkWell(
              child: Icon(Icons.arrow_back),
              onTap: () => Navigator.of(context).pop(),
            ),
          ]),
          title: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(
                  widget.dp,
                ),
              ),
              SizedBox(width: 7),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userName,
                    style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text('');
                        }
                        return snapshot.data!.data()!['isOnline']
                            ? Row(
                                children: [
                                  CircleAvatar(
                                      backgroundColor: Colors.blue, radius: 2),
                                  SizedBox(width: 3),
                                  Text(
                                    'online',
                                    style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              )
                            : SizedBox();
                      }),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    isDot = true;
                  });
                },
                icon: Icon(Icons.more_vert, color: Colors.white)),
          ],
        ),
        body: Stack(
          children: [
            Container(
              child: Positioned(
                bottom: 10,
                left: 20,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(4, 4, 8, 4),
                  padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                  decoration: BoxDecoration(
                      color: Color(0XFF007AFE),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(20))),
                  child: Text(
                    'Hi',
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: ElevatedButton(
          onPressed: () async {
            print(widget.uid);
            var msgId = const Uuid().v1();
            var messageModel = MessageModel(widget.uid, userUid, msgId, 'Hi',
                widget.date.toDate(), '', true, false, 'text');
            await FirebaseFirestore.instance
                .collection('chat')
                .doc(userUid)
                .collection('personal chats')
                .doc(widget.uid)
                .collection('messages')
                .doc(msgId)
                .set(messageModel.toJson());
            await FirebaseFirestore.instance
                .collection('chat')
                .doc(userUid)
                .collection('personal chats')
                .doc(widget.uid)
                .set({
              'dateTime': widget.date.toDate(),
              'uid': widget.uid,
              'isReq': true,
              'isMute': false,
              'lastMsg': 'Hi',
            });
            await FirebaseFirestore.instance
                .collection('chat')
                .doc(widget.uid)
                .collection('personal chats')
                .doc(userUid)
                .update({
              'isReq': true,
            });
            await FirebaseFirestore.instance
                .collection('Requests')
                .doc(userUid)
                .collection('requests')
                .doc(widget.uid)
                .delete();
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => ChatScreen(
                dp: widget.dp,
                userName: widget.userName,
                uid: widget.uid,
                isChat: true,
                isReq: true,
              ),
            ));
            // Get.to(() => ChatScreen(
            //       dp: widget.dp,
            //       userName: widget.userName,
            //       uid: widget.uid,
            //       isPrivate: false,
            //       isReq: true,
            //     ));
          },
          child: Text('Accept Request'),
          style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 19, 52, 79)),
        ));
  }
}
