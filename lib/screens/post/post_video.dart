import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/model/post_model.dart';
import 'package:filroll_app/providers/post.dart';
import 'package:filroll_app/providers/story.dart';
import 'package:filroll_app/screens/feed/home_screen.dart';
import 'package:filroll_app/screens/post/everyone_page.dart';
import 'package:filroll_app/screens/post/link.dart';
import 'package:filroll_app/screens/post/switch_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as vt;

class VideoDemo extends StatefulWidget {
  final XFile pickedFile;
  const VideoDemo({super.key, required this.pickedFile});

  @override
  State<VideoDemo> createState() => _VideoDemoState();
}

class _VideoDemoState extends State<VideoDemo> {
  String dpUrl = '';
  String dpUrl1 = '';
  String userName = '';
  String link = '';
  bool isPrivate = false;
  List? followers;
  String? postAutoId;
  File? videoFile;
  VideoPlayerController? controller;
  VoidCallback? videoPlayerListener;
  bool isLoading = false;
  int? _value = 1;
  int? _value1;
  bool isSelect = false;
  bool isPost = false;
  bool isStory = false;
  final _formKey = GlobalKey<FormState>();
  final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  final captionController = TextEditingController();
  final locationController = TextEditingController();
  final videoUrlController = TextEditingController();
  final List hashTags = [];
  String? thumbnail = '';
  bool isLoading1 = true;

  @override
  void initState() {
    super.initState();
    getDp();
    controllerInitiation();
  }

  void controllerInitiation() {
    controller = VideoPlayerController.file(File(widget.pickedFile.path))
      ..addListener(
        () => setState(() {}),
      )
      ..setLooping(true)
      ..initialize().then((_) => controller!.play());
  }

  void getDp() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .get();
    var dp = await getUrl('dp-${currentUserUid}.jpg');

