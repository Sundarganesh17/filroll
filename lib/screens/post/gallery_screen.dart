import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:filroll_app/providers/add_post.dart';
import 'package:filroll_app/screens/post/post_page.dart';
import 'package:filroll_app/screens/post/video_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_storage_path/flutter_storage_path.dart';
import 'package:get/get.dart';
import 'package:filroll_app/screens/post/gallery_model.dart';
import 'package:provider/provider.dart';
import 'camera_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GalleryScreen extends StatefulWidget {
  int imageindex;
  GalleryScreen({required this.imageindex});
  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<FileModel> files = <FileModel>[];
  FileModel selectedModel = FileModel(imagefile: [], folderName: '');
  String image = '';
  List<String> image1 = [];
  static int _count = 1;
  List<bool> _checks = [];
  int pagechangeindex = 0;
  List<int> num = [];
  //for video screen
  List<dynamic> videofiles = [];
  List<String> foldernames = [];
  List<dynamic> selectedFolder = [];
  String selectedFoldername = '';
  @override
  void initState() {
    super.initState();
    getImagesPath(0);
  }

  getImagesPath(int i) async {
    var imagePath = await StoragePath.imagesPath;
    var images = jsonDecode(imagePath!) as List;
    files = images.map<FileModel>((e) => FileModel.fromJson(e)).toList();
    if (files != null && files.length > 0)
      setState(() {
        selectedModel = files[i];
        image = files[i].imagefile[0];
        _count = files[i].imagefile.length;
      });
    _checks = List.generate(_count, (index) => false);
    num = List.generate(_count, (index) => 0);
    // print(_checks);
  }

  List<DropdownMenuItem<FileModel>> getdropdownitem() {
    return files
        .map(
          (e) => DropdownMenuItem(
            child: Row(
              children: [
                Text(
                  e.folderName,
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
            value: e,
          ),
        )
        .toList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    image1 = [];
  }

  @override
  Widget build(BuildContext context) {
    final mediaqurey = MediaQuery.of(context).size;
    final provideerdata = Provider.of<Addpost>(context);
    void savefolder() {
      // selectedModel=FileModel[provideerdata.selectedfolder];
    }
    return SafeArea(
      child: Scaffold(
        // floatingActionButton: IconButton(
        //     onPressed: () {
        //       Navigator.of(context).push(MaterialPageRoute(
        //         builder: (context) => VideoScreen(),
        //       ));
        //     },
        //     icon: Icon(
        //       Icons.video_collection_outlined,
        //       color: Colors.amber,
        //       size: 40,
        //     )),
        // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: mediaqurey.height * 0.55,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    if (image1 != null)
                      Stack(
                        children: [
                          Container(
                              child: CarouselSlider.builder(
                            itemCount: image1.length,
                            options: CarouselOptions(
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    pagechangeindex = index;
                                  });
                                },
                                enlargeStrategy:
                                    CenterPageEnlargeStrategy.height,
                                viewportFraction: 1,
                                enableInfiniteScroll: false,
                                height: mediaqurey.height),
                            itemBuilder: (context, index, realIndex) {
                              return Container(
                                width: mediaqurey.width,
                                margin: EdgeInsets.zero,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: FileImage(
                                      File(image1[pagechangeindex])),
                                  fit: BoxFit.cover,
                                )),
                              );
                            },
                          )),
                          Positioned(
                            bottom: 40,
                            left: (image1.length > 3)
                                ? mediaqurey.width * 0.46
                                : mediaqurey.width * 0.5,
                            child: Center(
                              child: Row(
                                children: [
                                  AnimatedSmoothIndicator(
                                    activeIndex: pagechangeindex,
                                    count: image1.length,
                                    effect: ScrollingDotsEffect(
                                        dotHeight: 6,
                                        dotWidth: 6,
                                        activeDotColor: Colors.blueAccent,
                                        dotColor: Color.fromARGB(
                                            126, 158, 158, 158)),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    if (image1.isEmpty)
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: FileImage(File(image)),
                          fit: BoxFit.cover,
                        )),
                      ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white54,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6))),
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
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PostPage(XFile(
                                                image,
                                              ))));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6))),
                                    child: Icon(
                                      Icons.done,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      useRootNavigator: true,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15))),
                                      backgroundColor: Colors.black,
                                      enableDrag: true,
                                      isDismissible: true,
                                      context: context,
                                      builder:
                                          (context) =>
                                              DraggableScrollableSheet(
                                                initialChildSize: 0.98,
                                                expand: false,
                                                builder: (context,
                                                        scrollController) =>
                                                    SingleChildScrollView(
                                                  controller:
                                                      scrollController,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.of(
                                                                  context)
                                                              .pop();
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Center(
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .grey,
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(3))),
                                                              height: 5,
                                                              width: 40,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                      top: 10,
                                                                left: 20),
                                                        child: InkWell(
                                                          onTap: (){
                                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoScreen(),));
                                                          },
                                                          child: SizedBox(
                                                            width: mediaqurey.width,
                                                            child: Text(
                                                              'Videos',
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 16,
                                                                ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                     
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 20),
                                                        child:
                                                            ListView.builder(
                                                                physics:
                                                                    NeverScrollableScrollPhysics(),
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount: files
                                                                    .length,
                                                                itemBuilder:
                                                                    (context,
                                                                            index) =>
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(top: 30),
                                                                          child:
                                                                              GestureDetector(
                                                                            onTap: () {
                                                                              setState(() {
                                                                                getImagesPath(index);
                                                                                Navigator.of(context).pop();
                                                                                print('number:${files.length}');
                                                                              });
                                                                            },
                                                                            child: Container(
                                                                              width: mediaqurey.width * 0.6,
                                                                              child: Text(
                                                                                files[index].folderName,
                                                                                style: TextStyle(color: Colors.white, fontSize: 16),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )),
                                                      ),
                                                      SizedBox(height: 20,),
                                                    ],
                                                  ),
                                                ),
                                              ));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15,
                                  ),
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: 11, bottom: 1),
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    child: Row(
                                      children: [
                                        Text(
                                          selectedModel.folderName,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 7),
                                          child: Icon(
                                            Icons
                                                .keyboard_arrow_down_outlined,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () async {
                                  await availableCameras().then((value) =>
                                      Get.to(CameraPage(cameras: value),
                                          transition: Transition.downToUp));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Container(
                                      padding: EdgeInsets.all(7),
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Image.asset(
                                        'images/icons/Shape.png',
                                        fit: BoxFit.contain,
                                      )),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 0.5),
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: selectedModel.imagefile.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, i) {
                    var n;
                    var file = selectedModel.imagefile[i];
                    if (image1.contains(file)) {
                      _checks[i] = true;
                      n = image1.indexWhere(
                        (element) {
                          if (element == file) {
                            return true;
                          }
                          return false;
                        },
                      );
                      num[i] = n + 1;
                      print(num[i]);
                    }
                    return InkWell(
                      onTap: () {
                        setState(() {
                          image = file;
                          if (image1.contains(file)) {
                            image1.remove(file);
                            pagechangeindex = image1.length - 1;
                            print('iamge1 ${image1}');
                            _checks[i] = !_checks[i];
                          } else if (image1.length <= 4) {
                            image1.add(file);
                            pagechangeindex = image1.length - 1;
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'You can add only five pictures at a time')));
                          }
                          // print(image1);
                          // print(_checks.toString());
                        });
                        n = image1.indexWhere(
                          (element) {
                            if (element == file) {
                              return true;
                            }
                            return false;
                          },
                        );
                        setState(() {
                          num[i] = n + 1;
                          // print(num[i]);
                        });
                      },
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: _checks[i]
                                    ? Border.all(
                                        color: Colors.blue, width: 0.7)
                                    : Border.all(width: 0)),
                            child: Image.file(
                              File(file),
                              height: mediaqurey.height * 0.8,
                              width: mediaqurey.width,
                              cacheHeight: 140,
                              cacheWidth: 140,
                              fit: BoxFit.fill,
                            ),
                          ),
                          if (image1.contains(file))
                            Container(
                              color: Colors.white.withOpacity(0.4),
                            ),
                          Positioned(
                            top: 6,
                            right: 8,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white, width: 0.4),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: CircleAvatar(
                                radius: 8,
                                backgroundColor: num[i] != 0
                                    ? Colors.blue
                                    : Colors.black26,
                                child: FittedBox(
                                  child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        num[i] != 0 ? num[i].toString() : '',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20),
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // if(selectedBytes!=null)
              //    ListView.builder(
              //   shrinkWrap: true,
              //   physics: NeverScrollableScrollPhysics(),
              //   itemBuilder: (context, index) {
              //     SelectedByte selectedByte = selectedBytes[index];
              //     if (selectedByte.isThatImage) {
              //       return SizedBox(
              //         width: double.infinity,
              //         child: Image.file(selectedByte.selectedFile),
              //       );
              //     }return CircularProgressIndicator();
              //   },
              //   itemCount:selectedBytes.length,
              // ),
              //  ListView.builder(
              //   shrinkWrap: true,
              //   physics: NeverScrollableScrollPhysics(),
              //     itemCount: _exPath.length,
              //     itemBuilder: (context, index) {
              //       return Center(child: Text("${_exPath[index]}"));
              //     }),
            ],
          ),
        ),
      ),
    );
  }
}
