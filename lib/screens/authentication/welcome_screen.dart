import 'package:filroll_app/screens/authentication/login_screen.dart';
import 'package:filroll_app/screens/authentication/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
              //boxShadow: [BoxShadow(color: Color(0xFF7205FF))],
              image: DecorationImage(
            image: AssetImage(
              "images/homepage/Group.png",
            ),
            fit: BoxFit.cover,
          )),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * 0.3,
              width: size.width,
              decoration: BoxDecoration(
                  boxShadow: [
                    //BoxShadow(color: Color(0xFF7205FF)),
                  ],
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0XFF3F3D3D).withOpacity(0.72),
                        Color(0XFF000000).withOpacity(1),
                        Color(0XFF000000).withOpacity(1),
                      ])),
              child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text("Welcome",
                        style: GoogleFonts.mPlusRounded1c(
                          color: Colors.white,
                          fontSize: 40.0,
                          //letterSpacing: 10,
                          fontWeight: FontWeight.w800,
                        )),
                    Text(
                      "FilRoll",
                      style: GoogleFonts.mPlusRounded1c(
                        // color: Colors.white,
                        fontSize: 60.0,
                        //letterSpacing: 10,
                        fontWeight: FontWeight.w800,
                        foreground: Paint()
                          ..shader = LinearGradient(
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                              colors: <Color>[
                                Color(0xFF7205FF),
                                Color(0xFF7205FF),
                                Color(0xFFDB8DFF),
                                Color(0xFFDB8DFF),
                              ]).createShader(Rect.fromLTWH(0, 0, 350, 0)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(1, 0, 0, 0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: size.height * 0.049,
                              width: size.width * 0.35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18)),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary:
                                          Color(0xFF212226).withOpacity(0.9),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.44))),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignupScreen()));
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(1, 1, 1, 1),
                                    child: Text(
                                      "Sign Up",
                                      style: GoogleFonts.mPlusRounded1c(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        //letterSpacing: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: size.height * 0.049,
                                width: size.width * 0.35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: Colors.white,
                                ),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        side: BorderSide(
                                            width: 0.3, color: Colors.white),
                                        backgroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.44))),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (ctx) => LoginScreen()));
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(1, 1, 1, 1),
                                      child: Text(
                                        "Login",
                                        style: GoogleFonts.mPlusRounded1c(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          //letterSpacing: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
