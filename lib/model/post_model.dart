import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String postUrl;
  final String caption;
  final String location;
  final String uid;
  final String userName;
  final String dpUrl;
  final DateTime dateTime;
  final bool isVideo;
  final String link;
  final String thumbnail;
  final bool isPrivate;
  // ignore: prefer_typing_uninitialized_variables
  final likes;
  final views;

  PostModel(
      {required this.postId,
      required this.postUrl,
      required this.caption,
      required this.location,
      required this.uid,
      required this.userName,
      required this.dpUrl,
      required this.dateTime,
      required this.isVideo,
      required this.link,
      required this.likes,
      required this.thumbnail,
      required this.isPrivate,
      required this.views});

  Map<String, dynamic> toJson() => {
        'postId': postId,
        'postUrl': postUrl,
        'caption': caption,
        'location': location,
        'uid': uid,
        'username': userName,
        'dpUrl': dpUrl,
        'dateTime': dateTime,
        'isVideo': isVideo,
        'link': link,
        'likes': likes,
        'thumbnail': thumbnail,
        'isPrivate': isPrivate,
        'views': views,
      };

  static PostModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return PostModel(
        postId: snapshot['postId'],
        postUrl: snapshot['postUrl'],
        caption: snapshot['caption'],
        location: snapshot['location'],
        uid: snapshot['uid'],
        userName: snapshot['userName'],
        dpUrl: snapshot['dpUrl'],
        dateTime: snapshot['dateTime'],
        isVideo: snapshot['isVideo'],
        link: snapshot['link'],
        likes: snapshot['likes'],
        thumbnail: snapshot['thumbnail'],
        isPrivate: snapshot['isPrivate'],
        views: snapshot['views']);
  }
}
