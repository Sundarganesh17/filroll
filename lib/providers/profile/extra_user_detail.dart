import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:filroll_app/model/user_model.dart';

class ExtraUserDetail with ChangeNotifier {
  UserModel? _user;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel get getUser => _user!;

  Future<void> submitExtraUserDetails(UserModel userModel) async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update(userModel.toJson());
    notifyListeners();
  }

  Future<void> submitGender(String? gender) async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update({'gender': gender});
    notifyListeners();
  }

  Future<void> fetchGender(String gender) async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    gender = (snap.data() as Map<String, dynamic>)['gender'];
    notifyListeners();
  }

  Future<UserModel> refreshUser() async {
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
    UserModel user = UserModel.fromSnap(snap);
    notifyListeners();
    return user;
  }
}
