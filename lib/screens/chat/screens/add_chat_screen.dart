import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/screens/chat/widgets/add_chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddChatScreen extends StatefulWidget {
  const AddChatScreen({super.key});

  @override
  State<AddChatScreen> createState() => _AddChatScreenState();
}

class _AddChatScreenState extends State<AddChatScreen> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Row(children: [
          SizedBox(width: 25),
          InkWell(
            child: Icon(Icons.arrow_back),
            onTap: () => Navigator.of(context).pop(),
          ),
        ]),
        title: Text(
          'Add a chat User',
          style: GoogleFonts.roboto(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 35, vertical: 5),
              padding: EdgeInsets.only(right: 50),
              height: 32,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color(0XFFDCDDE0),
                  borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                controller: searchController,
                style: GoogleFonts.mPlusRounded1c(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.mPlusRounded1c(
                        fontSize: 14,
                        color: Color.fromARGB(255, 101, 99, 99),
                        fontWeight: FontWeight.bold),
                    contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 13)),
              ),
            ),
            Container(
              height: size.height * 0.84,
              padding: const EdgeInsets.only(top: 8.0),
              child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username',
                        isGreaterThanOrEqualTo: searchController.text)
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
                          itemCount: snapshot.data!.docs.length >= 7
                              ? 7
                              : snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: AddChatWidget(
                                  snap: snapshot.data!.docs[index]),
                            );
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
