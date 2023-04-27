import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/providers/post.dart';
import 'package:filroll_app/providers/profile.dart';
import 'package:filroll_app/screens/profile/grid_images.dart';
import 'package:filroll_app/widgets/profile_posts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomGridView extends StatefulWidget {
  final uid;

  BottomGridView({
    required this.uid,
  });

  @override
  State<BottomGridView> createState() => _BottomGridViewState();
}

class _BottomGridViewState extends State<BottomGridView> {
  var snap;
  bool isLoading = true;
  bool isEmpty = false;
  String postUrl = '';
  bool isLoad = false;
  var postref;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    Provider.of<ProfileProvider>(context, listen: false)
        .fetchPostImages(widget.uid);
    //if (snap.docs.length == 0) setState(() => isEmpty = true);
    // setState(() {
    //   isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    postref = Provider.of<ProfileProvider>(context);
    var length = postref.postImages.length;
    setState(() {
      isLoading = false;
    });
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : length == 0
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'There is no posts yet',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Text(
                      'Let\'s add',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                itemCount: postref.postImages.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 1),
                itemBuilder: (context, index) {
                  return GridImages(
                    snap: postref.postImages[index],
                    feedsnap: postref.postImages,
                  );
                });
  }
}

class BottomGridView1 extends StatelessWidget {
  final post;
  const BottomGridView1({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'There is no $post yet',
            style: const TextStyle(color: Colors.white),
          ),
          const Text(
            'Let\'s add',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class BottomGridView3 extends StatelessWidget {
  const BottomGridView3({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('Favorite posts')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return snapshot.data!.docs.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'There is no Favorites yet',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Let\'s add',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 1.5,
                    childAspectRatio: 1),
                itemBuilder: (context, index) {
                  DocumentSnapshot snap = snapshot.data!.docs[index];

                  return GridFav(
                    snap: snap,
                  );
                },
              );
      },
    );
  }
}

// ignore: must_be_immutable
class BottomGridViewForVideos extends StatefulWidget {
  final uid;

  const BottomGridViewForVideos({super.key, required this.uid});
  @override
  State<BottomGridViewForVideos> createState() =>
      _BottomGridViewForVideosState();
}

class _BottomGridViewForVideosState extends State<BottomGridViewForVideos> {
  bool isLoading = true;
  bool isEmpty = false;
  var postref;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    Provider.of<ProfileProvider>(context, listen: false)
        .fetchPostVideos(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    postref = Provider.of<ProfileProvider>(context);
    var length = postref.postVideos.length;
    setState(() {
      isLoading = false;
    });
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : length == 0
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'There is no Videos yet',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Text(
                      'Let\'s add',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                itemCount: postref.postVideos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                    childAspectRatio: 1.5),
                itemBuilder: (context, index) {
                  return GridVideos(
                    snap: postref.postVideos[index],
                    feedsnap: postref.postVideos,
                  );
                });
  }
}

class BottomGridView5 extends StatelessWidget {
  const BottomGridView5({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    Widget buildRow() {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              height: size.height * 0.23,
              width: size.width * 0.315, //color: Colors.white,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                // color: Colors.amber
                image: DecorationImage(
                    image: NetworkImage(
                      "https://images.unsplash.com/photo-1609418426663-8b5c127691f9?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyNXx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
                    ),
                    fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              height: size.height * 0.23,
              width: size.width * 0.315, //color: Colors.white,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                // color: Colors.amber
                image: DecorationImage(
                    image: NetworkImage(
                        "https://i.pinimg.com/originals/04/39/c2/0439c2ed6491597b214bf8699a28396f.jpg"),
                    fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              height: size.height * 0.23,
              width: size.width * 0.315,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                //color: Colors.amber
                image: DecorationImage(
                    image: NetworkImage(
                      "https://cdn.luxatic.com/wp-content/uploads/2021/03/John-Legend.jpg",
                    ),
                    fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      );
    }

    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            buildRow(),
            buildRow(),
            buildRow(),
            buildRow(),
            buildRow()
          ],
        ),
      ),
    );
  }
}

class Tile {
  String imgUrl;

  Tile(this.imgUrl);
}
