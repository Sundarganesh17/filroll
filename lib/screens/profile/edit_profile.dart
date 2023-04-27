import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:filroll_app/model/user_model.dart';
import 'package:filroll_app/providers/auth.dart';
import 'package:filroll_app/providers/profile/extra_user_detail.dart';
import 'package:filroll_app/screens/authentication/verify_email_page.dart';
import 'package:filroll_app/screens/feed/home_screen.dart';
import 'package:filroll_app/screens/profile/others_profile.dart';
import 'package:filroll_app/screens/profile/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'gender_selection.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _dpUrlController = TextEditingController();
  final _cpUrlController = TextEditingController();
  final _emailController = TextEditingController();
  final _userNameController = TextEditingController();
  File? _pickedProfileFile;
  CroppedFile? _croppedProfileFile;
  File? _pickedCoverFile;
  CroppedFile? _croppedCoverFile;
  File? dpPic;
  String? dpUrl;
  String? cpUrl;
  File? coverPic;
  String? gender;
  bool isLoading1 = true;
  bool isLoading = false;
  bool isLoading2 = false;
  final _formKey = GlobalKey<FormState>();
  String? _country = '91';
  String? exName;
  String? exUserName;
  String? exWebsite;
  String? exBio;
  String? exGmail;
  String? exPhoneNumber;
  String? exGender;
  String? exBirthday;
  String? exDpUrl;
  String? exCpUrl;
  String? myDpUrl;
  String? myCpUrl;
  bool? exNotification;
  var exLastModified;
  String userUid = FirebaseAuth.instance.currentUser!.uid;
  List<String> exFollowers = [];
  List<String> exFollowing = [];
  bool? exIsPrivate;
  bool isUserName = false;
  bool isEmail = false;
  var snap;
  bool e1 = false;
  bool e2 = false;
  bool e3 = false;
  var ref;
  // ignore: prefer_typing_uninitialized_variables
  var _editedUser;
  // ignore: unused_field
  final Map<String, dynamic> _initValues = {
    'name': '',
    'userName': '',
    'website': '',
    'bio': '',
    'email': '',
    'phoneNumber': '',
    'gender': '',
    'birthday': '',
    'dpUrl': '',
    'cpUrl': '',
    'followers': [],
    'follwing': [],
  };

  @override
  void initState() {
    super.initState();
    fetchUserData();
    ref = Provider.of<Auth>(context, listen: false);
    ref.userNameExists();
  }

  fetchUserData() async {
    try {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .get();
      var dp = await getUrl('dp-${userUid}.jpg');
      var cp = await getUrl('cp-${userUid}.jpg');
      myDpUrl = (snap.data() as Map<String, dynamic>)['DPUrl'];
      myCpUrl = (snap.data() as Map<String, dynamic>)['CPUrl'];
      exName = (snap.data() as Map<String, dynamic>)['name'];
      exUserName = (snap.data() as Map<String, dynamic>)['username'];
      _userNameController.text =
          (snap.data() as Map<String, dynamic>)['username'];
      exWebsite = (snap.data() as Map<String, dynamic>)['website'];
      exBio = (snap.data() as Map<String, dynamic>)['bio'];
      exGmail = (snap.data() as Map<String, dynamic>)['email'];
      _emailController.text = (snap.data() as Map<String, dynamic>)['email'];
      exPhoneNumber = (snap.data() as Map<String, dynamic>)['phonenumber'];
      _country = (snap.data() as Map<String, dynamic>)['countrycode'];
      exGender = (snap.data() as Map<String, dynamic>)['gender'];
      exBirthday = (snap.data() as Map<String, dynamic>)['DOB'];
      exIsPrivate = (snap.data() as Map<String, dynamic>)['isPrivate'];
      exNotification = (snap.data() as Map<String, dynamic>)['notification'];
      exLastModified =
          (snap.data() as Map<String, dynamic>)['lastModified'].toDate();
      exDpUrl = dp;
      exCpUrl = cp;
      setState(() {
        isLoading1 = false;
      });
    } catch (e) {
      setState(() {
        isLoading1 = false;
      });
    }
  }

  Future<void> _trySubmit(BuildContext ctx) async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();

      setState(() {
        isLoading = true;
      });
      _dpUrlController.text = await UploadDpFile();
      _editedUser = UserModel(
        name: exName!,
        userName: exUserName!,
        uid: userUid,
        website: exWebsite!,
        bio: exBio!,
        email: exGmail!,
        countryCode: _country!,
        phoneNumber: exPhoneNumber!,
        gender: exGender!,
        birthday: exBirthday!,
        dpUrl: _dpUrlController.text.isEmpty ? myDpUrl! : _dpUrlController.text,
        cpUrl: _cpUrlController.text.isEmpty ? myCpUrl! : _cpUrlController.text,
        isPrivate: exIsPrivate!,
        notification: exNotification!,
        lastModified: exLastModified,
        isOnline: true,
      );
      await Provider.of<ExtraUserDetail>(ctx, listen: false)
          .submitExtraUserDetails(_editedUser);
      setState(() {
        isLoading = false;
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()));
      });
    }
  }

  Future<void> selectProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemp = File(image.path);

      await _cropProfileImage(imageTemp);

      setState(() {
        isLoading = false;
      });
    } on PlatformException catch (e) {
      print('Failed to pick Image: $e');
    }
  }

  Future<void> _cropProfileImage(File image) async {
    if (image != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop Profile Image',
              toolbarColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true,
              hideBottomControls: true,
              showCropGrid: true),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedProfileFile = croppedFile;
        });
      }
    }
  }

  Future<void> _cropCoverImage() async {
    if (_pickedCoverFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedCoverFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop Crop Image',
              toolbarColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.ratio16x9,
              lockAspectRatio: true,
              hideBottomControls: true,
              showCropGrid: true),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedCoverFile = croppedFile;
        });
      }
    }
  }

  Future<String> UploadDpFile() async {
    try {
      final UploadFileResult result = await Amplify.Storage.uploadFile(
        local: File(_croppedProfileFile!.path),
        key: 'dp-$userUid.jpg',
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

  Future<String> UploadCpFile() async {
    try {
      final UploadFileResult result = await Amplify.Storage.uploadFile(
        local: File(_croppedCoverFile!.path),
        key: 'cp-$userUid.jpg',
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

  Future<String> UploadDemo() async {
    try {
      final UploadFileResult result = await Amplify.Storage.uploadFile(
        local: File('images/icons/dp.jpg'),
        key: 'dp-demo.jpg',
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

  Future<void> selectCoverImage() async {
    try {
      final pic = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pic == null) return;

      final imageTemp = File(pic.path);
      setState(() {
        _pickedCoverFile = imageTemp;
      });
      await _cropCoverImage();
      var imageKey = await UploadCpFile();
      setState(() {
        _cpUrlController.text = imageKey;
        isLoading = false;
      });
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print('Failed to pick Image: $e');
    }
  }

  Widget buildDoneButton() {
    return Center(
      child: isLoading
          ? const CircularProgressIndicator()
          : ElevatedButton(
              // ignore: sort_child_properties_last
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Text(
                  "Done",
                  style: GoogleFonts.mPlusRounded1c(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0029FF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7))),
              onPressed: () => _trySubmit(context),
            ),
    );
  }

  Widget buildCoverPicContainer() {
    return _croppedCoverFile != null
        ? Container(
            height: size.height * 0.18,
            width: size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: FileImage(
                    File(_croppedCoverFile!.path),
                  ),
                )),
          )
        : Container(
            height: size.height * 0.18,
            width: size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: myCpUrl!.contains('https')
                      ? NetworkImage(
                          'https://amdmediccentar.rs/wp-content/plugins/uix-page-builder/includes/uixpbform/images/default-cover-4.jpg')
                      : NetworkImage(
                          exCpUrl!,
                        ),
                )),
          );
  }

  Widget buildChooseCoverPicButton() {
    return Positioned(
        top: size.height * 0.075,
        left: size.width * 0.33,
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(20, 20, 20, 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(40, 15),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              elevation: 0,
            ),
            onPressed: selectCoverImage,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                'Choose Your Cover Image',
                style: GoogleFonts.roboto(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ));
  }

  Widget buildProfileAvatar() {
    return Positioned(
      top: size.height * 0.13,
      right: size.width * 0.09,
      child: Column(
        children: [
          GestureDetector(
            onTap: selectProfilePicture,
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 3),
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: _croppedProfileFile != null
                    ? CircleAvatar(
                        radius: 33,
                        backgroundImage:
                            FileImage(File(_croppedProfileFile!.path)))
                    : myDpUrl!.contains('https')
                        ? const CircleAvatar(
                            radius: 33,
                            backgroundImage: NetworkImage(
                              "https://as2.ftcdn.net/v2/jpg/03/31/69/91/1000_F_331699188_lRpvqxO5QRtwOM05gR50ImaaJgBx68vi.jpg",
                            ),
                          )
                        : CircleAvatar(
                            radius: 33,
                            backgroundImage: NetworkImage(exDpUrl!))),
          ),
          const SizedBox(
            height: 4,
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(40, 15),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              elevation: 0,
            ),
            onPressed: selectProfilePicture,
            child: Text(
              'Change Profile Photo',
              style: GoogleFonts.mPlusRounded1c(
                  fontSize: 10,
                  color: const Color(0XFF1673FF),
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Widget buildNameTextFormField() {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 40,
      width: size.width * .85,
      decoration: BoxDecoration(
          color: const Color(0xFF1A1920),
          borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        initialValue: exName,
        maxLength: 15,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            suffix: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                '15',
                style: GoogleFonts.mPlusRounded1c(
                    fontSize: 10,
                    color: const Color(0XFF6C717B),
                    fontWeight: FontWeight.bold),
              ),
            ),
            hintText: 'Name',
            border: InputBorder.none,
            hintStyle: GoogleFonts.mPlusRounded1c(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            contentPadding: const EdgeInsets.fromLTRB(14, 0, 0, 4)),
        onSaved: ((value) {
          exName = value;
        }),
      ),
    );
  }

  Widget usernameErrorMessage(String error) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        error,
        style: TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }

  Widget buildUserNameTextFormField() {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 40,
      width: size.width * .85,
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(5.0)),
      child: TextFormField(
        controller: _userNameController,
        key: const ValueKey('userName'),
        // validator: ((value) {
        //   var num = value!.replaceAll(new RegExp(r'[^0-9]'), '');
        //   if (ref.username
        //       .map((e) => e.toString())
        //       .toList()
        //       .contains(value)) {
        //     return 'This username is already exist.';
        //   } else if (value.isEmpty) {
        //     return 'Please enter a username';
        //   } else if (num.length >= 5) {
        //     return 'Username has restriction of maximum 4 Numerics';
        //   } else if (!value.toLowerCase().contains(RegExp(r'[a-z]'))) {
        //     return 'Username must be with Letters "a-z"';
        //   }
        // }),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: const Color(0xFF1A1920),
            hintText: "User Name",
            border: InputBorder.none,
            hintStyle: GoogleFonts.mPlusRounded1c(
              fontSize: 14,
              color: Colors.grey,
            ),
            contentPadding: EdgeInsets.fromLTRB(14, 0, 0, 4)),
        onSaved: ((newValue) {
          //userName = newValue;
        }),
        onTap: () {
          setState(() {
            isUserName = true;
          });
        },
      ),
    );
  }

  Widget buildSubmitUsernameRequest() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Row(children: [
            Container(
              width: size.width * 0.6,
              child: Text(
                'Username will be updated only after 30 days from Last Username changing instance',
                style: TextStyle(color: Colors.grey, fontSize: 12),
                overflow: TextOverflow.visible,
              ),
            ),
            TextButton(
              child: Text('Request',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: () {
                var num = _userNameController.text
                    .replaceAll(new RegExp(r'[^0-9]'), '');
                if (ref.username
                    .map((e) => e.toString())
                    .toList()
                    .contains(_userNameController.text)) {
                  setState(() {
                    e1 = true;
                  });
                } else if (num.length >= 5 ||
                    !_userNameController.text
                        .toLowerCase()
                        .contains(RegExp(r'[a-z]'))) {
                  setState(() {
                    e2 = true;
                  });
                } else if (_userNameController.text.isEmpty) {
                  setState(() {
                    e3 = true;
                  });
                } else {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    e1 = false;
                    e2 = false;
                    e3 = false;
                  });
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text("Request for Username Change"),
                      content: Text(
                          "Once you get Approval, We'll share link through Email for changing Username."),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('usernameChangeRequest')
                                .doc(userUid)
                                .set({
                              'username': exUserName,
                              'usernameWantToChange': _userNameController.text,
                              'email': exGmail,
                              'uid': userUid,
                              'dateTime': DateTime.now(),
                            });
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Your Request has been Succesfully Submitted')));
                          },
                          child: Text("Ok"),
                        ),
                      ],
                    ),
                  );
                }
              },
            )
          ]),
        ),
        GestureDetector(
            onTap: () {
              setState(() {
                isUserName = false;
              });
            },
            child: Icon(
              Icons.close,
              size: 18,
              color: Colors.white,
            ))
      ],
    );
  }

  Widget buildEmailChangeRequest() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Container(
              width: size.width * 0.52,
              child: Text(
                'We\'ll send Verification link to entered Email Address',
                style: TextStyle(color: Colors.grey, fontSize: 12),
                overflow: TextOverflow.visible,
              ),
            ),
            isLoading2
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    height: 32,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFF0029FF)),
                    child: TextButton(
                      child: Text('Send Link',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                      onPressed: () => sendVerificationEmail(),
                    ),
                  ),
            SizedBox(width: 10),
          ]),
        ),
        GestureDetector(
            onTap: () {
              setState(() {
                isEmail = false;
              });
            },
            child: Icon(
              Icons.close,
              size: 18,
              color: Colors.white,
            ))
      ],
    );
  }

  Future sendVerificationEmail() async {
    FocusScope.of(context).unfocus();
    if (_emailController.text == exGmail) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter email Id that you want to change'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } else {
      try {
        setState(() {
          isLoading2 = true;
        });
        final user = FirebaseAuth.instance.currentUser!;
        await user.updateEmail(_emailController.text);
        print(user.email);
        await user.sendEmailVerification();
        setState(() {
          isLoading2 = false;
        });
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => VerifyEmailPage1(
                oldEmail: exGmail!, newEmail: _emailController.text)));
      } on FirebaseAuthException catch (error) {
        setState(() {
          isLoading2 = false;
        });
        var msg = 'We are not able to send Link to Your Email';
        if (error.message != null) {
          msg = error.message!;
          print(msg);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
        await FirebaseAuth.instance.currentUser!.updateEmail(exGmail!);
      }
    }
  }

  Widget buildWebsiteTextFormField() {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 40,
      width: size.width * .85,
      decoration: BoxDecoration(
          color: const Color(0xFF1A1920),
          borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        initialValue: exWebsite,
        //controller: _websiteController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            hintText: 'Website',
            border: InputBorder.none,
            hintStyle: GoogleFonts.mPlusRounded1c(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            contentPadding: const EdgeInsets.fromLTRB(14, 0, 0, 11)),
        onSaved: ((value) {
          exWebsite = value;
        }),
      ),
    );
  }

  Widget buildGmailTextFormField() {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.all(10),
        height: 40,
        width: size.width * .85,
        decoration: BoxDecoration(
            color: const Color(0xFF1A1920),
            borderRadius: BorderRadius.circular(10)),
        child:
            //  Padding(
            //   padding: const EdgeInsets.fromLTRB(13, 10, 0, 0),
            //   child: Text(
            //     exGmail!,
            //     style: TextStyle(color: Colors.white, fontSize: 16),
            //   ),
            // ),
            TextFormField(
                //initialValue: _emailController.text,
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: 'Gmail Id',
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.mPlusRounded1c(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(14, 0, 0, 11)),
                // onSaved: ((value) {
                //   exGmail = value;
                // }),
                onTap: () {
                  setState(() {
                    isEmail = true;
                  });
                }
                // onTap: () {
                //   FocusScope.of(context).unfocus();
                //   showDialog(
                //     context: context,
                //     builder: (ctx) => AlertDialog(
                //       backgroundColor: Color.fromARGB(255, 36, 36, 36),
                //       title: Text(
                //         "Email Id Change",
                //         style: TextStyle(color: Colors.white),
                //       ),
                //       content: Text(
                //         "If you want to change Email, you need to get approval from our side. Request option is there in Settings",
                //         style: TextStyle(color: Colors.white),
                //       ),
                //       actions: <Widget>[
                //         TextButton(
                //           onPressed: () {
                //             Navigator.of(ctx).pop();
                //           },
                //           child: Text("Cancel"),
                //         ),
                //         TextButton(
                //           onPressed: () async {
                //             Navigator.pushReplacement(
                //                 context,
                //                 MaterialPageRoute(
                //                     builder: (context) => const SettingsPage()));
                //           },
                //           child: Text("Go to Settings"),
                //         ),
                //       ],
                //     ),
                //   );
                // },
                ),
      ),
      // onTap: () {
      //   showDialog(
      //     context: context,
      //     builder: (ctx) => AlertDialog(
      //       backgroundColor: Color.fromARGB(255, 36, 36, 36),
      //       title: Text(
      //         "Email Id Change",
      //         style: TextStyle(color: Colors.white),
      //       ),
      //       content: Text(
      //         "If you want to change Email, you need to get approval from our side. Request option is there in Settings",
      //         style: TextStyle(color: Colors.white),
      //       ),
      //       actions: <Widget>[
      //         TextButton(
      //           onPressed: () {
      //             Navigator.of(ctx).pop();
      //           },
      //           child: Text("Cancel"),
      //         ),
      //         TextButton(
      //           onPressed: () async {
      //             Navigator.pushReplacement(
      //                 context,
      //                 MaterialPageRoute(
      //                     builder: (context) => const SettingsPage()));
      //           },
      //           child: Text("Go to Settings"),
      //         ),
      //       ],
      //     ),
      //   );
      // },
    );
  }

  Widget buildDOBTextFormField() {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 40,
      width: size.width * .85,
      decoration: BoxDecoration(
          color: const Color(0xFF1A1920),
          borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        keyboardType: TextInputType.number,
        initialValue: exBirthday,
        //controller: _birthdayController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            hintText: 'Birthday',
            border: InputBorder.none,
            hintStyle: GoogleFonts.mPlusRounded1c(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            contentPadding: const EdgeInsets.fromLTRB(14, 0, 0, 11)),
        onSaved: ((value) {
          exBirthday = value;
        }),
      ),
    );
  }

  Widget buildBioTextFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        margin: const EdgeInsets.all(10),
        height: 120,
        width: size.width * .85,
        decoration: BoxDecoration(
            color: const Color(0xFF1A1920),
            borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
          initialValue: exBio,
          //controller: _bioController,
          maxLength: 150,
          maxLines: 5,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
              suffix: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  '150',
                  style: GoogleFonts.mPlusRounded1c(
                      fontSize: 10,
                      color: const Color(0XFF6C717B),
                      fontWeight: FontWeight.bold),
                ),
              ),
              hintText: 'Bio',
              border: InputBorder.none,
              hintStyle: GoogleFonts.mPlusRounded1c(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              contentPadding: const EdgeInsets.fromLTRB(14, 9, 0, 0)),
          onSaved: ((value) {
            exBio = value;
          }),
        ),
      ),
    );
  }

  Widget buildPhoneNumberTextFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        margin: const EdgeInsets.all(10),
        height: 40,
        width: size.width * .85,
        decoration: BoxDecoration(
            color: const Color(0xFF1A1920),
            borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
          keyboardType: TextInputType.number,
          initialValue: exPhoneNumber,
          //controller: _phoneNumberController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
              prefixIcon: SizedBox(
                //margin: EdgeInsets.only(left: 2),
                width: size.width * 0.17,
                child: Row(children: [
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    _country!,
                    style: GoogleFonts.mPlusRounded1c(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.arrow_drop_down_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      showCountryPicker(
                          context: context,
                          showPhoneCode: true,
                          countryListTheme: const CountryListThemeData(
                            searchTextStyle: TextStyle(color: Colors.white),
                            flagSize: 25,
                            backgroundColor: Color.fromARGB(255, 44, 43, 43),
                            textStyle:
                                TextStyle(fontSize: 14, color: Colors.white),

                            bottomSheetHeight: 400,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                            //Optional. Styles the search field.
                            inputDecoration: InputDecoration(
                              labelText: 'Search',
                              hintText: 'Start typing to search',
                              hintStyle: TextStyle(color: Colors.grey),
                              labelStyle: TextStyle(color: Colors.white),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    //color: Colors.white,
                                    ),
                              ),
                            ),
                          ),
                          onSelect: (Country country) {
                            setState(() {
                              _country = country.phoneCode;
                            });
                          });
                    },
                  ),
                ]),
              ),
              hintText: 'Phone Number',
              border: InputBorder.none,
              hintStyle: GoogleFonts.mPlusRounded1c(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              contentPadding: const EdgeInsets.fromLTRB(0, 6, 0, 0)),
          onSaved: ((value) {
            exPhoneNumber = value;
          }),
        ),
      ),
    );
  }

  Widget buildGenderTextFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        margin: const EdgeInsets.all(10),
        height: 40,
        width: size.width * .85,
        decoration: BoxDecoration(
            color: const Color(0xFF1A1920),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: TextButton(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  exGender!.isNotEmpty ? exGender! : 'Gender',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.mPlusRounded1c(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => GenderSelection()))
                    .then((value) {
                  var result = value;
                  setState(() {
                    exGender = result;
                  });
                });
              }),
        ),
      ),
    );
  }

  // ignore: prefer_typing_uninitialized_variables
  var size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoading1
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Form(
              key: _formKey,
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildCoverPicContainer(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 65, 15, 0),
                        child: buildNameTextFormField(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildUserNameTextFormField(),
                            if (e1)
                              usernameErrorMessage('Username is Already exist')
                            else if (e2)
                              usernameErrorMessage(
                                  'Username has restriction of maximum 4 Numerics & Lowercase Alphabets')
                            else if (e3)
                              usernameErrorMessage('Please enter a Username')
                          ],
                        ),
                      ),
                      if (isUserName)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: buildSubmitUsernameRequest(),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: buildWebsiteTextFormField(),
                      ),
                      buildBioTextFormField(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: buildGmailTextFormField(),
                      ),
                      if (isEmail)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: buildEmailChangeRequest(),
                        ),
                      buildPhoneNumberTextFormField(),
                      buildGenderTextFormField(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: buildDOBTextFormField(),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      buildDoneButton(),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                  buildProfileAvatar(),
                  buildChooseCoverPicButton(),
                ],
              ),
            )),
    );
  }
}

