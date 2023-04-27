import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/screens/feed/home_screen.dart';
import 'package:filroll_app/screens/profile/others_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      timer?.cancel();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (error) {
      var msg = 'We are not able to send Link to Your Email';
      if (error.message != null) {
        msg = error.message!;
        print(msg);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              height: 105,
              width: 105,
              child: Image.asset("images/homepage/Verify Email.jpeg"),
            ),
            Text(
              'Verify Your Email',
              style: GoogleFonts.mPlusRounded1c(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: Text(
                // 'An email has been sent to ${user.email} please verify and Start Enjoying FilRoll',
                'Check your Email & Click the link to Verify your Email and Start Enjoying FilRoll',
                style: GoogleFonts.mPlusRounded1c(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Center(
                child: ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(100, 5, 100, 5),
                    child: Text(
                      "Resend Email",
                      style: GoogleFonts.mPlusRounded1c(
                        color: Colors.white,
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF2900FF),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.44))),
                  onPressed: () {},
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.mPlusRounded1c(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
          ],
        ),
      );
}

/* 

final auth = FirebaseAuth.instance;
  User? user;
  Timer? timer;

  @override
  void initState() {
    try {
      user = auth.currentUser;
      user!.sendEmailVerification();

      timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified());
    } on FirebaseAuthException catch (error) {
      var msg = 'We are not able to send Link to Your Email';
      if (error.message != null) {
        msg = error.message!;
        print(msg);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
    super.initState();
  }

  Future<void> checkEmailVerified() async {
    try {
      user = auth.currentUser;
      await user!.reload();
      if (user!.emailVerified) {
        timer!.cancel();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => homepage()));
      }
    } on FirebaseAuthException catch (error) {
      var msg = 'We are not able to send Link to Your Email';
      if (error.message != null) {
        msg = error.message!;
        //print(msg);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } catch (err) {
      print(err);
    }
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  */

class VerifyEmailPage1 extends StatefulWidget {
  String oldEmail;
  String newEmail;
  VerifyEmailPage1({super.key, required this.oldEmail, required this.newEmail});

  @override
  State<VerifyEmailPage1> createState() => _VerifyEmailPage1State();
}

class _VerifyEmailPage1State extends State<VerifyEmailPage1> {
  bool isEmailVerified = false;
  bool isCancelLoading = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      timer =
          Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified1());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      timer?.cancel();
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'email': 'Hey'});
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) =>
              OthersProfile(uid: FirebaseAuth.instance.currentUser!.uid)));
    }
  }

  Future checkEmailVerified1() async {
    await FirebaseAuth.instance.currentUser!.reload();
    print('1');
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      print('2');
      timer?.cancel();
      print('3');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
        ..update({'email': widget.newEmail});
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) =>
              OthersProfile(uid: FirebaseAuth.instance.currentUser!.uid)));
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.updateEmail(widget.newEmail);
      print(user.email);
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (error) {
      var msg = 'We are not able to send Link to Your Email';
      if (error.message != null) {
        msg = error.message!;
        print(msg);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      await FirebaseAuth.instance.currentUser!.updateEmail(widget.oldEmail);
    }
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          await FirebaseAuth.instance.currentUser!.updateEmail(widget.oldEmail);
          Navigator.of(context).pop();
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                height: 105,
                width: 105,
                child: Image.asset("images/homepage/Verify Email.jpeg"),
              ),
              Text(
                'Verify Your Email',
                style: GoogleFonts.mPlusRounded1c(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                child: Text(
                  'An email has been sent to ${widget.newEmail} please verify and Start Enjoying FilRoll',
                  //'Check your Email & Click the link to Verify your Email and Start Enjoying FilRoll',
                  style: GoogleFonts.mPlusRounded1c(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Center(
                  child: ElevatedButton(
                    // ignore: sort_child_properties_last
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(100, 5, 100, 5),
                      child: Text(
                        "Resend Email",
                        style: GoogleFonts.mPlusRounded1c(
                          color: Colors.white,
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF2900FF),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.44))),
                    onPressed: () => sendVerificationEmail,
                  ),
                ),
              ),
              isCancelLoading
                  ? Center(child: CircularProgressIndicator())
                  : TextButton(
                      onPressed: () async {
                        setState(() {
                          isCancelLoading = true;
                        });
                        await FirebaseAuth.instance.currentUser!
                            .updateEmail(widget.oldEmail);
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({'email': widget.oldEmail});
                        setState(() {
                          isCancelLoading = false;
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.mPlusRounded1c(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
            ],
          ),
        ),
      );
}
