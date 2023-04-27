import 'package:filroll_app/screens/profile/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Privacy extends StatelessWidget {
  const Privacy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.black,
        leadingWidth: 100,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 8,
            ),
            SizedBox(
              //margin: const EdgeInsets.fromLTRB(12, 10, 5, 10),
              height: 25,
              width: 25,
              child: FittedBox(
                child: SvgPicture.asset(
                  "images/icons/Opened Lock.svg",
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              'Privacy',
              style: GoogleFonts.mPlusRounded1c(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()));
              },
              icon: const Icon(
                Icons.check,
                color: Color(0XFF0029FF),
              ))
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How Long We Keep Information',
              style: GoogleFonts.mPlusRounded1c(
                  color: const Color(0XFF0029FF),
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              'We keep different types of information for different periods of time: ',
              style: GoogleFonts.mPlusRounded1c(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              'We keep your profile information and content for the duration of your account.',
              style: GoogleFonts.mPlusRounded1c(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              'We generally keep other personally identifiable data we collect when you use our products and services for a maximum of 18 months.',
              style: GoogleFonts.mPlusRounded1c(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              'Remember public content can exist elsewhere even after you remove it from Twitter. For example, search engines and other third parties may retain copies of your Tweets longer, based upon their own privacy policies, even after they are deleted or expire on Twitter. You can read more about search visibility here.',
              style: GoogleFonts.mPlusRounded1c(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              'Where you violate our Rules and your account is suspended, we may keep the identifiers you used to create the account (i.e., email address or phone number) indefinitely to prevent repeat policy offenders from creating new accounts.',
              style: GoogleFonts.mPlusRounded1c(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              'We may keep certain information longer than our policies specify in order to comply with legal requirements and for safety and security reasons.',
              style: GoogleFonts.mPlusRounded1c(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              'We provide Twitter to people all over the world and provide many of the same privacy tools and controls to all of our users regardless of where they live. However, your experience may be slightly different than users in other countries to ensure Twitter respects local requirements.',
              style: GoogleFonts.mPlusRounded1c(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              'Expand dropdowns for more information:',
              style: GoogleFonts.mPlusRounded1c(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
