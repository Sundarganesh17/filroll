import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/providers/post.dart';
import 'package:filroll_app/providers/story.dart';
import 'package:filroll_app/screens/animation.dart';
import 'package:filroll_app/screens/feed/home_screen.dart';
import 'package:filroll_app/screens/feed/trial1.dart';
import 'package:filroll_app/screens/story/stories.dart';
import 'package:filroll_app/widgets/feed_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Trial extends StatefulWidget {
  const Trial({super.key});

  @override
  State<Trial> createState() => _TrialState();
}

class _TrialState extends State<Trial> {
  late Story ref;
  late Post postRef;
  bool isLoading = true;
  var snap;
  var stream;
  List dummy = [];
  Future<QuerySnapshot<Map<String, dynamic>>>? future;

  @override
  void initState() {
    super.initState();
    Provider.of<Story>(context, listen: false).getStory();
    fetchPosts();
  }

  fetchPosts() async {
    Provider.of<Post>(context, listen: false).fetchPosts();
    Provider.of<Story>(context, listen: false).getDumStory();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref = Provider.of<Story>(context);
    postRef = Provider.of<Post>(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.black,
        body: ref.isLoading
            ? Center(child: CircularProgressIndicator())
            : isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    backgroundColor: Color.fromARGB(255, 42, 42, 42),
                    onRefresh: () async {
                      await Future.delayed(const Duration(seconds: 2));
                      setState(() {
                        fetchPosts();
                      });
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (ref.uses.length != 0)
                            Container(
                              color: Colors.black,
                              height: size.height * 0.14,
                              width: size.width,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: ref.uses.length,
                                  itemBuilder: (context, index) {
                                    return StoryView(
                                      snap: ref.uses[index],
                                      index: index,
                                    );
                                  }),
                            ),
                          // StreamBuilder(
                          //   stream: FirebaseFirestore.instance
                          //       .collection('stories')
                          //       .orderBy('dateTime', descending: true)
                          //       .snapshots(),
                          //   builder: (context, snapshot) {
                          //     if (!snapshot.hasData) {
                          //       return Center(
                          //         child: CircularProgressIndicator(),
                          //       );
                          //     }
                          //     return Container(
                          //       color: Colors.black,
                          //       height: size.height * 0.14,
                          //       width: size.width,
                          //       child: ListView.builder(
                          //           scrollDirection: Axis.horizontal,
                          //           itemCount: snapshot.data!.docs.length,
                          //           itemBuilder: (context, index) {
                          //             return StoryView(
                          //               snap:
                          //                   snapshot.data!.docs[index].data(),
                          //             );
                          //           }),
                          //     );
                          //   },
                          // ),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: postRef.posts.length,
                            itemBuilder: (context, index) => FeedList(
                              snap: postRef.posts[index],
                              index: index,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
  }
}
