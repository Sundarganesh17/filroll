import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/screens/profile/grid_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Saved extends StatelessWidget {
  const Saved({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
          child: Container(
        //margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(12, 10, 5, 10),
                  height: 19,
                  width: 19,
                  child: FittedBox(
                    child: SvgPicture.asset(
                      "images/icons/Saved.svg",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(
                  width: 0,
                ),
                Text('Saved',
                    style: GoogleFonts.mPlusRounded1c(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold))
              ],
            ),
            SizedBox(
              height: 5,
            ),
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('Saved posts')
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            SizedBox(
                              height: 250,
                            ),
                            Text(
                              'There is no Saved Posts yet',
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
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 1.5,
                                childAspectRatio: 1),
                        itemBuilder: (context, index) {
                          DocumentSnapshot snap = snapshot.data!.docs[index];
                          return GridSaved(snap: snap);
                        },
                      );
              },
            ),
          ],
        ),
      )),
    );
  }
}
