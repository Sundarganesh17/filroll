import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_storage_path/flutter_storage_path.dart';
import 'package:video_player/video_player.dart';
import 'package:video_trimmer/video_trimmer.dart';

class VideoEditingScreen extends StatefulWidget {
  String? path;
  VideoEditingScreen(this.path);
  @override
  State<VideoEditingScreen> createState() => _VideoEditingScreenState();
}

class _VideoEditingScreenState extends State<VideoEditingScreen> {
  final Trimmer _trimmer = Trimmer();
  String? trimmedvideo;
  var isPlaying = false;
  var startValue = 0.0;
  var endValue = 0.10;
  VideoPlayerController? videocontroller;
  @override
  void initState() {
    super.initState();
    loadVideo();
  }

  void videogetter() async {
    videocontroller = VideoPlayerController.file(File(trimmedvideo!))
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(false)
      ..initialize().then((_) => videocontroller!.play());
  }

  void loadVideo() async {
    _trimmer.loadVideo(videoFile: File(widget.path!));
  }

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: mediaquery.height * 0.45,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  VideoViewer(trimmer: _trimmer),
                  Column(children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          bool playState = await _trimmer.videoPlaybackControl(
                            startValue: startValue,
                            endValue: endValue,
                          );
                          setState(() {
                            isPlaying = !isPlaying;
                          });
                        },
                        child: Expanded(
                          child: Container(
                            child: isPlaying
                                ? Center(child: Icon(Icons.play_arrow))
                                : Container(),
                          ),
                        ),
                      ),
                    ),
                    TrimViewer(
                      editorProperties: TrimEditorProperties(
                        circleSizeOnDrag: 6,
                        borderPaintColor: Colors.lightBlue,
                        borderWidth: 1.5,
                      ),
                      areaProperties: TrimAreaProperties(
                          blurEdges: true,
                          startIcon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 28,
                          )),
                      trimmer: _trimmer,
                      viewerWidth: mediaquery.width * 0.95,
                      viewerHeight: 30,
                      maxVideoLength: Duration(
                          seconds: _trimmer
                              .videoPlayerController!.value.duration.inSeconds),
                      type: ViewerType.fixed,
                      onChangeStart: (Value) {
                        startValue = Value;
                      },
                      onChangeEnd: (Value) {
                        endValue = Value;
                      },
                      onChangePlaybackState: (Playing) {
                        isPlaying = Playing;
                      },
                    ),
                  ]),
                ],
              ),
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    _trimmer.saveTrimmedVideo(
                      startValue: startValue,
                      endValue: endValue,
                      onSave: (outputPath) {
                        trimmedvideo = outputPath;
                        print(trimmedvideo);
                        videogetter();
                      },
                    );
                  },
                  child: Text('trim')),
            ),
            SizedBox(
              height: 50,
            ),
            trimmedvideo == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Center(
                    child: Container(
                    child: AspectRatio(
                      aspectRatio: videocontroller!.value.aspectRatio,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          VideoPlayer(videocontroller!),
                        ],
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
