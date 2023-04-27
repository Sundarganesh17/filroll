import 'package:filroll_app/providers/google_sign_up.dart';
import 'package:filroll_app/screens/authentication/signup_screen.dart';
import 'package:filroll_app/widgets/login_auth_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 100, 2, 0),
            child: Text("Welcome",
                style: GoogleFonts.mPlusRounded1c(
                  color: Colors.white,
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                )),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 2, 0),
            child: Text("Back!",
                style: GoogleFonts.mPlusRounded1c(
                  color: Colors.white,
                  fontSize: 36.0,
                  //letterSpacing: 10,
                  fontWeight: FontWeight.bold,
                )),
          ),
          SizedBox(height: 20),
          LoginAuthCard(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF212226),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.44))),
                  onPressed: () {
                    Provider.of<GoogleSignUp>(context, listen: false)
                        .googleLogin(context);
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Image.asset(
                          "images/homepage/googlelogo.png",
                          height: 20,
                          width: 20,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('Continue with Google',
                          style: GoogleFonts.mPlusRounded1c(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          )),
                    ],
                  )),
            ],
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(90, 15, 2, 1),
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text("Create an account?",
                        style: GoogleFonts.mPlusRounded1c(
                          color: Colors.white,
                          fontSize: 13.0,
                          fontWeight: FontWeight.normal,
                        )),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupScreen()));
                    },
                    child: Text(
                      "Signup",
                      style: GoogleFonts.mPlusRounded1c(
                        color: Colors.blue,
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Row(
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.fromLTRB(
          //         80,
          //         20,
          //         1,
          //         1,
          //       ),
          //       child: Container(
          //           height: size.height * 0.05,
          //           width: size.width * 0.28,
          //           decoration:
          //               BoxDecoration(borderRadius: BorderRadius.circular(5)),
          //           child: ElevatedButton(
          //               style: ElevatedButton.styleFrom(
          //                   primary: Color(0xFF212226),
          //                   shape: RoundedRectangleBorder(
          //                       borderRadius: BorderRadius.circular(8.44))),
          //               onPressed: () {
          //                 Navigator.push(
          //                     context,
          //                     MaterialPageRoute(
          //                         builder: (context) => PhoneScreen()));
          //               },
          //               child: Padding(
          //                 padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          //                 child: IconButton(
          //                     icon: Image.asset(
          //                       "images/homepage/googlelogo.png",
          //                       height: 18,
          //                       width: 20,
          //                       fit: BoxFit.cover,
          //                     ),
          //                     color: Colors.white,
          //                     iconSize: 20.0,
          //                     onPressed: () {}),
          //               ))),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.fromLTRB(
          //         10,
          //         20,
          //         1,
          //         1,
          //       ),
          //       child: Container(
          //           height: size.height * 0.05,
          //           width: size.width * 0.28,
          //           decoration:
          //               BoxDecoration(borderRadius: BorderRadius.circular(5)),
          //           child: ElevatedButton(
          //               style: ElevatedButton.styleFrom(
          //                   primary: Color(0xFF212226),
          //                   shape: RoundedRectangleBorder(
          //                       borderRadius: BorderRadius.circular(8.44))),
          //               onPressed: () {
          //                 Navigator.push(
          //                     context,
          //                     MaterialPageRoute(
          //                         builder: (context) => PhoneScreen()));
          //               },
          //               child: Padding(
          //                 padding: const EdgeInsets.fromLTRB(
          //                   0,
          //                   0,
          //                   0,
          //                   0,
          //                 ),
          //                 child: IconButton(
          //                     icon: Image.asset(
          //                       "images/homepage/applelogo.png",
          //                       height: 18,
          //                       width: 20,
          //                       fit: BoxFit.cover,
          //                     ),
          //                     color: Colors.white,
          //                     iconSize: 20.0,
          //                     onPressed: () {}),
          //               ))),
          //     )
          //   ],
          // ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 2, 0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                " Read for the",
                style: GoogleFonts.mPlusRounded1c(
                    color: Colors.white, fontSize: 12.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 2, 2),
            child: Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                    ),
                    onPressed: () async {
                      final Uri toLaunch = Uri(
                          scheme: 'https',
                          host: 'filroll.com',
                          path: 'terms-and-conditions');
                      _launchInBrowser(toLaunch);
                    },
                    child: Text(
                      "Terms of Services",
                      style: GoogleFonts.mPlusRounded1c(
                        color: Color(0XFF1673FF),
                        fontSize: 12.0,
                        //fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  Text(
                    'and',
                    style: GoogleFonts.mPlusRounded1c(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Color(0XFF1673FF),
                    ),
                    onPressed: () {
                      final Uri toLaunch = Uri(
                          scheme: 'https',
                          host: 'filroll.com',
                          path: 'privacy-policy');
                      _launchInBrowser(toLaunch);
                    },
                    child: Text(
                      "Privacy Policy",
                      style: GoogleFonts.mPlusRounded1c(
                        color: Color(0XFF1673FF),
                        fontSize: 12.0,
                        //fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
