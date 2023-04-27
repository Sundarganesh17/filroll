import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:filroll_app/providers/story.dart';
import 'package:filroll_app/widgets/testing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoryView extends StatefulWidget {
  final snap;
  final index;
  const StoryView({Key? key, required this.snap, required this.index})
      : super(key: key);

  @override
  State<StoryView> createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  bool isViewed = false;
  String dpUrl = '';
  String userName = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getDp();
  }

  void getDp() async {
    // DocumentSnapshot snap = await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(widget.snap['uid'])
    //     .get();
    // var dp = await getUrl('dp-${widget.snap['uid']}.jpg');
    if (widget.snap.views.contains(FirebaseAuth.instance.currentUser!.uid)) {
      setState(() {
        isViewed = true;
      });
    }

    // setState(() {
    //   dpUrl = dp;
    //   userName = (snap.data() as Map<String, dynamic>)['username'];
    // });
    setState(() {
      isLoading = false;
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

  late Story ref;

  @override
  Widget build(BuildContext context) {
    ref = Provider.of<Story>(context);
    return GestureDetector(
      child: Column(
        children: [
          Container(
              padding: isViewed ? EdgeInsets.all(1) : EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: !isViewed
                      ? const LinearGradient(colors: [
                          Color.fromARGB(720, 114, 5, 255),
                          Color.fromARGB(167, 22, 115, 255),
                        ])
                      : LinearGradient(colors: [
                          Color.fromRGBO(112, 111, 115, 1),
                          Color.fromRGBO(112, 111, 115, 1),
                        ])),
              child: Container(
                padding: EdgeInsets.all(1.5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.5),
                    color: Colors.black),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: !dpUrl.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Image.network(
                          widget.snap.imageUrl,
                          height: 70,
                          width: 55,
                          fit: BoxFit.cover,
                        ),
                ),
              )),
          SizedBox(
            height: 20,
            width: 80,
            child: Center(
              child: Text(
                widget.snap.userName,
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        setState(() {
          isViewed = true;
        });
        print(widget.index);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StoryPage(index: widget.index)));
      },
    );
  }
}

class Tile {
  String? imgUrl;
  String? name;

  Tile({this.imgUrl, this.name});
}
