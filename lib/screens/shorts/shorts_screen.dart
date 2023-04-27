import 'package:filroll_app/screens/shorts/shorts_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ShortsScreen extends StatefulWidget {
  int pagenumber;
  ShortsScreen(this.pagenumber);
  @override
  State<ShortsScreen> createState() => _ShortsScreenState();
}

class _ShortsScreenState extends State<ShortsScreen> {
  List videourl = [
    'https://static.videezy.com/system/resources/previews/000/044/285/original/Mail-Digital-Network-2.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-waves-in-the-water-1164-large.mp4',
    'https://static.videezy.com/system/resources/previews/000/052/814/original/futuristic-digital-big-data-processing-technology.mp4'
  ];
  VideoPlayerController _videoPlayerController = VideoPlayerController.network(
      'https://static.videezy.com/system/resources/previews/000/044/285/original/Mail-Digital-Network-2.mp4');
  int pageinde =0;
  @override
  void initState() {
    super.initState();
    //videogetter();
    pageinde=widget.pagenumber;
  }

  void videogetter() async {
    _videoPlayerController = VideoPlayerController.network(videourl[pageinde])
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(false)
      ..initialize().then((_) => _videoPlayerController.play());
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaqurey = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
              body: PageView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: videourl.length,
                  // onPageChanged: (val) {
                  //  pageinde = val;
                  //  videogetter();
                  //      print(val+1);
                  // },
                  controller:
                      PageController(initialPage: pageinde, viewportFraction: 1,),
                  itemBuilder: (context, index) {
                    return  ShortsWidget(videourl[index]);
                  }),
            ),
    );
  }
}
