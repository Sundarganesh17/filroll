import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/providers/messages.dart';
import 'package:filroll_app/providers/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ReportReason extends StatefulWidget {
  final uid;
  final postId;
  final postUrl;
  const ReportReason(
      {Key? key,
      required this.uid,
      required this.postId,
      required this.postUrl})
      : super(key: key);

  @override
  State<ReportReason> createState() => _ReportReasonState();
}

class _ReportReasonState extends State<ReportReason> {
  String userName = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getDp();
  }

  void getDp() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();

    setState(() {
      userName = (snap.data() as Map<String, dynamic>)['username'];
    });
  }

  Widget buildReasonText(String text) {
    return TextButton(
      onPressed: () async {
        setState(() {
          isLoading = true;
        });
        Provider.of<Post>(context, listen: false).reportForPosts(
            userName,
            FirebaseAuth.instance.currentUser!.uid,
            widget.postId,
            widget.uid,
            text);

        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Your Report was succesfully submitted')));
      },
      child: Text(text,
          style: GoogleFonts.roboto(
            color: Colors.grey,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        // physics: const NeverScrollableScrollPhysics(),
        child: Container(
      height: size.height * 0.9,
      width: size.width * 0.9,
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          color: Color.fromARGB(255, 31, 31, 31)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text("Report",
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 7.0),
            child: Text("Provide any reason for this Report?",
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                )),
          ),
          SizedBox(
            height: 10,
          ),
          buildReasonText("Voilence or dangerous organisations"),
          buildReasonText('Suicide or self-injury'),
          buildReasonText('Scam or fraud'),
          buildReasonText('False information'),
          buildReasonText('bullying or harrassment'),
          buildReasonText('Intellectual property violation'),
          buildReasonText('Sale of illegal or regulated goods'),
          buildReasonText('Eating disorders'),
          buildReasonText('Sale of counterfeit goods or documents'),
          buildReasonText('Just don\'t want to see it'),
          buildReasonText('It\'s threatening a person or place'),
          buildReasonText('It\'s an inappropriate snap of someone else')
        ],
      ),
    ));
  }
}

class ReportReasonForComments extends StatefulWidget {
  final uid;
  final postId;
  final commentId;
  const ReportReasonForComments(
      {Key? key,
      required this.uid,
      required this.postId,
      required this.commentId})
      : super(key: key);

  @override
  State<ReportReasonForComments> createState() =>
      _ReportReasonForCommentsState();
}

class _ReportReasonForCommentsState extends State<ReportReasonForComments> {
  String userName = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getDp();
  }

  void getDp() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();

    setState(() {
      userName = (snap.data() as Map<String, dynamic>)['username'];
    });
  }

  Widget buildReasonText(String text) {
    return TextButton(
      onPressed: () async {
        setState(() {
          isLoading = true;
        });
        Provider.of<Post>(context, listen: false).reportForComments(
            userName,
            FirebaseAuth.instance.currentUser!.uid,
            widget.postId,
            widget.commentId,
            widget.uid,
            text);

        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Your Report was succesfully submitted')));
      },
      child: Text(text,
          style: GoogleFonts.roboto(
            color: Colors.grey,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        // physics: const NeverScrollableScrollPhysics(),
        child: Container(
      height: size.height * 0.9,
      width: size.width * 0.9,
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          color: Color.fromARGB(255, 31, 31, 31)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text("Report",
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 7.0),
            child: Text("Provide any reason for this Report?",
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                )),
          ),
          const SizedBox(
            height: 10,
          ),
          buildReasonText("Voilence or dangerous organisations"),
          buildReasonText('Suicide or self-injury'),
          buildReasonText('Scam or fraud'),
          buildReasonText('False information'),
          buildReasonText('bullying or harrassment'),
          buildReasonText('Intellectual property violation'),
          buildReasonText('Sale of illegal or regulated goods'),
          buildReasonText('Eating disorders'),
          buildReasonText('Sale of counterfeit goods or documents'),
          buildReasonText('Just don\'t want to see it'),
          buildReasonText('It\'s threatening a person or place'),
          buildReasonText('It\'s an inappropriate snap of someone else')
        ],
      ),
    ));
  }
}

class ReportReasonforMessages extends StatefulWidget {
  final uid;
  const ReportReasonforMessages({Key? key, required this.uid})
      : super(key: key);

  @override
  State<ReportReasonforMessages> createState() =>
      _ReportReasonforMessagesState();
}

class _ReportReasonforMessagesState extends State<ReportReasonforMessages> {
  String userName = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getDp();
  }

  void getDp() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();

    setState(() {
      userName = (snap.data() as Map<String, dynamic>)['username'];
    });
  }

  Widget buildReasonText(String text) {
    return TextButton(
      onPressed: () async {
        setState(() {
          isLoading = true;
        });
        Provider.of<Messages>(context, listen: false).reportForMessages(
            userName, widget.uid, FirebaseAuth.instance.currentUser!.uid, text);

        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Your Report was succesfully submitted')));
      },
      child: Text(text,
          style: GoogleFonts.roboto(
            color: Colors.grey,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        // physics: const NeverScrollableScrollPhysics(),
        child: Container(
      height: size.height * 0.9,
      width: size.width * 0.9,
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          color: Color.fromARGB(255, 31, 31, 31)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text("Report",
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 7.0),
            child: Text("Provide any reason for this Report?",
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                )),
          ),
          SizedBox(
            height: 10,
          ),
          buildReasonText("Voilence or dangerous organisations"),
          buildReasonText('Suicide or self-injury'),
          buildReasonText('Scam or fraud'),
          buildReasonText('False information'),
          buildReasonText('bullying or harrassment'),
          buildReasonText('Intellectual property violation'),
          buildReasonText('Sale of illegal or regulated goods'),
          buildReasonText('Eating disorders'),
          buildReasonText('Hate Speech'),
          buildReasonText('Hacked Somethimg else'),
          buildReasonText('Technical Issues'),
          buildReasonText("The problem isn't listed here"),
        ],
      ),
    ));
  }
}
