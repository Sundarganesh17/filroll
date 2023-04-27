import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/model/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Messages with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userUid = FirebaseAuth.instance.currentUser!.uid;
  List<dynamic> _forList = [];

  List<dynamic> get forList => _forList;

  Future<void> uploadMessage(String text, String uid, String userName,
      String currentUserName, String type, String reply) async {
    var msgId = const Uuid().v1();
    var messageModel = MessageModel(
        userUid, uid, msgId, text, DateTime.now(), reply, false, false, type);
    await _firestore
        .collection('chat')
        .doc(userUid)
        .collection('personal chats')
        .doc(uid)
        .collection('messages')
        .doc(msgId)
        .set(messageModel.toJson());
    await _firestore
        .collection('chat')
        .doc(userUid)
        .collection('personal chats')
        .doc(uid)
        .set({
      'dateTime': DateTime.now(),
      'uid': uid,
      'isReq': true,
      'isMute': false,
      'userName': userName,
      'lastMsg': type == 'Audio'
          ? '🎤 Audio'
          : type == 'Image'
              ? '🖼️ Photo'
              : text
    });
    await _firestore
        .collection('chat')
        .doc(uid)
        .collection('personal chats')
        .doc(userUid)
        .collection('messages')
        .doc(msgId)
        .set(messageModel.toJson());
    await _firestore
        .collection('chat')
        .doc(uid)
        .collection('personal chats')
        .doc(userUid)
        .set({
      'dateTime': DateTime.now(),
      'uid': userUid,
      'isReq': true,
      'isMute': false,
      'userName': currentUserName,
      'lastMsg': type == 'Audio'
          ? '🎤 Audio'
          : type == 'Image'
              ? '🖼️ Photo'
              : text
    });
    notifyListeners();
  }

  Future<void> deleteforEveryone(
      String receiverUid, String senderUid, String msgId) async {
    await _firestore
        .collection('chat')
        .doc(receiverUid)
        .collection('personal chats')
        .doc(senderUid)
        .collection('messages')
        .doc(msgId)
        .delete();
    await _firestore
        .collection('chat')
        .doc(senderUid)
        .collection('personal chats')
        .doc(receiverUid)
        .collection('messages')
        .doc(msgId)
        .delete();
  }

  Future<void> deleteforMe(
      String receiverUid, String senderUid, String msgId) async {
    await _firestore
        .collection('chat')
        .doc(userUid)
        .collection('personal chats')
        .doc(receiverUid)
        .collection('messages')
        .doc(msgId)
        .delete();
  }

  Future<void> deleteMessage(
      String receiverUid, String senderUid, String msgId) async {
    if (receiverUid == userUid) {
      await _firestore
          .collection('chat')
          .doc(userUid)
          .collection('personal chats')
          .doc(senderUid)
          .collection('messages')
          .doc(msgId)
          .delete();
    } else {
      await _firestore
          .collection('chat')
          .doc(userUid)
          .collection('personal chats')
          .doc(receiverUid)
          .collection('messages')
          .doc(msgId)
          .delete();
    }
  }

  Future<void> IsSeen(
      String receiverUid, String senderUid, String msgId) async {
    // await _firestore
    //     .collection('chat')
    //     .doc(receiverUid)
    //     .collection('personal chats')
    //     .doc(senderUid)
    //     .collection('messages')
    //     .doc(msgId)
    //     .update({'isSeen': true});
    await _firestore
        .collection('chat')
        .doc(senderUid)
        .collection('personal chats')
        .doc(receiverUid)
        .collection('messages')
        .doc(msgId)
        .update({'isSeen': true});
  }

  Future<void> sendRequest(String uid, String userName) async {
    var msgId = const Uuid().v1();
    var messageModel = MessageModel(
        userUid, uid, msgId, 'Hi', DateTime.now(), '', false, false, 'text');
    await _firestore
        .collection('chat')
        .doc(userUid)
        .collection('personal chats')
        .doc(uid)
        .collection('messages')
        .doc(msgId)
        .set(messageModel.toJson());
    await _firestore
        .collection('chat')
        .doc(userUid)
        .collection('personal chats')
        .doc(uid)
        .set({
      'dateTime': DateTime.now(),
      'uid': uid,
      'isMute': false,
      'userName': userName,
      'isReq': false,
      'lastMsg': 'Hi',
    });
    await FirebaseFirestore.instance
        .collection('Requests')
        .doc(uid)
        .collection('requests')
        .doc(userUid)
        .set({
      'uid': userUid,
      'hasSend': true,
      'text': 'Hi',
      'dateTime': DateTime.now()
    });
  }

  Future<void> acceptRequest(String uid, String userName) async {
    var msgId = const Uuid().v1();
    var messageModel = MessageModel(
        userUid, uid, msgId, 'Hi', DateTime.now(), '', true, false, 'text');
    await _firestore
        .collection('chat')
        .doc(userUid)
        .collection('personal chats')
        .doc(uid)
        .collection('messages')
        .doc(msgId)
        .set(messageModel.toJson());
    await _firestore
        .collection('chat')
        .doc(userUid)
        .collection('personal chats')
        .doc(uid)
        .set({
      'dateTime': DateTime.now(),
      'uid': uid,
      'isMute': false,
      'isReq': true,
      'lastMsg': 'Hi',
    });
    await _firestore
        .collection('chat')
        .doc(uid)
        .collection('personal chats')
        .doc(userUid)
        .update({
      'isReq': true,
    });
    await FirebaseFirestore.instance
        .collection('Requests')
        .doc(userUid)
        .collection('requests')
        .doc(uid)
        .delete();
  }

  Future<void> deleteList() async {
    _forList.clear();
  }

  Future<void> forwardList(uid) async {
    // _forList = list;
    if (_forList.contains(uid)) {
      _forList.remove(uid);
    } else {
      _forList.add(uid);
    }
    print(_forList);
  }

  Future<void> reportForMessages(
      String userName, String uid, String currentUserUid, String reason) async {
    await FirebaseFirestore.instance
        .collection('Reports for Messages')
        .doc()
        .set({
      'username': userName,
      'reportedUserUid': uid,
      'currentUserUid': currentUserUid,
      'reason': reason,
      'dateTime': DateTime.now(),
    });
  }
}
