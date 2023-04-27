import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:filroll_app/screens/search/search_posts_feed_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchVideos extends StatefulWidget {
  final snap;
  final feedsnap;
  const SearchVideos({super.key, required this.snap, this.feedsnap});

  @override
  State<SearchVideos> createState() => _SearchVideosState();
}

class _SearchVideosState extends State<SearchVideos> {
  String thumb = '';

  @override
  void initState() {
    super.initState();
    getThumb();
  }

  getThumb() async {
    var thu = await getUrl(widget.snap.thumbnail);
    setState(() {
      thumb = thu;
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
    return GestureDetector(
      onTap: () {
        Get.to(SearchPostsFeedList(feedsnap: widget.feedsnap),
            transition: Transition.circularReveal);
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => SearchPostsFeedList(feedsnap: widget.feedsnap),
        // ));
      },
      child: Stack(alignment: Alignment.center, children: [
        Container(
          margin: EdgeInsets.fromLTRB(0, 8, 4, 4),
          width: 270,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.black,
              image: DecorationImage(
                  image: NetworkImage(
                    thumb,
                  ),
                  fit: BoxFit.cover)),
        ),
        Icon(
          Icons.play_arrow,
          color: Colors.white,
        ),
      ]),
    );
  }
}

class SeachImages extends StatefulWidget {
  final snap;
  final feedsnap;
  const SeachImages({super.key, required this.snap, this.feedsnap});

  @override
  State<SeachImages> createState() => _SeachImagesState();
}

class _SeachImagesState extends State<SeachImages> {
  String img = '';

  @override
  void initState() {
    super.initState();
    getImg();
  }

  getImg() async {
    var thu = await getUrl(widget.snap.postUrl);
    setState(() {
      img = thu;
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
    return GestureDetector(
      onTap: () {
        Get.to(SearchPostsFeedList(feedsnap: widget.feedsnap),
            transition: Transition.circularReveal);
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => SearchPostsFeedList(feedsnap: widget.feedsnap),
        // ));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey,
            image:
                DecorationImage(image: NetworkImage(img), fit: BoxFit.cover)),
      ),
    );
  }
}
