import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String userName;
  final String uid;
  final String website;
  final String bio;
  final String email;
  final String countryCode;
  final String phoneNumber;
  final String gender;
  final String birthday;
  final String dpUrl;
  final String cpUrl;
  final bool isPrivate;
  final bool notification;
  final bool isOnline;
  final DateTime lastModified;

  const UserModel(
      {required this.name,
      required this.userName,
      required this.uid,
      required this.website,
      required this.bio,
      required this.email,
      required this.countryCode,
      required this.phoneNumber,
      required this.gender,
      required this.birthday,
      required this.dpUrl,
      required this.cpUrl,
      required this.isPrivate,
      required this.notification,
      required this.isOnline,
      required this.lastModified});

  Map<String, dynamic> toJson() => {
        "name": name,
        "username": userName,
        "uid": uid,
        "website": website,
        "bio": bio,
        "email": email,
        'countrycode': countryCode,
        "phonenumber": phoneNumber,
        "gender": gender,
        "DOB": birthday,
        "DPUrl": dpUrl,
        "CPUrl": cpUrl,
        "isPrivate": isPrivate,
        "notification": notification,
        "isOnline": isOnline,
        "lastModified": lastModified,
      };

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      name: snapshot['name'],
      userName: snapshot['username'],
      uid: snapshot['uid'],
      website: snapshot['website'],
      bio: snapshot['bio'],
      email: snapshot['email'],
      countryCode: snapshot['countrycode'] ?? '',
      phoneNumber: snapshot['phonenumber'],
      gender: snapshot['gender'],
      birthday: snapshot['DOB'],
      dpUrl: snapshot['DPUrl'],
      cpUrl: snapshot['CPUrl'],
      isPrivate: snapshot['isPrivate'],
      notification: snapshot['notification'],
      isOnline: snapshot['isOnline'],
      lastModified: snapshot['lastModified'],
    );
  }
}
