import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../shorts/shorts_screen.dart';
import 'longvideo_widget.dart';

class LongVideoScreen extends StatefulWidget {
  const LongVideoScreen({super.key});

  @override
  State<LongVideoScreen> createState() => _LongVideoScreenState();
}

class _LongVideoScreenState extends State<LongVideoScreen> {
  bool close = false;
   List videourl = [
    'https://static.videezy.com/system/resources/previews/000/044/285/original/Mail-Digital-Network-2.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-waves-in-the-water-1164-large.mp4',
    'https://static.videezy.com/system/resources/previews/000/052/814/original/futuristic-digital-big-data-processing-technology.mp4'
  ];
   List<String> thumnails = [];
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    urlthumbnails();
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
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          toolbarHeight: mediaquery.height * 0.07,
          backgroundColor: Colors.black,
          leadingWidth: 40,
          leading: Padding(
            padding: const EdgeInsets.only(top: 6, left: 14),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                // height: mediaquery.height*0.003,
                width: mediaquery.width * 0.07,
                height: 10,
                child: Image.asset(
                  "images/icons/link.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(
              width: mediaquery.width * 0.002,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10,left: 8,right: 8),
              child: Container(
                height: 10,
                width: mediaquery.width * 0.07,
                child: Center(
                  child: SvgPicture.asset(
                              "images/icons/Send.svg",
                              fit: BoxFit.contain,
                            ),
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Column(
            children: [
              SizedBox(
                height: mediaquery.height * 0.02,
              ),
              SizedBox(
                width: mediaquery.width,
                height: 30,
                child: TabBar(
                    indicator: BoxDecoration(
                      color: Color.fromARGB(57, 158, 158, 158),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    unselectedLabelStyle:
                        TextStyle(color: Colors.white, fontSize: 10),
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                    tabs: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: SizedBox(
                            child: Center(
                                child: Text(
                          'Videos',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ))),
                      ),
                      SizedBox(
                        height: 40,
                        child: Center(
                          child: Text(
                            'More Features commingsoon',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ]),
              ),
              SizedBox(
                height: mediaquery.height * 0.02,
              ),
              Expanded(
                child: TabBarView(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!close)
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'FilVideo',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            close = !close;
                                          });
                                        },
                                        child: CircleAvatar(
                                          radius: 9,
                                          backgroundColor: Colors.black87,
                                          child: Center(
                                            child: Icon(Icons.close),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  child: Text(
                                    'Its Harry Potter fourth term at Hogwarts School of Witchcraft and Wizardry! Harry, Ron and Hermione look forward to the international Quidditch ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          LongVideoWidget(),
                          //  Expanded(
                          //    child: Column(
                          //                  mainAxisAlignment: MainAxisAlignment.start,
                          //                  crossAxisAlignment: CrossAxisAlignment.start,
                          //                  children: [
                          //                    Text(
                          //                      'Roll',
                          //                      style: TextStyle(
                          //                          fontSize: 18,
                          //                          fontWeight: FontWeight.bold,
                          //                          color: Colors.white),
                          //                    ),
                          //                    SizedBox(
                          //                      height: 10,
                          //                    ),
                          //                    SizedBox(
                          //                        height: mediaquery.height * 0.2,
                          //                        width: mediaquery.width,
                          //                        child: ListView.builder(
                          //                          scrollDirection: Axis.horizontal,
                          //                          shrinkWrap: true,
                          //                          itemCount:thumnails .length,
                          //                          itemBuilder: (context, index) {
                          //                            return SizedBox(
                          //       height:mediaquery.height * 0.2,
                          //       width: mediaquery.width * 0.3,
                          //       child: Padding(
                          //         padding: const EdgeInsets.only(right: 15),
                          //         child: InkWell(
                          //           onTap: () {
                          //             Navigator.of(context)
                          //                 .pushReplacement(MaterialPageRoute(
                          //               builder: (context) => ShortsScreen(index),
                          //             ));
                          //           },
                          //           child: Container(
                          //             decoration: BoxDecoration(
                          //                 image: DecorationImage(
                          //                     image: FileImage(
                          //                       File(thumnails[index]),
                          //                     ),
                          //                     fit: BoxFit.cover),
                          //                 borderRadius: BorderRadius.all(Radius.circular(12))
                          //                     ),
                          //           ),
                          //         ),
                          //       ));
                          //                          },
                          //                        )),
                          //                         SizedBox(
                          //                  height: mediaquery.height * 0.03,
                          //                ),
                          //                  ],
                          //                ),
                          //  ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.black,
                    child: Center(
                      child: Text(
                        'We are going to updatesoon',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
