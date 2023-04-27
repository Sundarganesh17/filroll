import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/providers/story.dart';
import 'package:filroll_app/screens/animation.dart';
import 'package:filroll_app/screens/story/stories.dart';
import 'package:filroll_app/widgets/feed_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  late Story ref;

  @override
  void initState() {
    super.initState();
    Provider.of<Story>(context, listen: false).getStory();
  }

  @override
  Widget build(BuildContext context) {
    ref = Provider.of<Story>(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.black,
        body: ref.isLoading
            ? AnimationPage(picName: 'feed')
            : SingleChildScrollView(
                child: Column(
                  children: [
                    if (ref.stories.length != 0)
                      Container(
                        color: Colors.black,
                        height: size.height * 0.14,
                        width: size.width,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: ref.stories.length,
                            itemBuilder: (context, index) {
                              return StoryView(
                                snap: ref.stories[index],
                                index: index,
                              );
                            }),
                      ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .orderBy('dateTime', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return AnimationPage(picName: 'feed');
                        }
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) => FeedList(
                            snap: snapshot.data!.docs[index].data(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
        // Column(
        //   children: [
        //     Container(
        //       color: Colors.black,
        //       height: size.height * 0.14,
        //       width: size.width,
        //       child: storyview(),
        //     ),
        //     StreamBuilder(
        //       stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        //       builder: (context, snapshot) {
        //         if (snapshot.connectionState == ConnectionState.waiting) {
        //           return Center(
        //             child: CircularProgressIndicator(),
        //           );
        //         }
        //         return ListView.builder(
        //           itemCount: snapshot.data!.docs.length,
        //           itemBuilder: (context, index) => FeedList(),
        //         );
        //       },
        //     )
        //   ],
        // ),
        );
  }
}
