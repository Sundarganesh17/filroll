import 'package:camera/camera.dart';
import 'package:filroll_app/screens/post/post_page.dart';
import 'package:filroll_app/screens/post/post_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

// List<CameraDescription>? _cameras;

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   _cameras = await availableCameras();
// }

class CameraPage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  CameraPage({this.cameras});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  XFile? choosedFile;
  XFile? pictureFile;

  Future<void> _takePicture() async {
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (imageFile != null)
      setState(() {
        choosedFile = imageFile;
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => PostPage(imageFile)));
      });
  }

  // CameraController _cameraController =
  //     CameraController(_cameras!.first, ResolutionPreset.medium);

  PageController _pageController =
      PageController(initialPage: 0, viewportFraction: 0.2);
  int _selectedTab = 1;

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras![0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    controller.dispose();
    // _cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isVideo = false;
    final size = MediaQuery.of(context).size;
    final List<String> cameraType = ['Photo', 'Video'];
    TextStyle style = Theme.of(context).textTheme.bodyText1!.copyWith(
        fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold);
    if (!controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
          height: size.height,
          child: CameraPreview(
            controller,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 10, vertical: size.height * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          color: Colors.white,
                          iconSize: 30,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.close)),
                      IconButton(
                          color: Colors.white,
                          iconSize: 30,
                          onPressed: () {},
                          icon: Icon(Icons.crop_rotate_rounded)),
                    ],
                  ),
                ),
                Spacer(),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        height: 28,
                        width: 28,
                        child: InkWell(
                            child: SvgPicture.asset(
                              "images/icons/Image.svg",
                              fit: BoxFit.fill,
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            }),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: GestureDetector(
                            child: const CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 28,
                            ),
                            //onLongPress: controller.startVideoRecording();,
                            onTap: () async {
                              pictureFile = await controller.takePicture();
                              setState(() {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        PostPage(pictureFile!)));
                              });
                            },
                          )),
                      const SizedBox(
                        width: 15,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon:
                            const Icon(Icons.sentiment_satisfied_alt_outlined),
                        iconSize: 35,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    SizedBox(
                      height: 45,
                      child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (int page) => {
                                setState(() async {
                                  _selectedTab = page;
                                  await availableCameras().then((value) =>
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  VideoPage(cameras: value))));
                                })
                              },
                          itemCount: cameraType.length,
                          itemBuilder: ((context, index) {
                            return Container(
                              margin: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              width: 53,
                              height: 17,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                cameraType[index],
                                style: style.copyWith(
                                    color: _selectedTab == index
                                        ? Colors.black
                                        : Colors.black),
                              ),
                            );
                          })),
                    ),
                    Container(
                      width: 50,
                      height: 45,
                      alignment: Alignment.bottomCenter,
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 2.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class VideoPage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  VideoPage({this.cameras});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  bool isRecording = false;
  CameraController? controller;
  XFile? VideoFile;
  XFile? choosedFile;
  Future<void> _takePicture() async {
    final file = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );
    if (file != null)
      setState(() {
        choosedFile = file;
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => VideoDemo(
                  pickedFile: choosedFile!,
                )));
      });
  }

  PageController _pageController =
      PageController(initialPage: 1, viewportFraction: 0.2);
  int _selectedTab = 1;

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras![0], ResolutionPreset.max);
    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    controller!.dispose();
    // _cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final List<String> cameraType = ['Photo', 'Video'];
    TextStyle style = Theme.of(context).textTheme.bodyText1!.copyWith(
        fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold);
    if (!controller!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
          height: size.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: 1.5,
                alignment: Alignment.center,
                child: CameraPreview(
                  controller!,
                ),
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 10, vertical: size.height * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            color: Colors.white,
                            iconSize: 30,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.close)),
                        IconButton(
                            color: Colors.white,
                            iconSize: 30,
                            onPressed: () {},
                            icon: const Icon(Icons.crop_rotate_rounded)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          height: 28,
                          width: 28,
                          child: InkWell(
                              // ignore: sort_child_properties_last
                              child: SvgPicture.asset(
                                "images/icons/Image.svg",
                                fit: BoxFit.fill,
                              ),
                              onTap: _takePicture),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        isRecording
                            ? Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: GestureDetector(
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 28,
                                  ),
                                  onTap: () async {
                                    setState(() {
                                      isRecording = !isRecording;
                                    });
                                    await controller!
                                        .stopVideoRecording()
                                        .then((XFile? file) {
                                      if (mounted) {
                                        setState(() {});
                                      }
                                      if (file != null) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) => VideoDemo(
                                                    pickedFile: file)));
                                      }
                                    });
                                    // setState(() {
                                    //   Navigator.of(context).push(
                                    //       MaterialPageRoute(
                                    //           builder: (context) =>
                                    //               PostPage(VideoFile!)));
                                    // });
                                  },
                                ))
                            : Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: GestureDetector(
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 28,
                                  ),
                                  onTap: () async {
                                    setState(() {
                                      isRecording = !isRecording;
                                    });
                                    await controller!.startVideoRecording();
                                  },
                                )),
                        const SizedBox(
                          width: 15,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                              Icons.sentiment_satisfied_alt_outlined),
                          iconSize: 35,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      SizedBox(
                        height: 45,
                        child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: (int page) => {
                                  setState(() async {
                                    _selectedTab = page;
                                    await availableCameras().then((value) =>
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CameraPage(
                                                        cameras: value))));
                                  })
                                },
                            itemCount: cameraType.length,
                            itemBuilder: ((context, index) {
                              return Container(
                                margin: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                width: 53,
                                height: 17,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  cameraType[index],
                                  style: style.copyWith(
                                      color: _selectedTab == index
                                          ? Colors.black
                                          : Colors.black),
                                ),
                              );
                            })),
                      ),
                      Container(
                        width: 50,
                        height: 45,
                        alignment: Alignment.bottomCenter,
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 2.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
