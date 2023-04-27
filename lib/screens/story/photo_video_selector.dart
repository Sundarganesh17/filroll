import 'package:filroll_app/screens/story/post_story_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoVideoSelector extends StatelessWidget {
  const PhotoVideoSelector({super.key});

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

  Future<void> _chooseVideo(BuildContext context) async {
    final videoFile = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );
    if (videoFile == null) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PostStoryPage(
                pickedFile: videoFile,
                isVideo: true,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
          height: 80,
          width: 200,
          decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () => _choosePicture(context),
                  child: Text('Photo'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 53, 53, 53)),
                ),
                const SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                    onPressed: () => _chooseVideo(context),
                    child: Text('Video'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 53, 53, 53)))
              ],
            ),
          )),
    );
  }
}
