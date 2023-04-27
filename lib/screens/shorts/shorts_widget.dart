import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ShortsWidget extends StatefulWidget {
  String url;
  ShortsWidget(this.url);

  @override
  State<ShortsWidget> createState() => _ShortsWidgetState();
}

class _ShortsWidgetState extends State<ShortsWidget> {
  VideoPlayerController? _videoPlayerController;
  @override
  void initState() {
    super.initState();
    videogetter();
  }

  @override
  void dispose() {
    _videoPlayerController!.dispose();
    super.dispose();
  }

  void videogetter() async {
    _videoPlayerController = VideoPlayerController.network(widget.url)
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(false)
      ..initialize().then((_) => _videoPlayerController!.play());
  }

  @override
  Widget build(BuildContext context) {
    var mediaqurey = MediaQuery.of(context).size;
    return !_videoPlayerController!.value.isInitialized
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SizedBox(
            height: mediaqurey.height,
            width: mediaqurey.width,
            child: Stack(
              children: [
              ( _videoPlayerController!.value.size.height>=mediaqurey.height*0.7)
                        ? Container(
                          child: VideoPlayer(
                              _videoPlayerController!,
                            ),
                        )
                        : Container(
                  child: Center(
                    child:  AspectRatio(
                            aspectRatio:
                                _videoPlayerController!.value.aspectRatio,
                            child: VideoPlayer(_videoPlayerController!)),
                  ),
                ),
                Positioned(
                  top: mediaqurey.height * 0.02,
                  child: SizedBox(
                    height: mediaqurey.height * 0.04,
                    width: mediaqurey.width,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6, right: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6))),
                              height: mediaqurey.height * 0.04,
                              width: mediaqurey.width * 0.08,
                              child: Icon(
                                Icons.arrow_back_sharp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 40,
                            child: ListView(
                              physics: ClampingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 13),
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      height: mediaqurey.height * 0.3,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(14))),
                                      child: Center(
                                          child: Text(
                                        'For You',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 13),
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      height: mediaqurey.height * 0.3,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(14))),
                                      child: Center(
                                          child: Text(
                                        'India',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 13),
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      height: mediaqurey.height * 0.3,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(14))),
                                      child: Center(
                                          child: Text(
                                        'Trending',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 13),
                                  child: Container(
                                    height: mediaqurey.height * 0.3,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        color: Colors.white24,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14))),
                                    child: Center(
                                      child: Text(
                                        'Places',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      _videoPlayerController!.value.isPlaying
                          ? _videoPlayerController!.pause()
                          : _videoPlayerController!.play();
                    },
                    child: _videoPlayerController!.value.isPlaying
                        ? Container(
                            height: 300,
                            width: 200,
                          )
                        : SvgPicture.asset(
                            'images/icons/Play.svg',
                            height: 30,
                            width: 30,
                          ),
                  ),
                ),
                Positioned(
                  top: mediaqurey.height * 0.5,
                  left: mediaqurey.width * 0.88,
                  child: Column(
                    children: [
                      Icon(
                        Icons.more_horiz_outlined,
                        size: 32,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 34,
                        width: 34,
                        child: Image.asset('images/icons/Group 9543.png',
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 34,
                        width: 34,
                        child: Image.asset('images/icons/Group 9562.png',
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 24,
                        width: 24,
                        child: Image.asset(
                          'images/icons/Group 9581.png',
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 28,
                      ),
                      Container(
                        height: 24,
                        width: 24,
                        child: Image.asset('images/icons/Group 9582.png',
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                // Positioned(
                //     bottom: mediaqurey.height * 0.01,
                //     left: mediaqurey.width * 0.64,
                //     child: Container(
                //       width: mediaqurey.width * 0.4,
                //       child: Row(
                //         children: [
                //           Text(
                //             'HipHop music',
                //             style: TextStyle(
                //                 color: Colors.white, fontSize: 14),
                //           ),
                //           SizedBox(
                //             width: 15,
                //           ),
                //           CircleAvatar(
                //             backgroundColor: Colors.black54,
                //             radius: 12,
                //             child: Center(
                //                 child: Image.asset(
                //               'images/icons/Group 9456.png',
                //               height: 14,
                //               width: 14,
                //               color: Colors.white,
                //               fit: BoxFit.contain,
                //             )),
                //           )
                //         ],
                //       ),
                //     )),
                Positioned(
                    top: mediaqurey.height * 0.765,
                    child: SizedBox(
                      width: mediaqurey.width * 0.75,
                      child: ListTile(
                        horizontalTitleGap: 0,
                        leading: Container(
                          padding: EdgeInsets.only(top: 4),
                          child: CircleAvatar(
                            backgroundColor: Colors.pink,
                            radius: 17,
                          ),
                        ),
                        title: SizedBox(
                          width: mediaqurey.width * 0.5,
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Joshwa_i ',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        height: mediaqurey.height * 0.027,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white, width: 1.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Follow',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text.rich(TextSpan(children: [
                                    TextSpan(
                                      text: '120k Followers  ',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                    TextSpan(
                                      text: '1 day ago',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 11),
                                    )
                                  ])),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                Positioned(
                  top: mediaqurey.height * 0.845,
                  left: mediaqurey.width * 0.04,
                  child: Column(
                    children: [
                      Container(
                        width: mediaqurey.width * 0.5,
                        child: Text(
                          'Expand Your Audience with your videos and make a good content for socity',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                          width: mediaqurey.width * 0.5,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Container(
                                  height: mediaqurey.height * 0.035,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
                                    color: Colors.black26,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '#Video',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Container(
                                  height: mediaqurey.height * 0.035,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
                                    color: Colors.black26,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '#reels',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Container(
                                  height: mediaqurey.height * 0.035,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
                                    color: Colors.black26,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '#happy',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              ],
            ),
          );
    ;
  }
}
