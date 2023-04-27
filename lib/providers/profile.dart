import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/model/post_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  final List<PostModel> _postImages = [];
  final List<PostModel> _postVideos = [];
  final List<PostModel> _postFav = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userUid = FirebaseAuth.instance.currentUser!.uid;

  List<PostModel> get postImages => _postImages;
  List<PostModel> get postVideos => _postVideos;
  List<PostModel> get postFav => _postFav;

  Future<void> fetchPostImages(String uid) async {
    postImages.clear();
    var p = await _firestore
        .collection('users')
        .doc(uid)
        .collection('uploaded posts')
        .where('isVideo', isEqualTo: false)
        .get();
    if (p.docs.isNotEmpty) {
      for (var posts in p.docs) {
        var result = posts.data();
        _postImages.add(PostModel(
            postId: result['postId'],
            postUrl: result['postUrl'],
            caption: result['caption'],
            location: result['location'],
            uid: result['uid'],
            userName: result['username'],
            dpUrl: result['dpUrl'],
            dateTime: result['dateTime'].toDate(),
            isVideo: result['isVideo'],
            link: result['link'],
            likes: result['likes'],
            thumbnail: result['thumbnail'],
            isPrivate: result['isPrivate'],
            views: result['views']));
      }
    }
    notifyListeners();
  }

  Future<void> fetchPostVideos(String uid) async {
    postVideos.clear();
    var p = await _firestore
        .collection('users')
        .doc(uid)
        .collection('uploaded posts')
        .where('isVideo', isEqualTo: true)
        .get();
    if (p.docs.isNotEmpty) {
      for (var posts in p.docs) {
        var result = posts.data();
        _postVideos.add(PostModel(
            postId: result['postId'],
            postUrl: result['postUrl'],
            caption: result['caption'],
            location: result['location'],
            uid: result['uid'],
            userName: result['username'],
            dpUrl: result['dpUrl'],
            dateTime: result['dateTime'].toDate(),
            isVideo: result['isVideo'],
            link: result['link'],
            likes: result['likes'],
            thumbnail: result['thumbnail'],
            isPrivate: result['isPrivate'],
            views: result['views']));
      }
    }
    notifyListeners();
  }

  Future<void> fetchFavorites(String uid) async {
    postFav.clear();
    var p = await _firestore
        .collection('users')
        .doc(uid)
        .collection('Favorite posts')
        .get();
    if (p.docs.isNotEmpty) {
      for (var posts in p.docs) {
        var result = posts.data();
        _postFav.add(PostModel(
            postId: result['postId'],
            postUrl: result['postUrl'],
            caption: result['caption'],
            location: result['location'],
            uid: result['uid'],
            userName: result['username'],
            dpUrl: result['dpUrl'],
            dateTime: result['dateTime'].toDate(),
            isVideo: result['isVideo'],
            link: result['link'],
            likes: result['likes'],
            thumbnail: result['thumbnail'],
            isPrivate: result['isPrivate'],
            views: result['views']));
      }
    }
    notifyListeners();
  }
}
