import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/model/user_model.dart';
import 'package:filroll_app/screens/authentication/google_signup_screen.dart';
import 'package:filroll_app/screens/feed/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignUp extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  GoogleSignInAccount? _users;

  GoogleSignInAccount get user => _users!;

  Future googleSignUp(BuildContext context) async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _users = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    await FirebaseAuth.instance.signInWithCredential(credential);

    var user = FirebaseAuth.instance.currentUser!;
    UserModel userModel = UserModel(
        name: user.displayName!,
        userName: user.displayName!.toLowerCase(),
        uid: user.uid,
        website: '',
        bio: '',
        email: user.email!,
        countryCode: '',
        phoneNumber: '',
        gender: '',
        birthday: '',
        dpUrl:
            "https://as2.ftcdn.net/v2/jpg/03/31/69/91/1000_F_331699188_lRpvqxO5QRtwOM05gR50ImaaJgBx68vi.jpg",
        cpUrl:
            'https://amdmediccentar.rs/wp-content/plugins/uix-page-builder/includes/uixpbform/images/default-cover-4.jpg',
        isPrivate: false,
        notification: false,
        lastModified: DateTime.now(),
        isOnline: false);
    await _firestore.collection('users').doc(user.uid).set(userModel.toJson());
    await _firestore.collection('users').doc(user.uid).update({
      'followers': [],
      'following': [],
      'blockedUsers': [],
    });
    FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event != null) {
        user = event;
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    });
  }

  Future googleLogin(BuildContext context) async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _users = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    await FirebaseAuth.instance.signInWithCredential(credential);
    var user = FirebaseAuth.instance.currentUser!;
    FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event != null) {
        user = event;
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    });
  }
}
