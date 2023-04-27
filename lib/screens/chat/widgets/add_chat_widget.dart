import 'package:filroll_app/screens/chat/screens/chat_screen.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddChatWidget extends StatefulWidget {
  final snap;
  const AddChatWidget({super.key, required this.snap});

  @override
  State<AddChatWidget> createState() => _AddChatWidgetState();
}

class _AddChatWidgetState extends State<AddChatWidget> {
  String dpUrl = '';
  String dpUrl1 = '';
  String userUid = FirebaseAuth.instance.currentUser!.uid;
  bool isChat = false;
  bool isReq = false;

  @override
  void initState() {
    super.initState();
    getUsers();
    checkMessageRequest();
    checkTheyTextBefore();
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
          .doc(widget.snap['uid'])
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

  getUsers() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.snap['uid'])
        .get();
    var dp = await getUrl('dp-${widget.snap['uid']}.jpg');
    setState(() {
      dpUrl = dp;
      dpUrl1 = (snap.data() as Map<String, dynamic>)['DPUrl'];
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
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) => ChatScreen(
                  uid: widget.snap['uid'],
                  dp: dpUrl1.contains('https') ? dpUrl1 : dpUrl,
                  userName: widget.snap['username'],
                  isChat: isChat,
                  isReq: isReq,
                ))));
      },
      child: ListTile(
        leading: CircleAvatar(
            backgroundImage: dpUrl1.contains('https')
                ? NetworkImage(
                    "https://as2.ftcdn.net/v2/jpg/03/31/69/91/1000_F_331699188_lRpvqxO5QRtwOM05gR50ImaaJgBx68vi.jpg")
                : NetworkImage(dpUrl)),
        title: Text(
          widget.snap['username'],
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
    ;
  }
}
