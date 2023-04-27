import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/providers/auth.dart';
import 'package:filroll_app/providers/google_sign_up.dart';
import 'package:filroll_app/screens/authentication/google_signup_screen.dart';
import 'package:filroll_app/screens/authentication/login_screen.dart';
import 'package:filroll_app/screens/post/link.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  Future<void> _submitAuthForm(
    String name,
    String userName,
    String email,
    String password,
  ) async {}

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 70, 1, 0),
              child: Text("Create an ",
                  style: GoogleFonts.mPlusRounded1c(
                    color: Colors.white,
                    fontSize: 36.0,
                    //letterSpacing: 10,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 1, 0),
              child: Text("account ",
                  style: GoogleFonts.mPlusRounded1c(
                    color: Colors.white,
                    fontSize: 36.0,
                    //letterSpacing: 10,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            AuthCard(_submitAuthForm),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(90, 15, 2, 1),
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text("Already Have account?",
                          style: GoogleFonts.mPlusRounded1c(
                            color: Colors.white,

                            fontSize: 13.0,

                            //letterSpacing: 10,

                            fontWeight: FontWeight.normal,
                          )),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: Text(
                        "Login",
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
                          .googleSignUp(context);
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
            )
          ],
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  final void Function(
      String name, String userName, String email, String password) submitFn;

  AuthCard(this.submitFn);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final _auth = FirebaseAuth.instance;
  var user;
  bool isLoading = false;
  String? name;
  String? userName;
  String? email;
  String? password;
  bool isPasswordVisible = true;
  bool isPasswordVisible1 = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var ref;

  @override
  void initState() {
    super.initState();
    ref = Provider.of<Auth>(context, listen: false);
    ref.userNameExists();
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
    )) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      await Provider.of<Auth>(context, listen: false).signUp(
          name!,
          userName!.toLowerCase(),
          _emailController.text,
          _passwordController.text,
          context);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Form(
        key: _formKey,
        child: Column(
          children: [
            //////////////////////////////////////// Name Field//////////////////////////////
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 6),
                width: size.width * .9,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5.0)),
                child: TextFormField(
                  key: const ValueKey('name'),
                  validator: ((value) {
                    if (value!.length < 2 || value.isEmpty) {
                      return 'Please enter a Name';
                    }
                    return null;
                  }),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: const Color(0xFF262626),
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(13.5),
                        height: 5,
                        width: 5,
                        child: FittedBox(
                          child: InkWell(
                            // radius: 1,
                            child: SvgPicture.asset(
                              "images/icons/Profile.svg",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      hintText: "Name",
                      border: InputBorder.none,
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(7, 14, 0, 0)),
                  onSaved: ((newValue) {
                    name = newValue;
                  }),
                ),
              ),
            ),
            //////////////////////////////////////// User Name Field//////////////////////////////
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: size.width * .9,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5.0)),
                child: TextFormField(
                  key: const ValueKey('userName'),
                  validator: ((value) {
                    var num = value!.replaceAll(new RegExp(r'[^0-9]'), '');
                    if (ref.username
                        .map((e) => e.toString())
                        .toList()
                        .contains(value)) {
                      return 'This username is already exist.';
                    } else if (value.isEmpty) {
                      return 'Please enter a username';
                    } else if (num.length >= 5) {
                      return 'Username has restriction of maximum 4 Numerics';
                    } else if (!value
                        .toLowerCase()
                        .contains(RegExp(r'[a-z]'))) {
                      return 'Username must be with Letters "a-z"';
                    }
                  }),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: const Color(0xFF262626),
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(13.5),
                        height: 5,
                        width: 5,
                        child: FittedBox(
                          child: InkWell(
                            child: SvgPicture.asset(
                              "images/icons/Profile.svg",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      hintText: "User Name",
                      border: InputBorder.none,
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      contentPadding: EdgeInsets.fromLTRB(7, 14, 0, 0)),
                  onSaved: ((newValue) {
                    userName = newValue;
                  }),
                ),
              ),
            ),
            //////////////////////////////////////// Password Field//////////////////////////////
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: size.width * .9,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5.0)),
                child: TextFormField(
                  key: const ValueKey('email'),
                  controller: _emailController,
                  validator: ((value) {
                    if (!value!.contains('@') || value.isEmpty) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  }),
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Color(0xFF262626),
                      prefixIcon: Container(
                        margin: EdgeInsets.all(13.5),
                        height: 5,
                        width: 5,
                        child: FittedBox(
                          child: InkWell(
                            // radius: 1,
                            child: SvgPicture.asset(
                              "images/icons/Mail.svg",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      hintText: "Email Address",
                      border: InputBorder.none,
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      contentPadding: EdgeInsets.fromLTRB(7, 14, 0, 0)),
                  onSaved: ((newValue) {
                    email = newValue;
                  }),
                ),
              ),
            ),
            //////////////////////////////////////// Confirm Password Field//////////////////////////////////
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: size.width * .9,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5.0)),
                child: TextFormField(
                  key: const ValueKey('password'),
                  obscureText: isPasswordVisible,
                  controller: _passwordController,
                  validator: ((value) {
                    if (value!.length < 8 || value.isEmpty) {
                      return 'Password must be atleast 8 Characters long.';
                    }
                    return null;
                  }),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: const Color(0xFF262626),
                      suffixIcon: IconButton(
                        icon: !isPasswordVisible
                            ? const Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                                size: 23,
                              )
                            : const Icon(
                                Icons.visibility,
                                color: Colors.grey,
                                size: 23,
                              ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      prefixIcon: Container(
                        margin: EdgeInsets.all(13.5),
                        height: 5,
                        width: 5,
                        child: FittedBox(
                          child: InkWell(
                            // radius: 1,
                            child: SvgPicture.asset(
                              "images/icons/Lock.svg",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      hintText: "Password",
                      border: InputBorder.none,
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      contentPadding: EdgeInsets.fromLTRB(7, 14, 0, 0)),
                  onSaved: ((newValue) {
                    password = newValue;
                  }),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                "By Signing up, You agree to our",
                style: GoogleFonts.mPlusRounded1c(
                  color: Colors.white,
                  fontSize: 13.0,
                  //letterSpacing: 3.0,
                  fontWeight: FontWeight.normal,
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.5),
                      child: Text(
                        'and',
                        style: GoogleFonts.mPlusRounded1c(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                        ),
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
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        // ignore: sort_child_properties_last
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(100, 5, 100, 5),
                          child: Text(
                            "Sign Up",
                            style: GoogleFonts.mPlusRounded1c(
                              color: Colors.white,
                              fontSize: 17.0,
                              //letterSpacing: 3.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2900FF),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.44))),
                        // onPressed:
                        // _trySubmit,
                        onPressed: _trySubmit,
                      ),
              ),
            ),
          ],
        ));
  }
}
