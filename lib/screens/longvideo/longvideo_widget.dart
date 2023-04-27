import 'dart:io';

import 'package:filroll_app/screens/longvideo/fullscreen_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../shorts/shorts_screen.dart';

class LongVideoWidget extends StatefulWidget {
  const LongVideoWidget({super.key});

  @override
  State<LongVideoWidget> createState() => _LongVideoWidgetState();
}

class _LongVideoWidgetState extends State<LongVideoWidget> {
  List videourl = [
    'https://static.videezy.com/system/resources/previews/000/044/285/original/Mail-Digital-Network-2.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-waves-in-the-water-1164-large.mp4',
    'https://static.videezy.com/system/resources/previews/000/052/814/original/futuristic-digital-big-data-processing-technology.mp4'
  ];
  VideoPlayerController _videoPlayerController = VideoPlayerController.network(
      'https://static.videezy.com/system/resources/previews/000/044/285/original/Mail-Digital-Network-2.mp4');
  int videoindex = 0;
  List<String> thumnails = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    urlthumbnails();
  }

  void videogetter() async {
    _videoPlayerController = VideoPlayerController.network(videourl[videoindex])
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(false)
      ..initialize().then((_) => _videoPlayerController.play());
  }

  Future<String> getThumbnail(String videoPath) async {
    final thumbnailFile = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      imageFormat: ImageFormat.PNG,
      maxWidth:
          128, // specify the width of the thumbnail, in this case 128 pixels
      quality: 50, // specify the quality of the thumbnail, from 0 to 100
    );

    return thumbnailFile!;
  }

  void urlthumbnails() async {
    var t = 0;
    for (t; t < videourl.length; t++) {
      var paths = await getThumbnail(videourl[t]);
      thumnails.add(paths);
    }
    print(thumnails);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: thumnails.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(0, 4))
                ],
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              height: mediaquery.height * 0.43,
              child: Column(
                children: [
                  Flexible(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15)),
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                  color: Colors.blue,
                                  image: DecorationImage(
                                      image: FileImage(
                                        File(thumnails[index]),
                                      ),
                                      fit: BoxFit.cover),
                                ),
                                child: VideoPlayer(
                                  _videoPlayerController,
                                )),
                          ),
                          InkWell(
                            // onTap: () {
                            //                  _videoPlayerController.play();
                            //   setState(() {
                            //     videoindex=index;
                            //   });
                            //   videogetter();
                            // },
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: SvgPicture.asset(
                                'images/icons/Play.svg',
                                height: 30,
                                width: 30,
                              ),
                            ),
                          ),
                          Positioned(
                            top: mediaquery.height * 0.03,
                            right: mediaquery.width * 0.06,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              height: 15,
                              width: 45,
                              child: Center(
                                child: Text(
                                  _videoPlayerController.value.duration
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 8),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: mediaquery.height * 0.015,
                            right: mediaquery.width * 0.03,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => FullScreen(index),
                                ));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                height: 16,
                                width: 16,
                                child: Image.asset(
                                  "images/icons/fullscreen.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                  Flexible(
                      child: Column(
                        children: [
                        
                          ListTile(
                            visualDensity: VisualDensity(vertical: -4),
                            horizontalTitleGap: 0,
                            leading: Padding(
                              padding: const EdgeInsets.only(top: 9),
                              child: CircleAvatar(
                                backgroundColor: Colors.amber,
                                radius: 18,
                              ),
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                'Introducing AVINIYA concept EV 1A new paradigm of innovation ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            subtitle: Text(
                              'Tata Motors Car ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                            trailing: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, bottom: 40,top: 8),
                              child: Container(
                                height: 25,
                                width: 25,
                                child: Icon(
                                  Icons.more_horiz,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 0.4,
                            color: Color.fromARGB(96, 158, 158, 158),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Container(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: Center(
                                          child: Image.asset(
                                            'images/icons/Group 9543.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 6),
                                        child: SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: Center(
                                            child: SvgPicture.asset(
                                              "images/icons/Send.svg",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Container(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: Center(
                                          child: Image.asset(
                                            "images/icons/link.png",
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 6),
                                        child: SizedBox(
                                          height: 22,
                                          width: 22,
                                          child: Center(
                                            child: Image.asset(
                                              "images/icons/share.png",
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
