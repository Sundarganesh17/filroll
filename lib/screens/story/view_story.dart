import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/model/story_model.dart';
import 'package:filroll_app/providers/story.dart';
import 'package:filroll_app/screens/circular_progress_indicator_page.dart';
import 'package:filroll_app/screens/story/story_more.dart';
import 'package:filroll_app/widgets/story_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:story/story.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ViewStory extends StatefulWidget {
  final snap;
  const ViewStory({super.key, required this.snap});

  @override
  State<ViewStory> createState() => _ViewStoryState();
}

class _ViewStoryState extends State<ViewStory> {
  bool isLoading = false;
  var userUid;
  var storyLength;
  bool isVideo = false;
  Future<QuerySnapshot<Map<String, dynamic>>>? future;

  @override
  void initState() {
    super.initState();
    setState(() {
      userUid = widget.snap.uid;
    });
    Provider.of<Story>(context, listen: false).getUserStory(userUid);
    future = FirebaseFirestore.instance
        .collection('stories')
        .doc(userUid)
        .collection('userStories')
        .get();

    getDetail();
  }

  getDetail() async {
    var story = await FirebaseFirestore.instance
        .collection('stories')
        .doc(userUid)
        .collection('userStories')
        .get();
    storyLength = story.docs.length;
  }

  late Story ref;
  @override
  Widget build(BuildContext context) {
    ref = Provider.of<Story>(context);
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: size.height,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('stories')
                      .snapshots(),
                  builder: (context, snap) {
                    return FutureBuilder(
                        future: future,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Scaffold(
                              backgroundColor: Colors.black,
                              body: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          return StoryPageView(
                              onPageLimitReached: () {
                                Navigator.of(context).pop();
                              },
                              onPageChanged: (index) async {
                                if (widget.snap.uid !=
                                    snapshot.data!.docs[index]['uid']) {
                                  setState(() {
                                    userUid = '';
                                    isLoading = true;
                                    userUid = snapshot.data!.docs[index]['uid'];
                                  });
                                  await ref.getUserStory(userUid);
                                  getDetail();
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                              itemBuilder: ((context, pageIndex, storyIndex) {
                                if (ref.userStories.isEmpty) {
                                  return const CircularProgrssIndicatorPage();
                                }

                                print(storyIndex);
                                print(ref.userStories[storyIndex].storyId);
                                return StoryList(
                                    storySnap: ref.userStories[storyIndex]);
                              }),
                              storyLength: (pageIndex) =>
                                  ref.userStories.length,
                              pageLength: snap.data!.docs.length,
                              indicatorDuration: Duration(seconds: 7));
                        });
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 20),
        child: FloatingActionButton.small(
          backgroundColor: Colors.black.withOpacity(0.2),
          // ignore: sort_child_properties_last
          child: PopupMenuButton(
            color: Colors.black.withOpacity(0.5),
            position: PopupMenuPosition.under,
            itemBuilder: ((context) => [
                  ...MenuItems.itemsfirst.map(buildItem).toList(),
                  ...MenuItems.itemSecond.map(buildItem1).toList(),
                ]),
          ),
          onPressed: (() {}),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: mediaQuery.viewInsets,
          child: Container(
            color: Colors.black,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    height: size.height * 0.06,
                    width: size.width * 0.75,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: const Color(0xFF1A1920)),
                    child: Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.5,
                          child: TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Send Your Comments...',
                                border: InputBorder.none,
                                hintStyle: GoogleFonts.mPlusRounded1c(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(17, 0, 0, 3)),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            color: Colors.white.withOpacity(0.85),
                            onPressed: () {},
                            icon: const Icon(
                                Icons.sentiment_satisfied_alt_outlined),
                            iconSize: 26,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12, left: 5),
                  height: 40,
                  width: 40,
                  child: FittedBox(
                    child: InkWell(
                      child: SvgPicture.asset(
                        "images/icons/Heart.svg",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12, left: 5),
                  height: 38,
                  width: 38,
                  child: FittedBox(
                    child: InkWell(
                      child: SvgPicture.asset(
                        "images/icons/Send.svg",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PopupMenuItem buildItem(dynamic item) => PopupMenuItem(
          child: Row(
        children: [
          SizedBox(
            height: 17,
            width: 17,
            child: item.icon,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            item.text,
            style: GoogleFonts.rubik(
                fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ],
      ));
  PopupMenuItem buildItem1(dynamic item) => PopupMenuItem(
          child: Row(
        children: [
          SizedBox(
            height: 17,
            width: 17,
            child: item.icon,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            item.text,
            style: GoogleFonts.rubik(
                fontSize: 14, fontWeight: FontWeight.w500, color: Colors.red),
          ),
        ],
      ));
}



// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:filroll_app/model/story_model.dart';
// import 'package:filroll_app/providers/story.dart';
// import 'package:filroll_app/screens/circular_progress_indicator_page.dart';
// import 'package:filroll_app/screens/story_more.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:logger/logger.dart';
// import 'package:story/story.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:provider/provider.dart';

// class ViewStory extends StatefulWidget {
//   final StoryModel snap;
//   const ViewStory({super.key, required this.snap});

//   @override
//   State<ViewStory> createState() => _ViewStoryState();
// }

// class _ViewStoryState extends State<ViewStory> {
//   bool isLoading = false;
//   var story;
//   var storyLength;
//   String? userUid = FirebaseAuth.instance.currentUser!.uid;

//   @override
//   void initState() {
//     super.initState();
//     Provider.of<Story>(context, listen: false)
//         .getUserStory(FirebaseAuth.instance.currentUser!.uid);
//   }

//   late Story ref;
//   @override
//   Widget build(BuildContext context) {
//     ref = Provider.of<Story>(context);
//     final MediaQueryData mediaQuery = MediaQuery.of(context);
//     final size = MediaQuery.of(context).size;
//     final h = size.height * 0.07;
//     final h1 = size.height - h;
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SizedBox(
//               height: size.height,
//               child: StoryPageView(
//                   onPageLimitReached: () {
//                     Navigator.of(context).pop();
//                   },
//                   onPageChanged: (index) async {
//                     setState(() {
//                       isLoading = true;
//                     });
//                     Logger().wtf(ref.stories[index].uid);
//                     await ref.getUserStory(ref.stories[index].uid!);
//                     userUid = ref.stories[index].uid!;
//                     setState(() {
//                       isLoading = false;
//                     });
//                   },
//                   itemBuilder: ((context, pageIndex, storyIndex) {
//                     if (ref.userStories.isEmpty) {
//                       return const Center(child: CircularProgressIndicator());
//                     } else {
//                       //story = ref.userStories[storyIndex];
//                       return isLoading
//                           ? const Scaffold(
//                               backgroundColor: Colors.black,
//                               body: Center(child: CircularProgressIndicator()))
//                           : StreamBuilder(
//                               stream: FirebaseFirestore.instance
//                                   .collection('stories')
//                                   .doc(userUid)
//                                   .collection('userStories')
//                                   .snapshots(),
//                               builder: (context, snapshot) {
//                                 return ListView.builder(
//                                   itemCount: snapshot.data!.docs.length,
//                                   itemBuilder: (context, index) {
//                                     storyLength = snapshot.data!.docs.length;
//                                     return Stack(
//                                       children: [
//                                         Positioned(
//                                             child: Container(
//                                           color: Colors.black,
//                                         )),
//                                         Positioned(
//                                             child: Container(
//                                           margin:
//                                               const EdgeInsets.only(bottom: 15),
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(9),
//                                               image: DecorationImage(
//                                                   fit: BoxFit.cover,
//                                                   image: NetworkImage(snapshot
//                                                       .data!.docs[index]
//                                                       .data()['storyUrl']))),
//                                         )),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               top: 42, left: 10),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Container(
//                                                 width: 40,
//                                                 height: 40,
//                                                 decoration: BoxDecoration(
//                                                   shape: BoxShape.circle,
//                                                   image: DecorationImage(
//                                                     fit: BoxFit.fill,
//                                                     image: NetworkImage(snapshot
//                                                         .data!.docs[index]
//                                                         .data()['dpUrl']),
//                                                   ),
//                                                 ),
//                                               ),
//                                               const SizedBox(
//                                                 width: 9,
//                                               ),
//                                               Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     top: 9),
//                                                 child: Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text(
//                                                       snapshot.data!.docs[index]
//                                                           .data()['username'],
//                                                       style: GoogleFonts.roboto(
//                                                         color: Colors.white,
//                                                         fontSize: 15.0,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 );
//                               },
//                             );
//                     }
//                   }),
//                   storyLength: (pageIndex) => ref.userStories.length,
//                   pageLength: 1),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: Container(
//         margin: const EdgeInsets.only(top: 15),
//         child: FloatingActionButton.small(
//           backgroundColor: Colors.black.withOpacity(0.2),
//           // ignore: sort_child_properties_last
//           child: PopupMenuButton(
//             color: Colors.black.withOpacity(0.5),
//             position: PopupMenuPosition.under,
//             itemBuilder: ((context) => [
//                   ...MenuItems.itemsfirst.map(buildItem).toList(),
//                   ...MenuItems.itemSecond.map(buildItem1).toList(),
//                 ]),
//           ),
//           onPressed: (() {}),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
//       bottomNavigationBar: SafeArea(
//         child: Padding(
//           padding: mediaQuery.viewInsets,
//           child: Container(
//             color: Colors.black,
//             child: Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(0),
//                   child: Container(
//                     height: size.height * 0.06,
//                     width: size.width * 0.75, //color: Colors.white,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20.0),
//                       color: const Color(0xFF1A1920),
//                     ),
//                     child: Row(
//                       children: [
//                         SizedBox(
//                           width: size.width * 0.5,
//                           child: TextFormField(
//                             decoration: InputDecoration(
//                               hintText: 'Send Message',
//                               border: InputBorder.none,
//                               hintStyle: GoogleFonts.mPlusRounded1c(
//                                 fontSize: 14,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               contentPadding:
//                                   const EdgeInsets.fromLTRB(17, 0, 0, 3),
//                             ),
//                           ),
//                         ),
//                         const Spacer(),
//                         Padding(
//                           padding: const EdgeInsets.all(7.0),
//                           child: IconButton(
//                             padding: EdgeInsets.zero,
//                             constraints: const BoxConstraints(),
//                             color: Colors.white.withOpacity(0.85),
//                             onPressed: () {},
//                             icon: const Icon(
//                                 Icons.sentiment_satisfied_alt_outlined),
//                             iconSize: 26,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(top: 12, left: 5),
//                   height: 40,
//                   width: 40,
//                   child: FittedBox(
//                     child: InkWell(
//                       child: SvgPicture.asset(
//                         "images/icons/Heart.svg",
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(top: 12, left: 5),
//                   height: 38,
//                   width: 38,
//                   child: FittedBox(
//                     child: InkWell(
//                       child: SvgPicture.asset(
//                         "images/icons/Send.svg",
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   PopupMenuItem buildItem(dynamic item) => PopupMenuItem(
//           child: Row(
//         children: [
//           SizedBox(
//             height: 17,
//             width: 17,
//             child: item.icon,
//           ),
//           const SizedBox(
//             width: 10,
//           ),
//           Text(
//             item.text,
//             style: GoogleFonts.rubik(
//                 fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
//           ),
//         ],
//       ));
//   PopupMenuItem buildItem1(dynamic item) => PopupMenuItem(
//           child: Row(
//         children: [
//           SizedBox(
//             height: 17,
//             width: 17,
//             child: item.icon,
//           ),
//           const SizedBox(
//             width: 10,
//           ),
//           Text(
//             item.text,
//             style: GoogleFonts.rubik(
//                 fontSize: 14, fontWeight: FontWeight.w500, color: Colors.red),
//           ),
//         ],
//       ));
// }
