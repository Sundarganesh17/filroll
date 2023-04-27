import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/providers/story.dart';
import 'package:filroll_app/screens/feed/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

class PostStoryPage extends StatefulWidget {
  XFile? pickedFile;
  bool isVideo;
  PostStoryPage({super.key, required this.pickedFile, required this.isVideo});

  @override
  State<PostStoryPage> createState() => _PostStoryPageState();
}

class _PostStoryPageState extends State<PostStoryPage> {
  String dpUrl = '';
  String dpUrl1 = '';
  String? username;
  final _fileController = TextEditingController();
  File? image;
  bool isLoading = false;
  bool isLoading1 = false;
  var createStory;
  String? storyAutoId;
  VideoPlayerController? controller;

  @override
  void initState() {
    super.initState();
    getDp();
    if (widget.isVideo) controllerInitiation();
  }

  @override
  void dispose() {
    super.dispose();
    controller!.dispose();
  }

  void controllerInitiation() {
    controller = VideoPlayerController.file(File(widget.pickedFile!.path))
      ..addListener(
        () => setState(() {}),
      )
      ..setLooping(true)
      ..initialize().then((_) => controller!.play());
  }

  void getDp() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    var dp = await getUrl('dp-${FirebaseAuth.instance.currentUser!.uid}.jpg');
    setState(() {
      dpUrl = dp;
      dpUrl1 = (snap.data() as Map<String, dynamic>)['DPUrl'];
      username = (snap.data() as Map<String, dynamic>)['username'];
      storyAutoId = const Uuid().v1();
    });
  }

  Future<void> trySubmit() async {
    try {
      setState(() {
        isLoading = true;
      });
      uploadImageToStorage();
      var url = await getUrl('storyImg-$storyAutoId.jpg');
      await Provider.of<Story>(context, listen: false).uploadStory(
          url,
          username!,
          dpUrl1.contains('https')
              ? 'https://as2.ftcdn.net/v2/jpg/03/31/69/91/1000_F_331699188_lRpvqxO5QRtwOM05gR50ImaaJgBx68vi.jpg'
              : dpUrl,
          'storyImg-$storyAutoId.jpg',
          widget.isVideo);

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> createAndUploadFile() async {
    try {
      final UploadFileResult result = await Amplify.Storage.uploadFile(
        local: File(image!.path),
        key: widget.isVideo
            ? 'storyVdo-$storyAutoId.mp4'
            : 'storyImg-$storyAutoId.jpg',
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
      final result = await Amplify.Storage.getUrl(
          key: key,
          options: GetUrlOptions(
              expires: 86400, accessLevel: StorageAccessLevel.guest));
      return result.url;
    } catch (e) {
      throw e;
    }
  }

  Future<void> uploadImageToStorage() async {
    try {
      setState(() {
        isLoading1 = true;
      });
      final FileTemp = File(widget.pickedFile!.path);

      setState(() {
        image = FileTemp;
      });
      var fileKey = await createAndUploadFile();
      var url = await getUrl('storyImg-$storyAutoId.jpg');
      // _fileController.text = await FileStorage()
      //     .uploadStoryImage('stories', image!, storyAutoId!);
      setState(() {
        _fileController.text = url;
        isLoading1 = false;
      });
    } on PlatformException catch (e) {
      print('Failed to pick Image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Center(
          child: Text(
            'Add to Story',
            style: TextStyle(fontSize: 16),
          ),
        ),
        actions: [
          isLoading1
              ? TextButton(
                  onPressed: () {},
                  child: Text(
                    'Post Story',
                    style: TextStyle(color: Colors.blue.withOpacity(0.5)),
                  ))
              : TextButton(
                  onPressed: trySubmit,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Post Story',
                        ))
        ],
      ),
      body: dpUrl.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                ListTile(
                  leading: dpUrl1.contains('https')
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://as2.ftcdn.net/v2/jpg/03/31/69/91/1000_F_331699188_lRpvqxO5QRtwOM05gR50ImaaJgBx68vi.jpg'))
                      : CircleAvatar(backgroundImage: NetworkImage(dpUrl)),
                  title: Text(
                    username!,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: size.height * 0.75,
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 29, 29, 29)),
                  child: widget.isVideo
                      ? Align(
                          alignment: Alignment.topCenter,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: (() => controller!.value.isPlaying
                                ? controller!.pause()
                                : controller!.play()),
                            child: Stack(
                              children: [
                                AspectRatio(
                                    aspectRatio: controller!.value.aspectRatio,
                                    child: VideoPlayer(controller!)),
                                Positioned.fill(
                                  child: Stack(
                                    children: [
                                      controller!.value.isPlaying
                                          ? const SizedBox()
                                          : const Align(
                                              alignment: Alignment.center,
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
                                              colors: const VideoProgressColors(
                                                  playedColor: Colors.blue),
                                              allowScrubbing: true)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: isLoading1
                              ? const Center(child: CircularProgressIndicator())
                              : Image.file(
                                  File(widget.pickedFile!.path),
                                  fit: BoxFit.contain,
                                ),
                        ),
                )
              ],
            ),
    );
  }
}
