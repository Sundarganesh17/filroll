import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/screens/post/view_post.dart';
import 'package:filroll_app/screens/search/search_posts_feed_list.dart';
import 'package:filroll_app/widgets/profile_posts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class GridImages extends StatefulWidget {
  var snap;
  final feedsnap;
  GridImages({super.key, required this.snap, this.feedsnap});

  @override
  State<GridImages> createState() => _GridImagesState();
}

class _GridImagesState extends State<GridImages> {
  String postImg = '';

  @override
  void initState() {
    super.initState();
    fetchPostImg();
  }

  fetchPostImg() async {
    var post = await getUrl(widget.snap.postUrl);
    setState(() {
      postImg = post;
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
    return postImg.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SearchPostsFeedList(
                feedsnap: widget.feedsnap,
              ),
            )),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                      image: NetworkImage(postImg), fit: BoxFit.cover)),
            ),
          );
  }
}

class GridVideos extends StatefulWidget {
  final snap;
  final feedsnap;
  const GridVideos({super.key, required this.snap, this.feedsnap});

  @override
  State<GridVideos> createState() => _GridVideosState();
}

class _GridVideosState extends State<GridVideos> {
  String thumb = '';

  @override
  void initState() {
    super.initState();
    fetchPostImg();
  }

  fetchPostImg() async {
    var post = await getUrl(widget.snap.thumbnail);
    setState(() {
      thumb = post;
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
    return thumb.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : GestureDetector(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 43, 43, 43),
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                          image: NetworkImage(thumb), fit: BoxFit.cover)),
                ),
                Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 30,
                )
              ],
            ),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SearchPostsFeedList(
                feedsnap: widget.feedsnap,
              ),
            )),
          );
  }
}

class GridFav extends StatefulWidget {
  final snap;
  const GridFav({super.key, required this.snap});

  @override
  State<GridFav> createState() => _GridFavState();
}

class _GridFavState extends State<GridFav> {
  String postUrl = '';
  String thumb = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!widget.snap['isVideo']) getImg();
    if (widget.snap['isVideo']) getThumb();
  }

  getImg() async {
    var thu = await getUrl(widget.snap['postUrl']);
    setState(() {
      postUrl = thu;
    });
  }

  getThumb() async {
    var thu = await getUrl(widget.snap['thumbnail']);
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
    return widget.snap['isVideo']
        ? GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfilePosts(snap: widget.snap),
            )),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                          image: NetworkImage(thumb), fit: BoxFit.cover)),
                ),
                Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 30,
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Image.asset(
                    "images/icons/Favo.png",
                    height: 16,
                    width: 16,
                    fit: BoxFit.fill,
                  ),
                )
              ],
            ),
          )
        : Stack(
            children: [
              GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                          image: NetworkImage(postUrl), fit: BoxFit.cover)),
                ),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfilePostImage(
                    snap: widget.snap,
                  ),
                )),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Image.asset(
                  "images/icons/Favo.png",
                  height: 15,
                  width: 15,
                  fit: BoxFit.fill,
                ),
              )
            ],
          );
  }
}

class GridSaved extends StatefulWidget {
  final snap;
  const GridSaved({super.key, required this.snap});

  @override
  State<GridSaved> createState() => _GridSavedState();
}

class _GridSavedState extends State<GridSaved> {
  String postUrl = '';
  String thumb = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!widget.snap['isVideo']) getImg();
    if (widget.snap['isVideo']) getThumb();
  }

  getImg() async {
    var thu = await getUrl(widget.snap['postUrl']);
    setState(() {
      postUrl = thu;
    });
  }

  getThumb() async {
    var thu = await getUrl(widget.snap['thumbnail']);
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
    return widget.snap['isVideo']
        ? GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfilePosts(snap: widget.snap),
            )),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                          image: NetworkImage(thumb), fit: BoxFit.cover)),
                ),
                Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
          )
        : GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                      image: NetworkImage(postUrl), fit: BoxFit.cover)),
            ),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfilePostImage(
                snap: widget.snap,
              ),
            )),
          );
  }
}
