import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/screens/circular_progress_indicator_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class StoryList extends StatefulWidget {
  final storySnap;
  const StoryList({super.key, required this.storySnap});

  @override
  State<StoryList> createState() => _StoryListState();
}

class _StoryListState extends State<StoryList> {
  String dpUrl = '';
  String dpUrl1 = '';
  String username = '';
  bool isLoading = true;
  VideoPlayerController? controller;
  var storyUrl;
  String userUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    getDp();
    // if (widget.storySnap['isVideo']) {
    //   controllerInitiation();
    // } else {
    //   picUrl();
    // }
  }

  // void controllerInitiation() async {
  //   var postUrl = await getUrl(widget.storySnap['storyUrl']);
  //   controller = VideoPlayerController.network((postUrl))
  //     ..addListener(
  //       () => setState(() {}),
  //     )
  //     ..setLooping(true)
  //     ..initialize().then((_) => controller!.play());
  // }

  Future<String> getUrl(String key) async {
    try {
      final result = await Amplify.Storage.getUrl(key: key);
      return result.url;
    } catch (e) {
      throw e;
    }
  }

  getDp() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.storySnap.uid)
        .get();
    var dp = await getUrl('dp-${widget.storySnap.uid}.jpg');
    print(widget.storySnap.storyUrl);
    var story = await getUrl(widget.storySnap.storyUrl);
    setState(() {
      dpUrl = dp;
      storyUrl = story;
      dpUrl1 = (snap.data() as Map<String, dynamic>)['DPUrl'];
      username = (snap.data() as Map<String, dynamic>)['username'];
    });
    await FirebaseFirestore.instance
        .collection('stories')
        .doc(widget.storySnap.uid)
        .update({
      'isViewed': FieldValue.arrayUnion([userUid])
    });
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   controller!.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return dpUrl.isEmpty
        ? const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Stack(
            children: [
              Positioned(
                  child: Container(
                color: Colors.black,
              )),
              // widget.storySnap['isVideo']
              //     ? Positioned(
              //         child: Container(
              //         margin: const EdgeInsets.only(bottom: 15),
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(9),
              //         ),
              //         child: GestureDetector(
              //           behavior: HitTestBehavior.opaque,
              //           onTap: (() => controller!.value.isPlaying
              //               ? controller!.pause()
              //               : controller!.play()),
              //           child: Stack(
              //             alignment: Alignment.center,
              //             children: [
              //               AspectRatio(
              //                   aspectRatio: controller!.value.aspectRatio,
              //                   child: VideoPlayer(controller!)),
              //               controller!.value.isPlaying
              //                   ? const SizedBox()
              //                   : GestureDetector(
              //                       child: Align(
              //                         alignment: Alignment.center,
              //                         child: Icon(
              //                           Icons.play_arrow,
              //                           color: Colors.white,
              //                           size: 80,
              //                         ),
              //                       ),
              //                       onTap: () => controller!.value.isPlaying
              //                           ? controller!.pause()
              //                           : controller!.play(),
              //                     ),
              //               Positioned(
              //                   bottom: 0,
              //                   left: 0,
              //                   right: 0,
              //                   child: VideoProgressIndicator(controller!,
              //                       colors: const VideoProgressColors(
              //                           playedColor: Colors.blue),
              //                       allowScrubbing: true)),
              //               Positioned(
              //                 top: size.height * 0.002,
              //                 right: size.width * 0.01,
              //                 child: controller!.value.volume == 0
              //                     ? IconButton(
              //                         icon: Icon(Icons.volume_off),
              //                         color: Colors.white,
              //                         onPressed: () =>
              //                             controller!.setVolume(1.0),
              //                       )
              //                     : IconButton(
              //                         icon: Icon(Icons.volume_up_rounded),
              //                         color: Colors.white,
              //                         onPressed: () => controller!.setVolume(0),
              //                       ),
              //               )
              //             ],
              //           ),
              //         ),
              //       ))
              //    :
              Positioned(
                  child: Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    image: DecorationImage(
                        fit: BoxFit.contain, image: NetworkImage(storyUrl))),
              )),
              Padding(
                padding: const EdgeInsets.only(top: 52, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                        radius: 18,
                        backgroundImage: dpUrl1.contains('https')
                            ? NetworkImage(
                                'https://as2.ftcdn.net/v2/jpg/03/31/69/91/1000_F_331699188_lRpvqxO5QRtwOM05gR50ImaaJgBx68vi.jpg')
                            : NetworkImage(dpUrl)),
                    const SizedBox(
                      width: 9,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 9),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );

    // FutureBuilder(
    //   future: future,
    //   builder: (context, snapshot) {
    //     if (!snapshot.hasData) {
    //       print('2');
    //       return Container(
    //         height: double.infinity,
    //         width: double.infinity,
    //         color: Colors.black,
    //         child: const Center(child: CircularProgressIndicator()),
    //       );
    //     }
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const Scaffold(
    //           backgroundColor: Colors.black,
    //           body: Center(child: CircularProgressIndicator()));
    //     }
    //     return Stack(
    //       children: [
    //         Positioned(
    //             child: Container(
    //           color: Colors.black,
    //         )),
    //         Positioned(
    //             child: Container(
    //           margin: const EdgeInsets.only(bottom: 15),
    //           decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(9),
    //               image: DecorationImage(
    //                   fit: BoxFit.cover,
    //                   image: NetworkImage(snapshot
    //                           .data!.docs[widget.storyIndex]['storyUrl'].isEmpty
    //                       ? Center(child: CircularProgressIndicator())
    //                       : widget.storySnap
    //                           ['storyUrl']))),
    //         )),
    //         Padding(
    //           padding: const EdgeInsets.only(top: 42, left: 10),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Container(
    //                 width: 40,
    //                 height: 40,
    //                 decoration: BoxDecoration(
    //                   shape: BoxShape.circle,
    //                   image: DecorationImage(
    //                     fit: BoxFit.fill,
    //                     image: NetworkImage(
    //                         widget.storySnap['dpUrl']),
    //                   ),
    //                 ),
    //               ),
    //               const SizedBox(
    //                 width: 9,
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 9),
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Text(
    //                       widget.storySnap['username'],
    //                       style: GoogleFonts.roboto(
    //                         color: Colors.white,
    //                         fontSize: 15.0,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }
}
