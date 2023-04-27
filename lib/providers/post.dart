import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/model/post_model.dart';
import 'package:filroll_app/screens/feed/home_screen.dart';
import 'package:filroll_app/screens/feed/trial.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Post with ChangeNotifier {
  final List<PostModel> _posts = [];
  final List<PostModel> _postImages = [];
  final List<PostModel> _postVideos = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userUid = FirebaseAuth.instance.currentUser!.uid;

  List<PostModel> get posts => _posts;
  List<PostModel> get postImages => _postImages;
  List<PostModel> get postVideos => _postVideos;

  Future<void> uploadPost(PostModel postModel, String id) async {
    await _firestore.collection('posts').doc(id).set(postModel.toJson());
    await _firestore
        .collection('users')
        .doc(userUid)
        .collection('uploaded posts')
        .doc(id)
        .set(postModel.toJson());
    notifyListeners();
  }

  Future<void> fetchPosts() async {
    posts.clear();
    var p = await _firestore
        .collection('posts')
        .orderBy('dateTime', descending: true)
        .get();
    if (p.docs.isNotEmpty) {
      for (var posts in p.docs) {
        var result = posts.data();
        _posts.add(PostModel(
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
    print(_posts);
    notifyListeners();
  }

  Future<void> fetchSearchImages() async {
    postImages.clear();
    var p = await _firestore
        .collection('posts')
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
    print(_postImages);
    notifyListeners();
  }

  Future<void> fetchSearchVideos() async {
    postVideos.clear();
    var p = await _firestore
        .collection('posts')
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
    print(_postVideos);
    notifyListeners();
  }

  Future<void> likePost(
      String postId, String postOwnerUid, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
        await _firestore
            .collection('users')
            .doc(postOwnerUid)
            .collection('uploaded posts')
            .doc(postId)
            .update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
        await _firestore
            .collection('users')
            .doc(postOwnerUid)
            .collection('uploaded posts')
            .doc(postId)
            .update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<void> doubleTapLikePost(
      String postId, String postOwnerUid, String uid, List likes) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
      await _firestore
          .collection('users')
          .doc(postOwnerUid)
          .collection('uploaded posts')
          .doc(postId)
          .update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<void> views(
      String postId, String postOwnerUid, String uid, List views) async {
    try {
      if (!views.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'views': FieldValue.arrayUnion([uid]),
        });
        await _firestore
            .collection('users')
            .doc(postOwnerUid)
            .collection('uploaded posts')
            .doc(postId)
            .update({
          'views': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<void> postComment(String postId, String text, String uid,
      String userName, String dpUrl) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'dpUrl': dpUrl,
          'username': userName,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
          'likes': [],
        });
      } else {
        // ignore: avoid_print
        print('Comment is empty');
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<void> likeComment(
      String postId, String uid, List likes, String commentId) async {
    try {
      if (likes.contains(uid)) {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<void> postReplyComment(String postId, String text, String uid,
      String commentId, String userName, String dpUrl) async {
    try {
      if (text.isNotEmpty) {
        String replyCommentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .collection('reply comments')
            .doc(replyCommentId)
            .set({
          'dpUrl': dpUrl,
          'username': userName,
          'uid': uid,
          'text': text,
          'commentId': replyCommentId,
          'datePublished': DateTime.now(),
          'likes': [],
        });
      } else {
        // ignore: avoid_print
        print('Comment is empty');
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<void> likeReplyComment(String postId, String uid, List likes,
      String commentId, String replyCommentId) async {
    try {
      if (likes.contains(uid)) {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .collection('reply comments')
            .doc(replyCommentId)
            .update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .collection('reply comments')
            .doc(replyCommentId)
            .update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<void> reportForPosts(String userName, String uid, String postId,
      String postOwnerUid, String reason) async {
    await FirebaseFirestore.instance.collection('Reports for posts').doc().set({
      'username': userName,
      'uid': uid,
      'postId': postId,
      'postOwnerUid': postOwnerUid,
      'reason': reason,
      'dateTime': DateTime.now()
    });
  }

  Future<void> reportForComments(String userName, String uid, String postId,
      String commentId, String postOwnerUid, String reason) async {
    await FirebaseFirestore.instance
        .collection('Reports for comments')
        .doc()
        .set({
      'username': userName,
      'uid': uid,
      'postId': postId,
      'commentId': commentId,
      'postOwnerUid': postOwnerUid,
      'reason': reason,
      'dateTime': DateTime.now()
    });
  }

  Future<void> deletePost(String postId, BuildContext context) async {
    await _firestore.collection('posts').doc(postId).delete();
    await _firestore
        .collection('users')
        .doc(userUid)
        .collection('uploaded posts')
        .doc(postId)
        .delete();
    // ignore: use_build_context_synchronously
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HomeScreen()));
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Your post has been successfully deleted')));
  }
}
