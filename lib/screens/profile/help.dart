import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/providers/report.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final reportedNameController = TextEditingController();
  final reportedusernameController = TextEditingController();
  final reportBodyController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    Padding buildContainer(String hintText, cntlr) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Container(
          height: size.height * 0.055,
          width: size.width * .9,
          decoration: BoxDecoration(
              color: const Color(0xFF1A1920),
              borderRadius: BorderRadius.circular(13)),
          child: TextFormField(
            controller: cntlr,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                hintStyle: GoogleFonts.mPlusRounded1c(
                  fontSize: 14,
                  color: const Color(0XFF6B6B6C),
                  fontWeight: FontWeight.bold,
                ),
                contentPadding: EdgeInsets.fromLTRB(14, 0, 0, 5)),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 20, 0, 0),
              child: Text(
                'User Report',
                style: GoogleFonts.mPlusRounded1c(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'Your Name, Username',
                style: GoogleFonts.mPlusRounded1c(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
            buildContainer('Your Name', nameController),
            buildContainer('@Username', usernameController),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'Report',
                style: GoogleFonts.mPlusRounded1c(
                    color: const Color(0XFFE20000),
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            buildContainer('Report Name', reportedNameController),
            buildContainer('@Username', reportedusernameController),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Container(
                height: size.height * 0.2,
                width: size.width * .9,
                decoration: BoxDecoration(
                    color: const Color(0xFF1A1920),
                    borderRadius: BorderRadius.circular(13)),
                child: TextFormField(
                  controller: reportBodyController,
                  maxLines: 7,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: 'Tell Your Report',
                      border: InputBorder.none,
                      hintStyle: GoogleFonts.mPlusRounded1c(
                        fontSize: 14,
                        color: const Color(0XFF6B6B6C),
                        fontWeight: FontWeight.bold,
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(14, 8, 0, 5)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'Filroll Help Center',
                style: GoogleFonts.mPlusRounded1c(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: ElevatedButton(
                // ignore: sort_child_properties_last
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          "Report",
                          style: GoogleFonts.mPlusRounded1c(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0XFFE20000),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7))),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await Provider.of<ReportProvider>(context, listen: false)
                      .sendEmail(
                          name: nameController.text,
                          username: usernameController.text,
                          reportedName: reportedNameController.text,
                          reportedUsername: reportedusernameController.text,
                          reportBody: reportBodyController.text);
                  setState(() {
                    isLoading = false;
                  });
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Your Report was succesfully submitted')));
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}
