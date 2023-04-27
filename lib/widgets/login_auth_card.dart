import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/providers/auth.dart';
import 'package:filroll_app/screens/authentication/forgot_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginAuthCard extends StatefulWidget {
  @override
  State<LoginAuthCard> createState() => _LoginAuthCardState();
}

class _LoginAuthCardState extends State<LoginAuthCard> {
  String? email;
  String? password;
  bool isPasswordVisible = true;
  bool isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var user;
  //String userUid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    final alphanumeric = RegExp(r'^[0-9]+$');

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      if (_emailController.text.contains('@')) {
        setState(() {
          email = _emailController.text;
        });
      } else if (alphanumeric.hasMatch(_emailController.text)) {
        try {
          var snap = await FirebaseFirestore.instance
              .collection('users')
              .where('phonenumber', isEqualTo: _emailController.text)
              .get();
          setState(() {
            email = snap.docs[0]['email'];
          });
        } catch (e) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'There is no Corresponding user with this Mobile Number'),
              backgroundColor: Theme.of(context).errorColor,
            ),
          );
        }
      } else {
        try {
          var snap = await FirebaseFirestore.instance
              .collection('users')
              .where('username', isEqualTo: _emailController.text.toLowerCase())
              .get();
          print(snap.docs[0]['email']);
          setState(() {
            email = snap.docs[0]['email'];
          });
        } catch (e) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('There is no Corresponding user with this username'),
              backgroundColor: Theme.of(context).errorColor,
            ),
          );
        }
      }
      await Provider.of<Auth>(context, listen: false)
          .login(email!.toLowerCase(), _passwordController.text, context);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  if (value!.isEmpty) {
                    return 'Please enter a valid email address';
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
                            "images/icons/Mail.svg",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    hintText: "Username, Email, Phone number",
                    border: InputBorder.none,
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(7, 14, 0, 0)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              //height: size.height * 0.06,
              width: size.width * .9,
              decoration: BoxDecoration(
                  color: Colors.black,
                  //color: Color(0xFF262626),
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
                      margin: const EdgeInsets.all(13.5),
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
                    contentPadding: const EdgeInsets.fromLTRB(7, 14, 0, 0)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 2, 1),
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgotPassword()));
              },
              child: Text(
                "Forgot password?",
                textAlign: TextAlign.start,
                style: GoogleFonts.mPlusRounded1c(
                  color: Colors.white,
                  fontSize: 11.0,
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : Container(
                    height: size.height * 0.045,
                    width: size.width * 0.8,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0029FF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.44))),
                      onPressed: _trySubmit,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(100, 1, 1, 1),
                        child: Row(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Login",
                                style: GoogleFonts.mPlusRounded1c(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                                padding: const EdgeInsets.all(2),
                                icon: const Icon(
                                  Icons.arrow_forward,
                                ),
                                color: Colors.white,
                                iconSize: 20.0,
                                onPressed: () {})
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
