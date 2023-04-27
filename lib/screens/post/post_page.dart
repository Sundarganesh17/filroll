import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:filroll_app/providers/story.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/model/post_model.dart';
import 'package:filroll_app/providers/post.dart';
import 'package:filroll_app/providers/profile/file_storage.dart';
import 'package:filroll_app/screens/feed/home_screen.dart';
import 'package:filroll_app/screens/post/switch_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'everyone_page.dart';
import 'link.dart';

class PostPage extends StatefulWidget {
  XFile pickedFile;
  PostPage(
    this.pickedFile,
  );

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool isLoading = false;
  bool isLoading1 = false;
  bool isLoading2 = true;
  String dpUrl = '';
  String dpUrl1 = '';
  String userName = '';
  String link = '';
  bool isPrivate = false;
  List? followers;
  String? postAutoId;
  File? _fileSelectFromGallery;
  File? _fileSelectFromCameraScreen;
  final _fileSelectFromGalleryController = TextEditingController();
  final _fileSelectFromCameraScreenController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int? _value = 1;
  int? _value1 = 0;
  bool isPost = false;
  bool isStory = false;
  final List hashTags = [];
  final captionController = TextEditingController();
  final locationController = TextEditingController();
  final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    getDp();
  }

  void getDp() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .get();
    var dp = await getUrl('dp-${currentUserUid}.jpg');
    print(widget.pickedFile.toString());
    setState(() {
      dpUrl = dp;
      dpUrl1 = (snap.data() as Map<String, dynamic>)['DPUrl'];
      userName = (snap.data() as Map<String, dynamic>)['username'];
      isPrivate = (snap.data() as Map<String, dynamic>)['isPrivate'];
      followers = (snap.data() as Map<String, dynamic>)['followers'];
      postAutoId = const Uuid().v1();
      isLoading2 = false;
    });
  }

  Future<String> createAndUploadFile() async {
    try {
      final UploadFileResult result = await Amplify.Storage.uploadFile(
        local: File(_fileSelectFromCameraScreen!.path),
        key: 'postImg-$postAutoId.jpg',
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

  Future<String> createAndUploadFile1() async {
    try {
      final UploadFileResult result = await Amplify.Storage.uploadFile(
        local: File(_fileSelectFromGallery!.path),
        key: 'postImg-$postAutoId.jpg',
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
      var imageKey = await createAndUploadFile();
      _fileSelectFromCameraScreenController.text = imageKey;
      // _fileSelectFromCameraScreenController.text = await FileStorage()
      //     .uploadPostImage('posts', _fileSelectFromCameraScreen!, postAutoId!);
      // print(_fileSelectFromCameraScreenController.text);
    } on PlatformException catch (e) {
      print('Failed to pick Image: $e');
    }
  }

  Future<void> selectPictureFromGallery() async {
    try {
      setState(() {
        _fileSelectFromCameraScreen == null;
        isLoading1 = true;
      });
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        _fileSelectFromGallery = imageTemp;
      });
      var imageKey = await createAndUploadFile1();
      _fileSelectFromGalleryController.text = imageKey;
      // _fileSelectFromGalleryController.text = await FileStorage()
      //     .uploadPostImage('posts', _fileSelectFromGallery!, postAutoId!);
      setState(() {
        isLoading1 = false;
      });
    } on PlatformException catch (e) {
      print('Failed to pick Image: $e');
    }
  }

  void hashTagPicker() {
    if (captionController.text.contains('#')) {
      var sp = captionController.text.split(' ');
      var er = sp.where((value) => value.contains('#'));
      hashTags.add(er);
      var s = hashTags.first;
      for (final element in s) {
        FirebaseFirestore.instance.collection('Hashtag').doc(element).set({
          'hashtagname': element,
          'hashtag': [FirebaseAuth.instance.currentUser!.uid],
        });
      }
    }
  }

  void linkPicker() {
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
  }

  Future<void> uploadPost() async {
    var createPost = PostModel(
        postId: postAutoId!,
        postUrl: _fileSelectFromGalleryController.text.isNotEmpty
            ? _fileSelectFromGalleryController.text
            : _fileSelectFromCameraScreenController.text,
        caption: captionController.text,
        location: locationController.text,
        uid: currentUserUid,
        userName: userName,
        dpUrl: dpUrl,
        dateTime: DateTime.now(),
        isVideo: false,
        link: link,
        likes: [],
        views: [],
        thumbnail: '',
        isPrivate: isPrivate);
    print(_fileSelectFromGalleryController.text.isNotEmpty
        ? _fileSelectFromGalleryController.text
        : _fileSelectFromCameraScreenController.text);

    await Provider.of<Post>(context, listen: false)
        .uploadPost(createPost, postAutoId!);
  }

  Future<void> uploadStory() async {
    var key = _fileSelectFromGalleryController.text.isNotEmpty
        ? _fileSelectFromGalleryController.text
        : _fileSelectFromCameraScreenController.text;
    var story = await getUrl(key);
    await Provider.of<Story>(context, listen: false)
        .uploadStory(story, userName, dpUrl, key, false);
  }

  Future<void> _trySubmit() async {
    print(_value1);
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      linkPicker();
      hashTagPicker();
      _formKey.currentState!.save();
      await uploadPost();
    }
  }

  Future<void> donePressed() async {
    setState(() {
      isLoading = true;
    });
    final imageTemp = File(widget.pickedFile.path);

    setState(() {
      _fileSelectFromCameraScreen = imageTemp;
    });
    if (_fileSelectFromCameraScreen != null) {
      await selectPictureFromCameraScreen();
      _trySubmit();
      if (_value1 == 2) await uploadStory();
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      _trySubmit();
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    }
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
      // appBar: AppBar(backgroundColor: Colors.black, actions: [
      //   Center(
      //     child: isLoading
      //         ? const CircularProgressIndicator()
      //         : ElevatedButton(
      //             // ignore: sort_child_properties_last
      //             child: Container(
      //               padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      //               child: Text(
      //                 "Done",
      //                 style: GoogleFonts.mPlusRounded1c(
      //                   color: Colors.white,
      //                   fontSize: 14.0,
      //                   fontWeight: FontWeight.bold,
      //                 ),
      //               ),
      //             ),
      //             style: ElevatedButton.styleFrom(
      //                 backgroundColor: Color(0xFF0029FF),
      //                 shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(7))),
      //             onPressed: donePressed),
      //   ),
      //   const SizedBox(
      //     width: 5,
      //   )
      // ]),
      backgroundColor: Colors.black,
      body: isLoading2
          ? Center(child: CircularProgressIndicator())
          : dpUrl.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Form(
                  key: _formKey,
                  child: SafeArea(
                    child: Padding(
                      padding: mediaQueryData.viewInsets,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Container(
                                  height: size.height * 0.4,
                                  width: size.width,
                                  child: isLoading1
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : _fileSelectFromGallery != null
                                          ? Image.file(
                                              File(
                                                  _fileSelectFromGallery!.path),
                                              fit: BoxFit.cover,
                                            )
                                          : Image.file(
                                              File(widget.pickedFile.path),
                                              fit: BoxFit.cover,
                                            ),
                                ),
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
                                                  left: 15),
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
                                            onTap: () {},
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
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
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: size.height * 0.28,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: Container(
                                                height: 30,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8),
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12))),
                                                child: Row(
                                                  children: [
                                                    dpUrl1.contains('https')
                                                        ? ClipOval(
                                                            child:
                                                                Image.network(
                                                            'https://as2.ftcdn.net/v2/jpg/03/31/69/91/1000_F_331699188_lRpvqxO5QRtwOM05gR50ImaaJgBx68vi.jpg',
                                                            height: 20,
                                                            width: 20,
                                                            fit: BoxFit.cover,
                                                          ))
                                                        : ClipOval(
                                                            child:
                                                                Image.network(
                                                            dpUrl,
                                                            height: 20,
                                                            width: 20,
                                                            fit: BoxFit.cover,
                                                          )),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      userName,
                                                      style: GoogleFonts.roboto(
                                                        color: Colors.white,
                                                        fontSize: 10.0,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 30,
                                                      child: IconButton(
                                                          onPressed: () {
                                                            showModalBottomSheet(
                                                                context:
                                                                    context,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                builder:
                                                                    (context) =>
                                                                        const SwitchProfile());
                                                          },
                                                          icon: Image.asset(
                                                            "images/icons/Vector 87.png",
                                                            height: 14,
                                                            width: 14,
                                                          )),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15),
                                            child: Container(
                                                height: 20,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 4),
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
                                                child: Center(
                                                    child: Text(
                                                  'Changeimage',
                                                  style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.white),
                                                ))),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            // Stack(children: [
                            //   Container(
                            //     height: size.height * 0.2,
                            //     width: size.width * 0.8,
                            //     decoration: BoxDecoration(
                            //       color: const Color.fromARGB(255, 42, 42, 42),
                            //       borderRadius: BorderRadius.circular(7),
                            //       // image: DecorationImage(image: FileImage(file))
                            //     ),
                            //     child: isLoading1
                            //         ? const Center(
                            //             child: CircularProgressIndicator(),
                            //           )
                            //         : _fileSelectFromGallery != null
                            //             ? Image.file(
                            //                 File(_fileSelectFromGallery!.path),
                            //                 fit: BoxFit.contain,
                            //               )
                            //             : Image.file(
                            //                 File(widget.pickedFile.path),
                            //                 fit: BoxFit.contain,
                            //               ),
                            //   ),
                            //   Positioned(
                            //     bottom: size.height * 0.002,
                            //     right: size.width * 0.01,
                            //     child: IconButton(
                            //       icon: Image.asset(
                            //         "images/icons/Group 9651.png",
                            //         height: 30,
                            //         width: 30,
                            //       ),
                            //       color: Colors.white,
                            //       onPressed: selectPictureFromGallery,
                            //     ),
                            //   )
                            // ]),
                            const SizedBox(
                              height: 10,
                            ),
                            // ListTile(
                            //   leading: dpUrl1.contains('https')
                            //       ? ClipOval(
                            //           child: Image.network(
                            //           'https://as2.ftcdn.net/v2/jpg/03/31/69/91/1000_F_331699188_lRpvqxO5QRtwOM05gR50ImaaJgBx68vi.jpg',
                            //           height: 35,
                            //           width: 35,
                            //           fit: BoxFit.cover,
                            //         ))
                            //       : ClipOval(
                            //           child: Image.network(
                            //           dpUrl,
                            //           height: 35,
                            //           width: 35,
                            //           fit: BoxFit.cover,
                            //         )),
                            //   title: Row(
                            //     children: [
                            //       Text(
                            //         userName,
                            //         style: GoogleFonts.roboto(
                            //           color: Colors.white,
                            //           fontSize: 15.0,
                            //         ),
                            //       ),
                            //       IconButton(                                                                                                                                                                                                                                                                                                                              
                            //           onPressed: () {
                            //             showModalBottomSheet(
                            //                 context: context,
                            //                 backgroundColor: Colors.transparent,
                            //                 builder: (context) =>
                            //                     const SwitchProfile());
                            //           },
                            //           icon: Image.asset(
                            //             "images/icons/Vector 87.png",
                            //             height: 14,
                            //             width: 14,
                            //           )),                                                                    `                                
                            //     ],
                            //   ),
                            // ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text(
                                    'Add a Description',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  height: 162,
                                  width: size.width * .95,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF1A1920),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: TextFormField(
                                    controller: captionController,
                                    maxLines: 10,
                                    style:  TextStyle(color: Colors.grey[300]),
                                    decoration: InputDecoration(
                                        hintText: 'Text goes here...',
                                        border: InputBorder.none,
                                        hintStyle: GoogleFonts.mPlusRounded1c(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                14, 9, 0, 0)),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15),
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
                                              style: TextStyle(
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
                                        ),
                                        onPressed: () {
                                          showModalBottomSheet(
                                              isScrollControlled: true,
                                              context: context,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder: (context) => LinkPage());
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
                                                    EveryonePage());
                                          }),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            fillColor:
                                                MaterialStateColor.resolveWith(
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
                                                print(_value1);
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
                                    padding: EdgeInsets.only(right: 15),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Transform.scale(
                                            scale: 0.8,
                                            child: Radio(
                                              fillColor: MaterialStateColor
                                                  .resolveWith(
                                                      (states) => Colors.blue),
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
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    width: size.width * 0.27,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color(0xFF1A1920)),
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 15),
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
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }
}
