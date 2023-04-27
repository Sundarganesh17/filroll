import 'dart:convert';
import 'dart:io';
import 'package:filroll_app/screens/post/gallery_screen.dart';
import 'package:filroll_app/screens/post/video_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_storage_path/flutter_storage_path.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'gallery_model.dart';

class VideoScreen extends StatefulWidget {
  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  List<dynamic> videofiles = [];
  List<String> video = [];
  List<Uint8List> thumbnailpath = [];
  List<String> foldernames = [];
  List<dynamic> selectedFolder = [];
  String? selectedvideo;
  String selectedFoldername = '';
  VideoPlayerController? _videoPlayerController;
  // for imagescreen
  List<FileModel> files = <FileModel>[];
  FileModel selectedModel = FileModel(imagefile: [], folderName: '');
  @override
  void initState() {
    super.initState();
    getVideoPath();
  }

  void videogetter()async {
    _videoPlayerController = VideoPlayerController.file(File(selectedvideo!))
      ..addListener(() {
        setState(() {
          
        });
      })
      ..setLooping(false)
      ..initialize().then((_) => _videoPlayerController!.play());
  }

  Future<Uint8List> getThumbnail(String videoPath) async {
    final thumbnailFile = await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.PNG,
      maxWidth:
          128, // specify the width of the thumbnail, in this case 128 pixels
      quality: 50, // specify the quality of the thumbnail, from 0 to 100
    );

