import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/providers/post.dart';
import 'package:filroll_app/screens/search/search_user.dart';
import 'package:filroll_app/screens/search/search_widgets.dart';
import 'package:filroll_app/widgets/btm_navigation_bar.dart';
import 'package:filroll_app/providers/auth.dart';
import 'package:filroll_app/screens/animation.dart';
import 'package:filroll_app/screens/profile/others_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String dpUrl = '';
  String dpUrl1 = '';
  var searchController = TextEditingController();
  bool isShowUsers = false;
  bool isLoading = true;
  var ref;
  var tag;
  var size;
  var postRef;
  var videoSnap;
  var imageSnap;

  @override
  void initState() {
    super.initState();
    getDp();
    getVideos();
    getImages();
    fetchPosts();
  }

  fetchPosts() async {
    Provider.of<Post>(context, listen: false).fetchSearchImages();
    Provider.of<Post>(context, listen: false).fetchSearchVideos();
    setState(() {});
  }

  getVideos() async {
    var ex = await FirebaseFirestore.instance
        .collection('posts')
        .where('isVideo', isEqualTo: true)
        .get();
    setState(() {
      videoSnap = ex;
    });
  }

  getImages() async {
    var ex = await FirebaseFirestore.instance
        .collection('posts')
        .where('isVideo', isEqualTo: false)
        .get();
    setState(() {
      imageSnap = ex;
    });
  }

  void getDp() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    ref = await Provider.of<Auth>(context, listen: false);
    var dp = await getUrl('dp-${FirebaseAuth.instance.currentUser!.uid}.jpg');
    setState(() {
      dpUrl = dp;
      dpUrl1 = (snap.data() as Map<String, dynamic>)['DPUrl'];
    });

    var hashtag = await FirebaseFirestore.instance
        .collection('Hashtag')
        .orderBy('hashtag', descending: true)
        .get();
    if (hashtag.docs.isNotEmpty) {
      setState(() {
        tag = hashtag.docs.map((e) => e.data()).toList();
        isLoading = false;
      });
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

  Widget buildSearchResult() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .where('username', isGreaterThanOrEqualTo: searchController.text)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return searchController.text.isEmpty
              ? SizedBox()
              : ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return SearchUser(snap: snapshot.data!.docs[index]);
                  },
                );
        },
      ),
    );
  }

  Widget buildTagContainer() {
    return Container(
      padding: const EdgeInsets.fromLTRB(40, 20, 20, 20),
      height: size.height * 0.201,
      width: double.infinity,
      decoration: BoxDecoration(
          color: const Color(0XFF1A1920),
          borderRadius: BorderRadius.circular(15)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 5,
                  crossAxisCount: 2,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2),
              itemCount: 8,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tag[index]['hashtagname'],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildVideoSection() {
    return Container(
      height: 190,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => SearchVideos(
          snap: postRef.postVideos[index],
          feedsnap: postRef.postVideos,
        ),
        itemCount: postRef.postVideos.length,
      ),
    );
  }

  Widget buildImages() {
    return Container(
      margin:
          videoSnap.docs.isEmpty ? EdgeInsets.only(top: 7) : EdgeInsets.zero,
      child: GridView.custom(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        gridDelegate: SliverQuiltedGridDelegate(
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          repeatPattern: QuiltedGridRepeatPattern.inverted,
          pattern: [
            QuiltedGridTile(2, 2),
            QuiltedGridTile(1, 1),
            QuiltedGridTile(1, 1),
            QuiltedGridTile(1, 2)
          ],
        ),
        childrenDelegate: SliverChildBuilderDelegate(
          (context, index) => SeachImages(
            snap: postRef.postImages[index],
            feedsnap: postRef.postImages,
          ),
          childCount: postRef.postImages.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    postRef = Provider.of<Post>(context);
    size = MediaQuery.of(context).size;
    int selectedindex = 0;

    return isLoading
        ? const AnimationPage(picName: 'Search4')
        : Scaffold(
            appBar: AppBar(
              toolbarHeight: 52,
              backgroundColor: Colors.black,
              leading: GestureDetector(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: !dpUrl1.contains('https')
                      ? CircleAvatar(
                          radius: 17, backgroundImage: NetworkImage(dpUrl))
                      : CircleAvatar(
                          radius: 17,
                          backgroundImage: NetworkImage(
                            "https://as2.ftcdn.net/v2/jpg/03/31/69/91/1000_F_331699188_lRpvqxO5QRtwOM05gR50ImaaJgBx68vi.jpg",
                          ),
                        ),
                ),
                onTap: () async {},
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 3),
                  child: Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.only(right: 50),
                    height: 10,
                    width: size.width * 0.70,
                    decoration: BoxDecoration(
                        color: const Color(0XFF1A1920),
                        borderRadius: BorderRadius.circular(20)),
                    child: TextFormField(
                      onTap: () {
                        setState(() {
                          isShowUsers = true;
                        });
                        ref.userNameExists();
                      },
                      controller: searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                        contentPadding: EdgeInsets.fromLTRB(20, 2, 0, 15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 55,
                ),
              ],
            ),
            backgroundColor: Colors.black,
            body: isShowUsers
                ? buildSearchResult()
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                            child: const Text(
                              'Trending...',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          buildTagContainer(),
                          if (videoSnap.docs.isNotEmpty) buildVideoSection(),
                          buildImages(),
                        ],
                      ),
                    ),
                  ),
            bottomNavigationBar: BtmNavigationBar(),
          );
  }
}
