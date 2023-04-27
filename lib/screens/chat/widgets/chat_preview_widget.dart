import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/screens/chat/screens/chat_screen.dart';
import 'package:filroll_app/screens/circular_progress_indicator_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPreviewWidget extends StatefulWidget {
  final snap;
  final from;
  const ChatPreviewWidget({super.key, this.snap, this.from});

  @override
  State<ChatPreviewWidget> createState() => _ChatPreviewWidgetState();
}

class _ChatPreviewWidgetState extends State<ChatPreviewWidget> {
  String dpUrl = '';
  String dpUrl1 = '';
  String userName = '';
  bool isLoading = true;
  String userUid = FirebaseAuth.instance.currentUser!.uid;
  bool isChat = true;
  bool isDelete = false;
  bool isBlock = false;

  @override
  void initState() {
    super.initState();
    checkMessageRequest();
    getDp();
  }

  checkMessageRequest() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection('Requests')
          .doc(widget.snap['uid'])
          .collection('requests')
          .doc(userUid)
          .get();
      if (snap.exists) {
        if (mounted)
          setState(() {
            isChat = false;
          });
      }
    } catch (e) {}
  }

  void getDp() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.snap['uid'])
        .get();
    DocumentSnapshot snap1 =
        await FirebaseFirestore.instance.collection('users').doc(userUid).get();
    var dp = await getUrl('dp-${widget.snap['uid']}.jpg');
    if (mounted)
      setState(() {
        if ((snap1.data() as Map<String, dynamic>)['blockedUsers']
            .contains(widget.snap['uid'])) isBlock = true;
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
            onTap: () => isBlock
                ? showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text("Unblock user"),
                      content: Text("Are you sure to Unblock this user"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(userUid)
                                .update({
                              'blockedUsers':
                                  FieldValue.arrayRemove([widget.snap['uid']])
                            });
                            setState(() {
                              isBlock = false;
                            });
                            Navigator.of(ctx).pop();
                          },
                          child: Text("OK"),
                        ),
                      ],
                    ),
                  )
                : Get.to(() => ChatScreen(
                          dp: dpUrl.contains('http')
                              ? "https://as2.ftcdn.net/v2/jpg/03/31/69/91/1000_F_331699188_lRpvqxO5QRtwOM05gR50ImaaJgBx68vi.jpg"
                              : dpUrl1,
                          userName: userName,
                          uid: widget.snap['uid'],
                          isChat: isChat,
                          isReq: true,
                        ))!
                    .then((value) {
                    if (value != null)
                      setState(() {
                        isBlock = true;
                      });
                  }),
            child: Card(
                color: Colors.black,
                child: widget.from.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            dpUrl.contains('http')
                                ? CircleAvatar(
                                    backgroundColor:
                                        Color.fromARGB(255, 39, 38, 38),
                                    radius: 20,
                                    backgroundImage: NetworkImage(
                                      "https://as2.ftcdn.net/v2/jpg/03/31/69/91/1000_F_331699188_lRpvqxO5QRtwOM05gR50ImaaJgBx68vi.jpg",
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundColor:
                                        Color.fromARGB(255, 39, 38, 38),
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
                                SizedBox(
                                  height: 5,
                                ),
                                if (widget.from.isEmpty)
                                  Text(
                                    widget.snap['lastMsg'],
                                    style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300),
                                  )
                              ],
                            ),
                            Spacer(),
                            // if (widget.snap['isMute'])
                            //   Icon(
                            //     Icons.volume_off,
                            //     color: Colors.grey,
                            //     size: 18,
                            //   )
                          ],
                        ),
                      )
                    : Slidable(
                        key: ValueKey(1),
                        // The start action pane is the one at the left or the top side.
                        // startActionPane: ActionPane(
                        //   // A motion is a widget used to control how the pane animates.
                        //   motion: ScrollMotion(),

                        //   // All actions are defined in the children parameter.
                        //   children: [
                        //     // A SlidableAction can have an icon and/or a label.
                        //     SlidableAction(
                        //       onPressed: (context) {},
                        //       backgroundColor: Color(0xFFFE4A49),
                        //       foregroundColor: Colors.white,
                        //       icon: Icons.delete,
                        //       label: 'Delete',
                        //     ),
                        //     SlidableAction(
                        //       onPressed: (context) {},
                        //       backgroundColor: Color(0xFF21B7CA),
                        //       foregroundColor: Colors.white,
                        //       icon: Icons.share,
                        //       label: 'Share',
                        //     ),
                        //   ],
                        // ),

                        // The end action pane is the one at the right or the bottom side.
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dismissible: DismissiblePane(onDismissed: () {}),
                          children: [
                            SlidableAction(
                              onPressed: (context) async {
                                setState(() {
                                  isDelete = true;
                                });
                                await FirebaseFirestore.instance
                                    .collection('chat')
                                    .doc(userUid)
                                    .collection('personal chats')
                                    .doc(widget.snap['uid'])
                                    .collection('messages')
                                    .get()
                                    .then((snapshot) {
                                  for (DocumentSnapshot ds in snapshot.docs) {
                                    ds.reference.delete();
                                  }
                                  ;
                                });
                                await FirebaseFirestore.instance
                                    .collection('chat')
                                    .doc(userUid)
                                    .collection('personal chats')
                                    .doc(widget.snap['uid'])
                                    .set({});
                              },
                              backgroundColor: Colors.red,
                              foregroundColor:
                                  isDelete ? Colors.black : Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                            SlidableAction(
                              onPressed: (context) {},
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              icon: Icons.share,
                              label: 'Share',
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              dpUrl.contains('http')
                                  ? CircleAvatar(
                                      backgroundColor:
                                          Color.fromARGB(255, 39, 38, 38),
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                        "https://as2.ftcdn.net/v2/jpg/03/31/69/91/1000_F_331699188_lRpvqxO5QRtwOM05gR50ImaaJgBx68vi.jpg",
                                      ),
                                    )
                                  : CircleAvatar(
                                      backgroundColor:
                                          Color.fromARGB(255, 39, 38, 38),
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
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    isBlock
                                        ? 'You Blocked this Contact, Tap to Unblock'
                                        : widget.snap['lastMsg']
                                                .contains('Audio')
                                            ? '🎤 Audio'
                                            : widget.snap['lastMsg']
                                                    .contains('Images')
                                                ? '🖼️ Photo'
                                                : widget.snap['lastMsg'],
                                    style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: isBlock ? 10 : 12,
                                        fontWeight: FontWeight.w300),
                                  )
                                ],
                              ),
                              Spacer(),
                              if (widget.snap['isMute'] == true)
                                Icon(
                                  Icons.volume_off,
                                  color: Colors.grey,
                                  size: 18,
                                ),
                              SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                        ),
                      )),
          );
  }
}
