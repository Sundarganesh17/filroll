import 'package:camera/camera.dart';
import 'package:filroll_app/screens/shorts/suggestion_screen.dart';
import 'package:filroll_app/screens/story/post_story_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'camera_page.dart';
import 'gallery_screen.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

class AddPostVideoStoriesBar extends StatefulWidget {
  const AddPostVideoStoriesBar({super.key});

  @override
  State<AddPostVideoStoriesBar> createState() => _AddPostVideoStoriesBarState();
}

class _AddPostVideoStoriesBarState extends State<AddPostVideoStoriesBar> {
  

  Future<void> _choosePicture(BuildContext context) async {
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (imageFile == null) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PostStoryPage(
                pickedFile: imageFile,
                isVideo: false,
              )));
    }
  }

  void permissionforstorage()async{              
   var status= await ph.Permission.storage.status;
   if(!status.isGranted){
    ph.Permission.storage.request();
   }
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: size.width * 0.3, vertical: size.height * 0.087),
        height: size.height * 0.1,
        decoration: BoxDecoration(
          color: const Color(0XFF000000),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () async {
                permissionforstorage();    
                 Navigator.of(context).push(MaterialPageRoute(builder: (context) =>GalleryScreen(imageindex: 0),));  
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 25,
                    width: 25,
                    child: SvgPicture.asset(
                      "images/icons/Image.svg",
                      fit: BoxFit.fill,
                    ),
                  ),
                  Text(
                    "Post",
                    style: GoogleFonts.mPlusRounded1c(
                      color: Colors.white, wordSpacing: 0.3,
                      fontSize: 9.0,
                      //letterSpacing: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _choosePicture(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    height: 26,
                    width: 26,
                    child: SvgPicture.asset(
                      "images/icons/Plus(2).svg",
                      fit: BoxFit.fill,
                    ),
                  ),
                  Text(
                    "Story",
                    style: GoogleFonts.mPlusRounded1c(
                      color: Colors.white,
                      wordSpacing: 0.3,
                      fontSize: 9.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SuggestionScreen()));
                },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    height: 26,
                    width: 26,
                    child: SvgPicture.asset(
                      "images/icons/Plus(2).svg",
                      fit: BoxFit.fill,
                    ),
                  ),
                  Text(
                    "Short",
                    style: GoogleFonts.mPlusRounded1c(
                      color: Colors.white,
                      wordSpacing: 0.3,
                      fontSize: 9.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
