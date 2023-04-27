import 'package:cloud_firestore/cloud_firestore.dart';

enum MediaType {
  image,
  video,
}

class StoryModel {
  final String? storyUrl;
  final DateTime? dateTime;
  final String? uid;
  final String? userName;
  final String? dpUrl;
  final bool? isVideo;
  final String? storyId;

  StoryModel(
      {this.storyUrl,
      this.dateTime,
      this.uid,
      this.userName,
      this.dpUrl,
      this.isVideo,
      this.storyId});

  Map<String, dynamic> toJson() => {
        'storyUrl': storyUrl,
        'dateTime': dateTime,
        'uid': uid,
        'username': userName,
        'dpUrl': dpUrl,
        'isVideo': isVideo,
        'storyId': storyId,
      };

  static StoryModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return StoryModel(
        storyUrl: snapshot['storyUrl'],
        dateTime: snapshot['dateTime'],
        uid: snapshot['uid'],
        userName: snapshot['userName'],
        dpUrl: snapshot['dpUrl'],
        isVideo: snapshot['isVideo'],
        storyId: snapshot['storyId']);
  }
}

class UserM {
  UserM(this.stories, this.userName, this.imageUrl, this.uid, this.views,
      this.dateTime);

  final List stories;
  final String userName;
  final String imageUrl;
  final String uid;
  final List views;
  final DateTime dateTime;

  Map<String, dynamic> toJson() => {
        'stories': stories,
        'username': userName,
        'imageUrl': imageUrl,
        'uid': uid,
        'views': views,
        'dateTime': dateTime,
        //'stories': stories.map((e) => e.toJson()).toList(),
      };

  static UserM fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserM(
        snapshot['stories'],
        snapshot['userName'],
        snapshot['imageUrl'],
        snapshot['uid'],
        snapshot['views'],
        snapshot['dateTime']);
  }
}
