import 'dart:io';

import 'package:filroll_app/screens/longvideo/longvideo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class FullScreen extends StatefulWidget {
  int videonumber = 0;
  FullScreen(this.videonumber);
  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    urlthumbnails();
  }

  List videourl = [
    'https://static.videezy.com/system/resources/previews/000/044/285/original/Mail-Digital-Network-2.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-waves-in-the-water-1164-large.mp4',
    'https://static.videezy.com/system/resources/previews/000/052/814/original/futuristic-digital-big-data-processing-technology.mp4'
  ];
  List<String> thumnails = [];
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: thumnails.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  SizedBox(
                    height: mediaquery.height * 0.45,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            image: DecorationImage(
                                image: FileImage(
                                  File(thumnails[widget.videonumber]),
                                ),
                                fit: BoxFit.cover),
                          ),
                          // child: VideoPlayer(
                          //   _videoPlayerController,
                          // ),
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
                          bottom: mediaquery.height * 0.015,
                          left: mediaquery.width * 0.03,
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
                                '1:00',
                                //  _videoPlayerController.value.duration
                                style:
                                    TextStyle(color: Colors.white, fontSize: 8),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: mediaquery.height * 0.015,
                          right: mediaquery.width * 0.03,
                          child: InkWell(
                            // onTap: () {
                            //   Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => FullScreen(),
                            //   ));
                            // },
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
                        Positioned(
                          top: mediaquery.height * 0.015,
                          right: mediaquery.width * 0.03,
                          child: InkWell(
                            // onTap: () {
                            //   Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => FullScreen(),
                            //   ));
                            // },
                            child: CircleAvatar(
                              backgroundColor: Colors.black54,
                              radius: 10,
                              child: Center(
                                child: Icon(
                                  Icons.more_horiz,
                                  color: Colors.white,
                                  size: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          minVerticalPadding: 0,
                          title: Text(
                            '#Leo',
                            style: TextStyle(
                                color: Colors.blue[300],
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Thalapathy vijay | Lokesh Kanagaraj | Ani...',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'more',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '2,00,000 views',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      'jan 11 / 2023',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(54, 158, 158, 158),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                height: mediaquery.height * 0.06,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: SizedBox(
                                        height: 35,
                                        width: 35,
                                        child: Image.asset(
                                          "images/icons/Group 9543.png",
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        '110k',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(54, 158, 158, 158),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                height: mediaquery.height * 0.06,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: SizedBox(
                                        height: 35,
                                        width: 35,
                                        child: Image.asset(
                                          "images/icons/heartbroke.png",
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        '10k',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(54, 158, 158, 158),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                height: mediaquery.height * 0.06,
                                child: Center(
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(
                                      "images/icons/share.png",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(54, 158, 158, 158),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                height: mediaquery.height * 0.06,
                                child: Center(
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(
                                      "images/icons/notifications.png",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(54, 158, 158, 158),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              height: mediaquery.height * 0.21,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    visualDensity: VisualDensity(vertical: -3),
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.orange,
                                      radius: 22,
                                    ),
                                    title: Text(
                                      'TATA',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      '57k Subcribers',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    trailing: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: Colors.white),
                                        color:
                                            Color.fromARGB(54, 158, 158, 158),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      height: mediaquery.height * 0.04,
                                      width: 65,
                                      child: Center(
                                        child: Text(
                                          'Subcribe',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    thickness: 0.4,
                                    color: Color.fromARGB(96, 158, 158, 158),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 17),
                                    child: Text(
                                      'comments  20k',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    visualDensity: VisualDensity(vertical: -3),
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.orange,
                                      radius: 18,
                                    ),
                                    title: Container(
                                      width: mediaquery.width * 0.8,
                                      child: Text(
                                        'the movie is directed by lokesh kanagaraj and music by aniruth',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ),
                        // Expanded(
                        //   child: ListView.builder(
                        //     physics: NeverScrollableScrollPhysics(),
                        //     shrinkWrap: true,
                        //     itemCount: thumnails.length,
                        //     itemBuilder: (context, index) {
                        //       return Padding(
                        //         padding:
                        //             const EdgeInsets.symmetric(vertical: 10),
                        //         child: Container(
                        //           decoration: BoxDecoration(
                        //             color: Colors.black,
                        //             boxShadow: [
                        //               BoxShadow(
                        //                   color: Colors.grey.withOpacity(0.1),
                        //                   spreadRadius: 3,
                        //                   blurRadius: 7,
                        //                   offset: const Offset(0, 4))
                        //             ],
                        //             borderRadius: const BorderRadius.all(
                        //               Radius.circular(15),
                        //             ),
                        //           ),
                        //           height: mediaquery.height * 0.4,
                        //           child: Column(
                        //             children: [
                        //               Flexible(
                        //                   flex: 7,
                        //                   child: Stack(
                        //                     alignment: Alignment.center,
                        //                     children: [
                        //                       ClipRRect(
                        //                         borderRadius: BorderRadius.only(
                        //                             topLeft:
                        //                                 Radius.circular(15),
                        //                             topRight:
                        //                                 Radius.circular(15)),
                        //                         child: Container(
                        //                           decoration: BoxDecoration(
                        //                             borderRadius:
                        //                                 BorderRadius.only(
                        //                                     topLeft: Radius
                        //                                         .circular(15),
                        //                                     topRight:
                        //                                         Radius.circular(
                        //                                             15)),
                        //                             color: Colors.blue,
                        //                             image: DecorationImage(
                        //                                 image: FileImage(
                        //                                   File(
                        //                                       thumnails[index]),
                        //                                 ),
                        //                                 fit: BoxFit.cover),
                        //                           ),
                        //                           // child: VideoPlayer(
                        //                           //   _videoPlayerController,
                        //                           // ),
                        //                         ),
                        //                       ),
                        //                       InkWell(
                        //                         // onTap: () {
                        //                         //                  _videoPlayerController.play();
                        //                         //   setState(() {
                        //                         //     videoindex=index;
                        //                         //   });
                        //                         //   videogetter();
                        //                         // },
                        //                         child: SizedBox(
                        //                           height: 30,
                        //                           width: 30,
                        //                           child: SvgPicture.asset(
                        //                             'images/icons/Play.svg',
                        //                             height: 30,
                        //                             width: 30,
                        //                           ),
                        //                         ),
                        //                       ),
                        //                       Positioned(
                        //                         top: mediaquery.height * 0.03,
                        //                         right: mediaquery.width * 0.06,
                        //                         child: Container(
                        //                           padding: EdgeInsets.symmetric(
                        //                               horizontal: 3,
                        //                               vertical: 3),
                        //                           decoration: BoxDecoration(
                        //                             color: Colors.black54,
                        //                             borderRadius:
                        //                                 BorderRadius.all(
                        //                               Radius.circular(5),
                        //                             ),
                        //                           ),
                        //                           height: 15,
                        //                           width: 45,
                        //                           child: Center(
                        //                             child: Text(
                        //                               '1:00',
                        //                               style: TextStyle(
                        //                                   color: Colors.white,
                        //                                   fontSize: 8),
                        //                             ),
                        //                           ),
                        //                         ),
                        //                       ),
                        //                       Positioned(
                        //                         bottom:
                        //                             mediaquery.height * 0.015,
                        //                         right: mediaquery.width * 0.03,
                        //                         child: InkWell(
                        //                           onTap: () {
                        //                             Navigator.of(context)
                        //                                 .push(MaterialPageRoute(
                        //                               builder: (context) =>
                        //                                   FullScreen(index),
                        //                             ));
                        //                           },
                        //                           child: Container(
                        //                             decoration: BoxDecoration(
                        //                               color: Colors.black54,
                        //                               borderRadius:
                        //                                   BorderRadius.all(
                        //                                 Radius.circular(5),
                        //                               ),
                        //                             ),
                        //                             height: 16,
                        //                             width: 16,
                        //                             child: Image.asset(
                        //                               "images/icons/fullscreen.png",
                        //                               fit: BoxFit.contain,
                        //                             ),
                        //                           ),
                        //                         ),
                        //                       ),
                        //                     ],
                        //                   )),
                        //               Flexible(
                        //                   flex: 4,
                        //                   child: Column(
                        //                     children: [
                        //                       SizedBox(
                        //                         height: 3,
                        //                       ),
                        //                       ListTile(
                        //                         visualDensity: VisualDensity(
                        //                             vertical: -3.3),
                        //                         leading: Padding(
                        //                           padding:
                        //                               const EdgeInsets.only(
                        //                                   top: 4),
                        //                           child: Container(
                        //                             height: mediaquery.height *
                        //                                 0.055,
                        //                             width:
                        //                                 mediaquery.width * 0.1,
                        //                             decoration: BoxDecoration(
                        //                               color: Colors.amber,
                        //                               borderRadius:
                        //                                   BorderRadius.all(
                        //                                       Radius.elliptical(
                        //                                           180, 140)),
                        //                             ),
                        //                           ),
                        //                         ),
                        //                         title: Padding(
                        //                           padding:
                        //                               const EdgeInsets.only(
                        //                                   bottom: 3),
                        //                           child: Text(
                        //                             'Introducing AVINIYA concept EV 1A new paradigm of innovation ',
                        //                             style: TextStyle(
                        //                               color: Colors.white,
                        //                               fontSize: 10,
                        //                             ),
                        //                           ),
                        //                         ),
                        //                         subtitle: Text(
                        //                           'Tata Motors Car ',
                        //                           style: TextStyle(
                        //                             color: Colors.white,
                        //                             fontSize: 10,
                        //                           ),
                        //                         ),
                        //                         trailing: Padding(
                        //                           padding:
                        //                               const EdgeInsets.only(
                        //                                   left: 10, bottom: 40),
                        //                           child: Container(
                        //                             height: 25,
                        //                             width: 25,
                        //                             child: Icon(
                        //                               Icons.more_horiz,
                        //                               size: 20,
                        //                               color: Colors.white,
                        //                             ),
                        //                           ),
                        //                         ),
                        //                       ),
                        //                       Divider(
                        //                         thickness: 0.4,
                        //                         color: Color.fromARGB(
                        //                             96, 158, 158, 158),
                        //                       ),
                        //                       Row(
                        //                         mainAxisAlignment:
                        //                             MainAxisAlignment.start,
                        //                         children: [
                        //                           Padding(
                        //                             padding:
                        //                                 const EdgeInsets.only(
                        //                                     left: 10),
                        //                             child: Container(
                        //                               child: Row(
                        //                                 children: [
                        //                                   SizedBox(
                        //                                     height: 30,
                        //                                     width: 30,
                        //                                     child: Center(
                        //                                       child:
                        //                                           Image.asset(
                        //                                         'images/icons/Group 9543.png',
                        //                                         fit: BoxFit
                        //                                             .contain,
                        //                                       ),
                        //                                     ),
                        //                                   ),
                        //                                   SizedBox(
                        //                                     width: 10,
                        //                                   ),
                        //                                   Padding(
                        //                                     padding:
                        //                                         EdgeInsets.only(
                        //                                             left: 6),
                        //                                     child: SizedBox(
                        //                                       height: 30,
                        //                                       width: 30,
                        //                                       child: Center(
                        //                                         child:
                        //                                             SvgPicture
                        //                                                 .asset(
                        //                                           "images/icons/Send.svg",
                        //                                           fit: BoxFit
                        //                                               .cover,
                        //                                         ),
                        //                                       ),
                        //                                     ),
                        //                                   )
                        //                                 ],
                        //                               ),
                        //                             ),
                        //                           ),
                        //                           Spacer(),
                        //                           Padding(
                        //                             padding:
                        //                                 const EdgeInsets.only(
                        //                                     left: 10),
                        //                             child: Container(
                        //                               child: Row(
                        //                                 children: [
                        //                                   SizedBox(
                        //                                     height: 25,
                        //                                     width: 25,
                        //                                     child: Center(
                        //                                       child:
                        //                                           Image.asset(
                        //                                         "images/icons/link.png",
                        //                                         fit: BoxFit
                        //                                             .contain,
                        //                                       ),
                        //                                     ),
                        //                                   ),
                        //                                   SizedBox(
                        //                                     width: 15,
                        //                                   ),
                        //                                   Padding(
                        //                                     padding:
                        //                                         EdgeInsets.only(
                        //                                             left: 6),
                        //                                     child: SizedBox(
                        //                                       height: 25,
                        //                                       width: 25,
                        //                                       child: Center(
                        //                                         child:
                        //                                             Image.asset(
                        //                                           "images/icons/share.png",
                        //                                           fit: BoxFit
                        //                                               .contain,
                        //                                         ),
                        //                                       ),
                        //                                     ),
                        //                                   )
                        //                                 ],
                        //                               ),
                        //                             ),
                        //                           )
                        //                         ],
                        //                       )
                        //                     ],
                        //                   )),
                        //             ],
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // )
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
