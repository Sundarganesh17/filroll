import 'package:cloud_firestore/cloud_firestore.dart';

class LikeNotificationModel {
  String? ownerUid;
  String? currentUserUid;
  String? currentUserDpUrl;
  String? currentUsername;
  String? postId;
  String? postUrl;
  String? body;
  String? text;
  DateTime? dateTime;

  LikeNotificationModel(
      this.ownerUid,
      this.currentUserUid,
      this.currentUserDpUrl,
      this.currentUsername,
      this.postId,
      this.postUrl,
      this.body,
      this.text,
      this.dateTime);

  Map<String, dynamic> toJson() => {
        'ownerUid': ownerUid,
        'currentUserUid': currentUserUid,
        'currentUserDpUrl': currentUserDpUrl,
        'currentUsername': currentUsername,
        'postId': postId,
        'postUrl': postUrl,
        'body': body,
        'text': text,
        'dateTime': dateTime,
      };

  static LikeNotificationModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return LikeNotificationModel(
        snapshot['ownerUid'],
        snapshot['currentUserUid'],
        snapshot['currentUserDpUrl'],
        snapshot['curremtUsername'],
        snapshot['postId'],
        snapshot['postUrl'],
        snapshot['body'],
        snapshot['text'],
        snapshot['dateTime']);
  }
}

class CommentNotificationModel {
  String? ownerUid;
  String? currentUserUid;
  String? currentUserDpUrl;
  String? currentUsername;
  String? postId;
  String? postUrl;
  String? body;
  String? text;
  DateTime? dateTime;

  CommentNotificationModel(
      this.ownerUid,
      this.currentUserUid,
      this.currentUserDpUrl,
      this.currentUsername,
      this.postId,
      this.postUrl,
      this.body,
      this.text,
      this.dateTime);

  Map<String, dynamic> toJson() => {
        'ownerUid': ownerUid,
        'currentUserUid': currentUserUid,
        'currentUserDpUrl': currentUserDpUrl,
        'currentUsername': currentUsername,
        'postId': postId,
        'postUrl': postUrl,
        'body': body,
        'text': text,
        'dateTime': dateTime,
      };

  static CommentNotificationModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return CommentNotificationModel(
        snapshot['ownerUid'],
        snapshot['currentUserUid'],
        snapshot['currentUserDpUrl'],
        snapshot['curremtUsername'],
        snapshot['postId'],
        snapshot['postUrl'],
        snapshot['body'],
        snapshot['text'],
        snapshot['dateTime']);
  }
}




    // "servers": [
    //    {
    //       "url": "https://abcdefghi.execute-api.us-east-1.amazonaws.com/{basePath}",
    //       "variables": {
    //          "basePath": {
    //            "default": "/v1"
    //          }
    //       }
    //    }
    // ],