    return thumbnailFile!;
  }
  Future<String> getVideoPath() async {
    String videoPath = "";
    try {
     
      var f = 0;
      var t = 0;
      var a=0;
      videoPath = (await StoragePath.videoPath)!;
      var response = jsonDecode(videoPath) as List;
      videofiles = response;
      if (videofiles.isNotEmpty && videofiles.length > 0) {
       
        selectedFoldername = videofiles[0]['folderName'];
        video.clear();
         for(a;a<videofiles.length;a++){
           selectedFolder = videofiles[a]['files'];
            var s = 0;
        for (s; s < selectedFolder.length; s++) {
          var path = selectedFolder[s]['path'];
          video.add(path);
        }}
        print(video);
        selectedvideo = video[0];
        foldernames.clear();
        for (f; f < videofiles.length; f++) {
          var folder = videofiles[f]['folderName'];
          foldernames.add(folder);
        }
        thumbnailpath.clear();
        for (t; t < video.length; t++) {
          var paths = await getThumbnail(video[t]);
          thumbnailpath.add(paths);
        }
      
      videogetter();
      }
      print('video $thumbnailpath');
    } on PlatformException {
      videoPath = 'Failed to get path';
    }
    return videoPath;
  }

  Widget playpause() => _videoPlayerController!.value.isPlaying
      ? Container()
      : GestureDetector(
          onTap: () {
            _videoPlayerController!.play();
          },
          child: Container(
            color: Colors.white.withOpacity(0.1),
            child: Center(
                child: Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 34,
            )),
          ),
        );
  @override
  void dispose() {
    _videoPlayerController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaqurey = MediaQuery.of(context).size;
    return (_videoPlayerController == null)
        ? Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
             Text('just a sec..',style: TextStyle(color: Colors.white,fontSize: 10),)
          ],
        ))
        : SafeArea(
            child: Scaffold(
                  backgroundColor: Colors.black,
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.black,
                            height: mediaqurey.height * 0.55,
                            child: Stack(
                              children: [
                                _videoPlayerController!.value.isInitialized
                                    ? GestureDetector(
                                        onTap: () => _videoPlayerController!
                                                .value.isPlaying
                                            ? _videoPlayerController!.pause()
                                            : _videoPlayerController!.play(),
                                        child: Center(
                                            child: Container(
                                          child: AspectRatio(
                                            aspectRatio: _videoPlayerController!
                                                .value.aspectRatio,
                                            child: Stack(
                                              alignment: Alignment.bottomCenter,
                                              children: <Widget>[
                                                VideoPlayer(
                                                    _videoPlayerController!),
                                              ],
                                            ),
                                          ),
                                        )),
                                      )
                                    : Center(
                                        child: CircularProgressIndicator()),
                                playpause(),
                                //     decoration: BoxDecoration(
                                //         image: DecorationImage(
                                //       image: FileImage(File(image)),
                                //       fit: BoxFit.cover,
                                //     )),
                                //   ),
                                // ),
                                //  _videoPlayerController!.value.isPlaying?Container():Center(child: Icon(Icons.play_arrow,color: ,),)
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white54,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                6))),
                                                height: 25,
                                                width: 25,
                                                child: Icon(
                                                  Icons.arrow_back_sharp,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          InkWell(
                                            onTap: () {
                                              // Navigator.of(context).push(
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             PostPage(XFile(
                                              //               image,
                                              //             ))));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: InkWell(
                                                onTap: (){
                                                   Navigator.of(context).push(MaterialPageRoute(builder: (context) =>VideoEditingScreen(selectedvideo),));
                                                },
                                                child: Container(
                                                  height: 25,
                                                  width: 25,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  6))),
                                                  child: Icon(
                                                    Icons.done,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        children: [
                                          // InkWell(
                                          //   onTap: () {
                                          //     showModalBottomSheet(
                                          //         useRootNavigator: true,
                                          //         shape: RoundedRectangleBorder(
                                          //             borderRadius:
                                          //                 BorderRadius.only(
                                          //                     topLeft: Radius
                                          //                         .circular(15),
                                          //                     topRight: Radius
                                          //                         .circular(
                                          //                             15))),
                                          //         backgroundColor: Colors.black,
                                          //         enableDrag: true,
                                          //         isDismissible: true,
                                          //         context: context,
                                          //         builder: (context) =>
                                          //             DraggableScrollableSheet(
                                          //               initialChildSize: 0.98,
                                          //               expand: false,
                                          //               builder: (context,
                                          //                       scrollController) =>
                                          //                   SingleChildScrollView(
                                          //                 controller:
                                          //                     scrollController,
                                          //                 child: Column(
                                          //                   crossAxisAlignment:
                                          //                       CrossAxisAlignment
                                          //                           .start,
                                          //                   children: [
                                          //                     InkWell(
                                          //                       onTap: () {
                                          //                         Navigator.of(
                                          //                                 context)
                                          //                             .pop();
                                          //                       },
                                          //                       child: Padding(
                                          //                         padding:
                                          //                             const EdgeInsets
                                          //                                     .all(
                                          //                                 10.0),
                                          //                         child: Center(
                                          //                           child:
                                          //                               Container(
                                          //                             decoration: BoxDecoration(
                                          //                                 color: Colors
                                          //                                     .grey,
                                          //                                 borderRadius:
                                          //                                     BorderRadius.all(Radius.circular(3))),
                                          //                             height: 5,
                                          //                             width: 40,
                                          //                           ),
                                          //                         ),
                                          //                       ),
                                          //                     ),
                                          //                     Padding(
                                          //                       padding: const EdgeInsets.only(left: 20),
                                          //                       child: Text(
                                          //                         'Video Folders',
                                          //                         style: TextStyle(
                                          //                             color: Color.fromRGBO(3, 169, 244, 1),
                                          //                             fontSize:
                                          //                                 18,
                                          //                             fontWeight:
                                          //                                 FontWeight
                                          //                                     .bold),
                                          //                       ),
                                          //                     ),
                                          //                     Padding(
                                          //                       padding:
                                          //                           const EdgeInsets
                                          //                                   .only(
                                          //                               left:
                                          //                                   20),
                                          //                       child: ListView
                                          //                           .builder(
                                          //                               physics:
                                          //                                   NeverScrollableScrollPhysics(),
                                          //                               shrinkWrap:
                                          //                                   true,
                                          //                               itemCount:
                                          //                                   foldernames
                                          //                                       .length,
                                          //                               itemBuilder: (context,
                                          //                                       index) =>
                                          //                                   Padding(
                                          //                                     padding: const EdgeInsets.only(top: 30),
                                          //                                     child: GestureDetector(
                                          //                                       onTap: () async {
                                          //                                         var t = 0;
                                          //                                         getVideoPath(index).then((_) => Navigator.of(context).pop());
                                                                                 
                                          //                                       },
                                          //                                       child: Container(
                                          //                                         width: mediaqurey.width * 0.6,
                                          //                                         child: Text(
                                          //                                           foldernames[index],
                                          //                                           style: TextStyle(color: Colors.white, fontSize: 16),
                                          //                                         ),
                                          //                                       ),
                                          //                                     ),
                                          //                                   )),
                                          //                     ),
                                          //                     SizedBox(
                                          //                       height: 20,
                                          //                     ),
                                          //                     Padding(
                                          //                       padding:
                                          //                           const EdgeInsets
                                          //                                   .only(
                                          //                               left:
                                          //                                   20),
                                          //                       child: Text(
                                          //                         'Image Folders',
                                          //                         style: TextStyle(
                                          //                             color: Colors
                                          //                                 .lightBlue,
                                          //                             fontSize:
                                          //                                 18,
                                          //                             fontWeight:
                                          //                                 FontWeight
                                          //                                     .bold),
                                          //                       ),
                                          //                     ),
                                          //                     Padding(
                                          //                       padding:
                                          //                           const EdgeInsets
                                          //                                   .only(
                                          //                               left:
                                          //                                   20),
                                          //                       child: ListView
                                          //                           .builder(
                                          //                               physics:
                                          //                                   NeverScrollableScrollPhysics(),
                                          //                               shrinkWrap:
                                          //                                   true,
                                          //                               itemCount:
                                          //                                   files
                                          //                                       .length,
                                          //                               itemBuilder: (context,
                                          //                                       index) =>
                                          //                                   Padding(
                                          //                                     padding: const EdgeInsets.only(top: 30),
                                          //                                     child: GestureDetector(
                                          //                                       onTap: () {
                                          //                                         setState(() {
                                          //                                           Navigator.of(context).pushReplacement(MaterialPageRoute(
                                          //                                             builder: (context) => GalleryScreen(imageindex: index,),
                                          //                                           ));
                                          //                                         });
                                          //                                       },
                                          //                                       child: Container(
                                          //                                         width: mediaqurey.width * 0.6,
                                          //                                         child: Text(
                                          //                                           files[index].folderName,
                                          //                                           style: TextStyle(color: Colors.white, fontSize: 16),
                                          //                                         ),
                                          //                                       ),
                                          //                                     ),
                                          //                                   )),
                                          //                     ),
                                          //                     SizedBox(height: 20,)
                                          //                   ],
                                          //                 ),
                                          //               ),
                                          //             ));
                                          //   },
                                          //   child: Padding(
                                          //     padding: const EdgeInsets.only(
                                          //       left: 15,
                                          //     ),
                                          //     child: Container(
                                          //       padding: EdgeInsets.only(
                                          //           left: 11, bottom: 1),
                                          //       height: 30,
                                          //       decoration: BoxDecoration(
                                          //           color: Colors.black,
                                          //           borderRadius:
                                          //               BorderRadius.all(
                                          //                   Radius.circular(
                                          //                       12))),
                                          //       child: Row(
                                          //         children: [
                                          //           Text(
                                          //             selectedFoldername,
                                          //             style: TextStyle(
                                          //                 color: Colors.white,
                                          //                 fontSize: 12),
                                          //           ),
                                          //           SizedBox(
                                          //             width: 5,
                                          //           ),
                                          //           Padding(
                                          //             padding:
                                          //                 const EdgeInsets.only(
                                          //                     right: 7),
                                          //             child: Icon(
                                          //               Icons
                                          //                   .keyboard_arrow_down_outlined,
                                          //               size: 18,
                                          //               color: Colors.white,
                                          //             ),
                                          //           )
                                          //         ],
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                          Spacer(),
                                          InkWell(
                                            onTap: () async {
                                              // await availableCameras().then((value) => Get.to(
                                              //     CameraPage(cameras: value),
                                              //     transition: Transition.downToUp));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Container(
                                                  padding: EdgeInsets.all(7),
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  child: Image.asset(
                                                    'images/icons/Shape.png',
                                                    fit: BoxFit.contain,
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Column(
                          //   children: [
                          //     ListView.builder(
                          //       shrinkWrap: true,
                          //       itemCount: video.length,
                          //       itemBuilder: (context, index) {
                          //       return Container(child: Text(video[index],style: TextStyle(color: Colors.blue),),);
                          //     },),
                          //   ],
                          // )
                          !_videoPlayerController!.value.isInitialized
                              ? SizedBox(
                                  height: 300,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ))
                              : Container(
                                  child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: video.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3),
                                    itemBuilder: (context, index) {
                                      var file = video[index];
                                      return InkWell(
                                        onTap: () async {
                                          setState(() {
                                            selectedvideo = file;
                                            print('video1 $selectedvideo');
                                            videogetter();
                                          });
                                        },
                                        child: thumbnailpath == null
                                            ? Container()
                                            : Container(
                                                color: Colors.black,
                                                child: Image.memory(
                                                  thumbnailpath[index],
                                                  height:
                                                      mediaqurey.height * 0.7,
                                                  width: mediaqurey.width * 0.7,
                                                  cacheHeight: 140,
                                                  //  mediaqurey.height.toInt(),
                                                  cacheWidth: 140,
                                                  // mediaqurey.width.toInt(),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                      );
                                    },
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),
          );
  }
}
