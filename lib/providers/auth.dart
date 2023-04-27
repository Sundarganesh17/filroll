import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/model/user_model.dart';
import 'package:filroll_app/screens/authentication/phone_screen.dart';
import 'package:filroll_app/screens/feed/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth with ChangeNotifier {
  final List<String> _username = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  // ignore: prefer_typing_uninitialized_variables
  var user;

  List<String> get username => _username;

  Future<void> signUp(String? name, String? userName, String? email,
      String? password, BuildContext context) async {
    try {
      UserCredential userCredential;
      userCredential = await _auth.createUserWithEmailAndPassword(
          email: email!, password: password!);
      //await _userCredential.user!.sendEmailVerification();

      UserModel userModel = UserModel(
          name: name!,
          userName: userName!,
          uid: FirebaseAuth.instance.currentUser!.uid,
          website: '',
          bio: '',
          email: email,
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
          isOnline: false,
          lastModified: DateTime.now());
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userModel.toJson());
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .update({
        'followers': [],
        'following': [],
        'blockedUsers': [],
      });
      FirebaseAuth.instance.authStateChanges().listen((event) {
        if (event != null) {
          user = event;
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => PhoneScreen()));
        }
      });
    } on FirebaseAuthException catch (error) {
      var msg = 'An error occured, please check your credentials! ';
      if (error.message != null) {
        msg = error.message!;
        // ignore: avoid_print
        print(msg);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      notifyListeners();
    }
  }

  Future<void> submitPhoneNumber(String? countryCode, String? number) async {
    await _firestore
        .collection('users')
        .doc(user!.uid)
        .update({'countrycode': countryCode, 'phonenumber': number});
  }

  Future<void> login(
      String? email, String? password, BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      FirebaseAuth.instance.authStateChanges().listen((event) {
        if (event != null) {
          user = event;
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
      });
    } on PlatformException catch (error) {
      var msg = 'An error occured, please check your credentials! ';
      if (error.message != null) {
        msg = error.message!;
        // ignore: avoid_print
        print(msg);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } on FirebaseAuthException catch (error) {
      var msg = 'An error occured, please check your credentials! ';
      if (error.message != null) {
        msg = error.message!;
        // ignore: avoid_print
        print(msg);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.red,
        ),
      );
      notifyListeners();
    }
  }

  Future<void> userNameExists() async {
    var str = await _firestore.collection('users').get();
    if (str.docs.isNotEmpty) {
      for (var username in str.docs) {
        var result = username.data();
        _username.add(
          result['username'],
        );
      }
    }
  }
}
