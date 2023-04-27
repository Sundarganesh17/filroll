import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/providers/messages.dart';
import 'package:filroll_app/screens/chat/screens/chat_preview_screen.dart';
import 'package:filroll_app/screens/chat/widgets/forward_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForwardScreen extends StatefulWidget {
  final messageBody;
  const ForwardScreen({super.key, this.messageBody});

  @override
  State<ForwardScreen> createState() => _ForwardScreenState();
}

class _ForwardScreenState extends State<ForwardScreen> {
  bool isSelect = false;
  String currentUserName = '';
  final String userUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDp();
  }

  void getDp() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(userUid).get();

    setState(() {
      currentUserName = (snap.data() as Map<String, dynamic>)['username'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Forward to',
          style: TextStyle(color: Colors.white),
        ),
        leading: Row(children: [
          SizedBox(width: 25),
          InkWell(
            child: Icon(Icons.arrow_back),
            onTap: () => Navigator.of(context).pop(),
          ),
        ]),
      ),
      body: Container(
          margin: EdgeInsets.fromLTRB(15, 10, 10, 5),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chat')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('personal chats')
                .orderBy('dateTime', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                    strokeWidth: 1.0,
                  ),
                );
              }
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      // onTap: () => setState(() {
                      //   isSelect = true;
                      // }),
                      child: Stack(
                        children: [
                          ForwardWidget(
                              snap: snapshot.data!.docs[index].data()),
                          // if (isSelect)
                          //   Align(
                          //     alignment: Alignment.centerRight,
                          //     child: Icon(
                          //       Icons.check_box,
                          //       color: Colors.white,
                          //     ),
                          //   )
                        ],
                      ),
                    );
                  });
            },
          )),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Color(0XFF1F57E7),
        onPressed: () {
          var i = 0;
          var l = Provider.of<Messages>(context, listen: false).forList;
          for (i; i <= l.length - 1; i++) {
            Provider.of<Messages>(context, listen: false).uploadMessage(
                widget.messageBody,
                l[i],
                '',
                currentUserName,
                widget.messageBody.contains('Images')
                    ? '🖼️ Photo'
                    : widget.messageBody.contains('Audio')
                        ? '🎤 Audio'
                        : 'text',
                '');
            Navigator.of(context).pop();
          }
        },
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