// ignore: must_be_immutable
class GenderSelectionBottomSheet extends StatefulWidget {
  BuildContext ctx;

  GenderSelectionBottomSheet(this.ctx, {super.key});

  @override
  State<GenderSelectionBottomSheet> createState() =>
      _GenderSelectionBottomSheetState();
}

class _GenderSelectionBottomSheetState
    extends State<GenderSelectionBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final size = MediaQuery.of(context).size;
    String? gender;
    int value = 0;
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(30, 0, 20, 0),
        //height: size.height * 0.6,
        width: size.width * 0.9,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 23, 23, 23),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Padding(
          padding: mediaQuery.viewInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.04,
                width: size.width,
                child: Align(
                  alignment: Alignment.center,
                  child: IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: Image.asset(
                        "images/icons/Vector 87.png",
                        height: 14,
                        width: 14,
                      ),
                      color: Colors.white,
                      iconSize: 20.0,
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ),
              ),
              Row(
                children: [
                  Text(
                    'Male',
                    style: GoogleFonts.mPlusRounded1c(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Radio(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.blue),
                      value: 1,
                      groupValue: value,
                      onChanged: (int? value) {
                        setState(() {
                          value = value!;
                          gender = 'Male';
                          Provider.of<ExtraUserDetail>(context, listen: false)
                              .submitGender(gender);
                        });
                      }),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Female',
                    style: GoogleFonts.mPlusRounded1c(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Radio(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.blue),
                      value: 2,
                      groupValue: value,
                      onChanged: (int? value) {
                        setState(() {
                          value = value!;
                          gender = 'Female';
                          Provider.of<ExtraUserDetail>(context, listen: false)
                              .submitGender(gender);
                        });
                      }),
                ],
              ),
              Padding(
                padding: mediaQuery.viewInsets,
                child: TextFormField(
                  onSaved: ((value) {
                    gender = value;
                  }),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Custom',
                    hintStyle: GoogleFonts.mPlusRounded1c(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    'Prefer not to say',
                    style: GoogleFonts.mPlusRounded1c(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Radio(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.blue),
                      focusColor: Colors.white,
                      hoverColor: Colors.white,
                      value: 3,
                      groupValue: value,
                      onChanged: (int? value) {
                        setState(() {
                          value = value!;
                          gender = 'Prefer not to say';
                          Provider.of<ExtraUserDetail>(context, listen: false)
                              .submitGender(gender);
                        });
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
