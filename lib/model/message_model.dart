import 'package:cloud_firestore/cloud_firestore.dart';

enum type { text, image, audio }

class MessageModel {
  final String senderUid;
  final String receiverUid;
  final String msgId;
  final String body;
  final DateTime dateTime;
  final String type;
  final String reply;
  final bool isSeen;
  final delForMe;

  MessageModel(this.senderUid, this.receiverUid, this.msgId, this.body,
      this.dateTime, this.reply, this.isSeen, this.delForMe, this.type);

  Map<String, dynamic> toJson() => {
        'senderUid': senderUid,
        'receiverUid': receiverUid,
        'msgId': msgId,
        'body': body,
        'dateTime': dateTime,
        'type': type,
        'reply': reply,
        'isSeen': isSeen,
        'delForMe': delForMe,
      };

  static MessageModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return MessageModel(
        snapshot['senderUid'],
        snapshot['receiverUid'],
        snapshot['msgId'],
        snapshot['body'],
        snapshot['dateTime'],
        snapshot['type'],
        snapshot['reply'],
        snapshot['isSeen'],
        snapshot['delForMe']);
  }
}
