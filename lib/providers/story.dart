import 'dart:convert';
import 'dart:io';

import 'package:aws_s3_api/s3-2006-03-01.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/model/story_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_aws_s3_client/flutter_aws_s3_client.dart';
import 'package:http/http.dart';

class Story with ChangeNotifier {
  final List<StoryModel> _stories = [];
  final List<StoryModel> _userStories = [];
  final List<UserM> _uses = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = true;

  List<StoryModel> get stories => _stories;
  List<StoryModel> get userStories => _userStories;
  List<UserM> get uses => _uses;
  List<String> storyOfUser = [];

  Future<void> uploadStory(String storyUrl, String userName, String dpUrl,
      String key, bool isVideo) async {
    var snap = await FirebaseFirestore.instance
        .collection('storyOfUsers')
        .doc('123')
        .get();
    var userList = snap.data()!['uid'];
    var uid = _auth.currentUser!.uid;
    if (userList.contains(uid)) {
      await _firestore.collection('story').doc(uid).update({
        'dateTime': DateTime.now(),
        'stories': FieldValue.arrayUnion([
          {'imageUrl': storyUrl, 'dateTime': DateTime.now(), 'key': key},
        ])
      });
    } else {
      UserM userM = UserM(
        [
          {'imageUrl': storyUrl, 'dateTime': DateTime.now(), 'key': key},
        ],
        userName,
        dpUrl,
        uid,
        [],
        DateTime.now(),
      );
      await _firestore.collection('story').doc(uid).set(userM.toJson());
      await _firestore.collection('storyOfUsers').doc('123').update({
        'uid': FieldValue.arrayUnion([uid])
      });
    }
    notifyListeners();
  }

  Future<void> getStory() async {
    stories.clear();
    var str = await _firestore
        .collection('stories')
        .orderBy('dateTime', descending: true)
        .get();
    if (str.docs.isNotEmpty) {
      for (var stories in str.docs) {
        var result = stories.data();
        _stories.add(StoryModel(
          // storyUrl: result['storyUrl'] ?? '',
          // dateTime: result['dateTime'],
          uid: result['uid'],
          // userName: result['username'],
          // dpUrl: result['dpUrl'],
        ));
      }
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> getUserStory(String userId) async {
    _userStories.clear();
    // notifyListeners();
    var str = await _firestore
        .collection('stories')
        .doc(userId)
        .collection('userStories')
        .get();
    if (str.docs.isNotEmpty) {
      // userStories = str.docs.map((e) => e.data()).toList();
      for (var userStories in str.docs) {
        var result = userStories.data();
        _userStories.add(StoryModel(
            uid: result['uid'],
            userName: result['username'],
            dpUrl: result['dpUrl'],
            storyUrl: result['storyUrl'],
            storyId: result['storyId'],
            dateTime: result['dateTime'].toDate(),
            isVideo: result['isVideo']));
      }
    }
    notifyListeners();
  }

  Future<void> getDumStory() async {
    _uses.clear();
    var str = await _firestore
        .collection('story')
        .orderBy('dateTime', descending: true)
        .get();
    if (str.docs.isNotEmpty) {
      for (var uses in str.docs) {
        var result = uses.data();
        _uses.add(UserM(
          result['stories'] ?? [] as List,
          result['username'],
          result['imageUrl'],
          result['uid'] ?? '',
          result['views'] ?? [],
          result['dateTime'].toDate(),
        ));
      }
    }
    notifyListeners();
  }

  Future<void> viewedStory(
    String ownerUid,
    String userUid,
  ) async {
    try {
      await _firestore.collection('story').doc(ownerUid).update({
        'views': FieldValue.arrayUnion([userUid]),
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getPreSignedUrl() async {
    try {
      final response = await S3(
              region: 'ap-south-1',
              credentials: AwsClientCredentials(
                  accessKey: "AKIARQNY6EATHG5S7CGF",
                  secretKey: "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"))
          .getObject(
              bucket: "filroll-storage-114584815-staging",
              key: "public/dp-iEpePVrZ48MLKyICEjo5Egvy9CT2.jpg");

      print(response.body!.elementSizeInBytes);

      // const region = "ap-south-1";
      // const bucketId = "filroll-storage-114584815-staging";
      // final AwsS3Client s3client = AwsS3Client(
      //     region: region,
      //     host: "s3.$region.amazonaws.com",
      //     bucketId: bucketId,
      //     accessKey: "AKIARQNY6EATHG5S7CGF",
      //     secretKey: "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");
      // final signedParams = s3client.buildSignedGetParams(
      //     key: "public/dp-iEpePVrZ48MLKyICEjo5Egvy9CT2.jpg");
      // print(signedParams.headers);

      // final request = await HttpClient().getUrl(signedParams.uri);

      // var file;
      // var eTag = [];
      // for (final header in (signedParams.headers ?? const {}).entries) {
      //   request.headers.add(header.key, header.value);
      // }
      // if (eTag != null) {
      //   request.headers.add(HttpHeaders.ifNoneMatchHeader, eTag);
      // }
      // final response = await request.close();
      // if (response.statusCode != HttpStatus.ok) {
      //   //handle error
      // } else {
      //   return response.pipe(file.openWrite());
      // }

      //     final response = await s3client.buildSignedGetParams()
      //         // .getObject("public/dp-iEpePVrZ48MLKyICEjo5Egvy9CT2.jpg");
      // var s = json.decode(request.);
      //print('res :${request.headers}');
    } catch (e) {
      print(e.toString());
    }
  }
}

// const region = "eu-central-1";
//   const bucketId = "yourBucketId";
//   final AwsS3Client s3client = AwsS3Client(
//       region: region,
//       host: "s3.$region.amazonaws.com",
//       bucketId: bucketId,
//       accessKey: "<your access key>",
//       secretKey: "<your secret key>");
//   final response = await s3client.getObject("your/object/key");
