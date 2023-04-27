import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/providers/auth.dart';
import 'package:filroll_app/screens/profile/others_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class SearchUser extends StatefulWidget {
  final snap;
  const SearchUser({super.key, required this.snap});

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  String dpUrl = '';
  String dpUrl1 = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();
  }

  getUsers() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.snap['uid'])
        .get();
    var dp = await getUrl('dp-${widget.snap['uid']}.jpg');
    setState(() {
      dpUrl = dp;
      dpUrl1 = (snap.data() as Map<String, dynamic>)['DPUrl'];
    });
  }

  Future<String> getUrl(String key) async {
    try {
      final result = await Amplify.Storage.getUrl(key: key);
      return result.url;
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) => OthersProfile(
                  uid: widget.snap['uid'],
                ))));
      },
      child: ListTile(
        leading: CircleAvatar(
            backgroundImage: dpUrl1.contains('https')
                ? NetworkImage(
                    "https://as2.ftcdn.net/v2/jpg/03/31/69/91/1000_F_331699188_lRpvqxO5QRtwOM05gR50ImaaJgBx68vi.jpg")
                : NetworkImage(dpUrl)),
        title: Text(
          widget.snap['username'],
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
    ;
  }
}