    setState(() {
      dpUrl = dp;
      dpUrl1 = (snap.data() as Map<String, dynamic>)['DPUrl'];
      userName = (snap.data() as Map<String, dynamic>)['username'];
      isPrivate = (snap.data() as Map<String, dynamic>)['isPrivate'];
      followers = (snap.data() as Map<String, dynamic>)['followers'];
      postAutoId = const Uuid().v1();
      isLoading1 = false;
    });
  }

  Future<void> _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      if (captionController.text.contains('www.')) {
        var sp = captionController.text.split(' ');
        var er = sp.where((value) => value.contains('.com'));
        hashTags.add(er);
        var s = hashTags.first;
        print(s);
        for (final element in s) {
          setState(() {
            link = element;
          });
        }
      }
      var createPost = PostModel(
          postId: postAutoId!,
          postUrl: videoUrlController.text,
          caption: captionController.text,
          location: locationController.text,
          uid: currentUserUid,
          userName: userName,
          dpUrl: dpUrl,
          dateTime: DateTime.now(),
          isVideo: true,
          link: link,
          likes: [],
          views: [],
          thumbnail: thumbnail!,
          isPrivate: isPrivate);

      await Provider.of<Post>(context, listen: false)
          .uploadPost(createPost, postAutoId!);
      if (_value1 == 2) {
        // ignore: use_build_context_synchronously
        await Provider.of<Story>(context, listen: false).uploadStory(
            videoUrlController.text, userName, dpUrl, const Uuid().v1(), true);
      }
    }
  }

  Future<String> UploadThumbFile(String path) async {
    try {
      final UploadFileResult result = await Amplify.Storage.uploadFile(
        local: File(path),
        key: 'thumb-$postAutoId.jpg',
        options: S3UploadFileOptions(
          accessLevel: StorageAccessLevel.guest,
        ),
      );
      return result.key;
    } on StorageException catch (e) {
      print('Error uploading file: $e');
      throw e;
    }
  }

  Future<String> UploadFile() async {
    try {
      final UploadFileResult result = await Amplify.Storage.uploadFile(
        local: File(videoFile!.path),
        key: 'postVdo-$postAutoId.mp4',
        options: S3UploadFileOptions(
          accessLevel: StorageAccessLevel.guest,
        ),
      );
      return result.key;
    } on StorageException catch (e) {
      print('Error uploading file: $e');
      throw e;
    }
  }

  Future<String> getUrl(String key) async {
    try {
      final result = await Amplify.Storage.getUrl(key: key);
      return result.url;
    } catch (e) {
      throw e;
    }
  }

  Future<void> selectPictureFromCameraScreen() async {
    try {
      var tn = await vt.VideoThumbnail.thumbnailFile(
          video: videoFile!.path,
          thumbnailPath: (await getTemporaryDirectory()).path,
          imageFormat: vt.ImageFormat.PNG);
      var imageKey = await UploadThumbFile(tn!);
      thumbnail = imageKey;
      var imageKey1 = await UploadFile();
      videoUrlController.text = imageKey1;
      // thumbnail = await FileStorage()
      //     .uploadPostImage('thumbnails', File(tn!), postAutoId!);
      // videoUrlController.text =
      //     await FileStorage().uploadPostImage('posts', videoFile!, postAutoId!);
      // print(videoUrlController.text);
    } on PlatformException catch (e) {
      print('Failed to pick Image: $e');
    }
  }

  Future<void> donePressed() async {
    setState(() {
      isLoading = true;
    });

    final imageTemp = File(widget.pickedFile.path);

    setState(() {
      videoFile = imageTemp;
    });
    await selectPictureFromCameraScreen();
    _trySubmit();
    if (captionController.text.contains('#')) {
      var sp = captionController.text.split(' ');
      var er = sp.where((value) => value.contains('#'));
      hashTags.add(er);
      var s = hashTags.first;
      for (final element in s) {
        FirebaseFirestore.instance.collection('Hashtag').doc(element).set({
          'hashtagname': element,
          'hashtagdetail': '',
          'hashtag': [FirebaseAuth.instance.currentUser!.uid]
        });
      }
    }
    setState(() {
      isLoading = false;
    });
    controller!.dispose();
    // ignore: use_build_context_synchronously
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  void dispose() {
    super.dispose();
    controller!.dispose();
  }

  Widget buildRow(
      String text, String iconUrl, double h, void Function()? pressed) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(40, 15),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        elevation: 0,
      ),
      onPressed: pressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconUrl,
            width: h,
            height: h,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            text,
            style: GoogleFonts.mPlusRounded1c(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(backgroundColor: Colors.black, actions: [
          Center(
            child: isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    // ignore: sort_child_properties_last
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Text(
                        "Done",
                        style: GoogleFonts.mPlusRounded1c(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0029FF),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7))),
                    onPressed: donePressed),
          ),
          const SizedBox(
            width: 5,
          )
        ]),
        backgroundColor: Colors.black,
        body: dpUrl.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : controller!.value.isInitialized
                ? Padding(
                    padding: mediaQueryData.viewInsets,
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: size.height * 0.6,
                                  width: size.width,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 42, 42, 42),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: (() => controller!.value.isPlaying
                                          ? controller!.pause()
                                          : controller!.play()),
                                      child: Stack(
                                        children: [
                                          AspectRatio(
                                              aspectRatio:
                                                  controller!.value.aspectRatio,
                                              child: VideoPlayer(controller!)),
                                          Positioned.fill(
                                            child: Stack(
                                              children: [
                                                controller!.value.isPlaying
                                                    ? const SizedBox()
                                                    : const Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Icon(
                                                          Icons.play_arrow,
                                                          color: Colors.white,
                                                          size: 50,
                                                        )),
                                                Positioned(
                                                    bottom: 0,
                                                    left: 0,
                                                    right: 0,
                                                    child: VideoProgressIndicator(
                                                        controller!,
                                                        colors:
                                                            const VideoProgressColors(
                                                                playedColor:
                                                                    Colors
                                                                        .blue),
                                                        allowScrubbing: true)),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: size.height * 0.002,
                                  right: size.width * 0.01,
                                  child: IconButton(
                                    icon: Image.asset(
                                      "images/icons/Group 9651.png",
                                      height: 30,
                                      width: 30,
                                    ),
                                    color: Colors.white,
                                    onPressed: () async {
                                      final imageTemp =
                                          File(widget.pickedFile.path);
                                      setState(() {
                                        videoFile = imageTemp;
                                      });
                                      thumbnail =
                                          await vt.VideoThumbnail.thumbnailFile(
                                              video: videoFile!.path,
                                              thumbnailPath:
                                                  (await getTemporaryDirectory())
                                                      .path,
                                              imageFormat: vt.ImageFormat.PNG);
                                      print(thumbnail);
                                      setState(() {});
                                    },
                                  ),
                                )
                              ],
                            ),
                            ListTile(
                              leading: dpUrl1.contains('https')
                                  ? ClipOval(
                                      child: Image.network(
                                      'https://as2.ftcdn.net/v2/jpg/03/31/69/91/1000_F_331699188_lRpvqxO5QRtwOM05gR50ImaaJgBx68vi.jpg',
                                      height: 35,
                                      width: 35,
                                      fit: BoxFit.cover,
                                    ))
                                  : ClipOval(
                                      child: Image.network(
                                      dpUrl,
                                      height: 35,
                                      width: 35,
                                      fit: BoxFit.cover,
                                    )),
                              title: Row(
                                children: [
                                  Text(
                                    userName,
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: context,
                                            backgroundColor: Colors.transparent,
                                            builder: (context) =>
                                                const SwitchProfile());
                                      },
                                      icon: Image.asset(
                                        "images/icons/Vector 87.png",
                                        height: 14,
                                        width: 14,
                                      )),
                                ],
                              ),
                            ),
                            thumbnail!.isEmpty
                                ? SizedBox()
                                : Container(
                                    child: Image.file(File(thumbnail!)),
                                  ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              height: 162,
                              width: size.width * .85,
                              decoration: BoxDecoration(
                                  color: const Color(0xFF1A1920),
                                  borderRadius: BorderRadius.circular(12)),
                              child: TextFormField(
                                controller: captionController,
                                maxLines: 10,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    hintText: 'Write a caption...',
                                    border: InputBorder.none,
                                    hintStyle: GoogleFonts.mPlusRounded1c(
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(14, 9, 0, 0)),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(37, 15, 15, 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            'images/icons/Location.svg',
                                            width: 16,
                                            height: 16,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          SizedBox(
                                            height: 40,
                                            width: size.width * 0.4,
                                            child: TextFormField(
                                              controller: locationController,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Add Location',
                                                  hintStyle: GoogleFonts
                                                      .mPlusRounded1c(
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          bottom: 8)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'images/icons/ttag.png',
                                            width: 14,
                                            height: 14,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          SizedBox(
                                            height: 40,
                                            width: size.width * 0.4,
                                            child: TextFormField(
                                              style: const TextStyle(
                                                  color: Colors.white),
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Tag People',
                                                  hintStyle: GoogleFonts
                                                      .mPlusRounded1c(
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          bottom: 8)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: const Size(40, 15),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          elevation: 0,
                                          //backgroundColor: Colors.white,
                                        ),
                                        onPressed: () {
                                          showModalBottomSheet(
                                              isScrollControlled: true,
                                              context: context,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder: (context) =>
                                                  const LinkPage());
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                              'images/icons/Link1.png',
                                              width: 24,
                                              height: 24,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Link',
                                              style: GoogleFonts.mPlusRounded1c(
                                                fontSize: 10,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          buildRow('Everyone',
                                              'images/icons/Globe.svg', 16, () {
                                            showModalBottomSheet(
                                                context: context,
                                                backgroundColor:
                                                    Colors.transparent,
                                                builder: (context) =>
                                                    const EveryonePage());
                                          }),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: size.width * 0.27,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color(0xFF1A1920)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Transform.scale(
                                            scale: 0.8,
                                            child: Radio(
                                              toggleable: true,
                                              fillColor: MaterialStateColor
                                                  .resolveWith(
                                                      (states) => Colors.blue),
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              splashRadius: 5,
                                              value: 2,
                                              groupValue: _value1,
                                              onChanged: (value) {
                                                setState(() {
                                                  _value1 = value;
                                                });
                                              },
                                            ),
                                          ),
                                          const Text('My Story',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: size.width * 0.27,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color(0xFF1A1920)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Transform.scale(
                                              scale: 0.8,
                                              child: Radio(
                                                fillColor: MaterialStateColor
                                                    .resolveWith((states) =>
                                                        Colors.blue),
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                value: 1,
                                                groupValue: _value,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _value = value!;
                                                  });
                                                },
                                              ),
                                            ),
                                            const Text('Post',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: size.width * 0.27,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color(0xFF1A1920)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Transform.scale(
                                              scale: 0.8,
                                              child: Radio(
                                                fillColor: MaterialStateColor
                                                    .resolveWith((states) =>
                                                        Colors.blue),
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                splashRadius: 5,
                                                value: null,
                                                groupValue: _value,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _value = value!;
                                                  });
                                                },
                                              ),
                                            ),
                                            const Text('Roll',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : const Center(child: CircularProgressIndicator()));
  }
}
