import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ProfilePosts extends StatefulWidget {
  final snap;
  const ProfilePosts({super.key, required this.snap});

  @override
  State<ProfilePosts> createState() => _ProfilePostsState();
}

class _ProfilePostsState extends State<ProfilePosts> {
  VideoPlayerController? controller;
  ChewieController? chewieController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controllerInitiation();
  }

  void controllerInitiation() async {
    var postUrl = await getUrl(widget.snap['postUrl']);
    controller = VideoPlayerController.network(
      postUrl,
    )..initialize().then((_) {
        setState(() {});
      });
    setState(() {
      chewieController = ChewieController(
        videoPlayerController: controller!,
        looping: true,
      );
      isLoading = false;
    });
  }

  Future<String> getUrl(String key) async {
    try {
      final result = await Amplify.Storage.getUrl(key: key);
      return result.url;
    } catch (e) {
      throw e;
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
            ),
            body: ClipRRect(
              child: Center(
                child: AspectRatio(
                  aspectRatio: controller!.value.aspectRatio,
                  child: !controller!.value.isInitialized
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Chewie(
                          controller: chewieController!,
                        ),
                ),
              ),
            ),
          );
  }
}

class ProfilePostImage extends StatefulWidget {
  var snap;
  ProfilePostImage({super.key, required this.snap});
  @override
  State<ProfilePostImage> createState() => _ProfilePostImageState();
}

class _ProfilePostImageState extends State<ProfilePostImage> {
  String? postUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getPost();
  }

  getPost() async {
    var post = await getUrl(widget.snap['postUrl']);
    setState(() {
      postUrl = post;
      isLoading = false;
    });
  }

  Future<String> getUrl(String key) async {
    try {
      final result = await Amplify.Storage.getUrl(key: key);
      return result.url;
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
            ),
            body: ClipRRect(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(postUrl!), fit: BoxFit.contain)),
                ),
              ),
            ),
          );
  }
}
