import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/model/notification_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class NotificationProvider with ChangeNotifier {
  final List<LikeNotificationModel> _likeNotification = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final currentUser = FirebaseAuth.instance.currentUser!.uid;

  List<LikeNotificationModel> get likeNotification => _likeNotification;
  List<Map<String, dynamic>> userNotification = [];

  Future<void> uploadLikeNotification(
      LikeNotificationModel likeNotificationModel,
      String uid,
      String postId) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('notification')
        .doc('likes$currentUser+$postId')
        .set(likeNotificationModel.toJson());
    await _firestore
        .collection('users')
        .doc(uid)
        .update({'notification': true});
    notifyListeners();
  }

  Future<void> deleteLikeNotification(String uid, String postId) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('notification')
        .doc('likes$currentUser+$postId')
        .delete();
    notifyListeners();
  }

  Future<void> uploadCommentNotification(
      CommentNotificationModel commentNotificationModel,
      String uid,
      String postId) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('notification')
        .doc('comments$currentUser+$postId')
        .set(commentNotificationModel.toJson());
    await _firestore
        .collection('users')
        .doc(uid)
        .update({'notification': true});
    notifyListeners();
  }

  Future<void> getUserNotification() async {
    // userStories.clear();
    // notifyListeners();
    var str = await _firestore
        .collection('userd')
        .doc(_auth.currentUser!.uid)
        .collection('notification')
        .get();
    if (str.docs.isNotEmpty) {
      userNotification = str.docs.map((e) => e.data()).toList();
      // for (var stories in str.docs) {
      //   userStories.add(stories.data());
      // }
    }
    notifyListeners();
  }
}
