// ignore_for_file: prefer_const_constructors
import 'package:filroll_app/screens/authentication/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  Future resetPassword() async {
    try {
      final isValid = _formKey.currentState!.validate();
      FocusScope.of(context).unfocus();
      if (isValid) {
        setState(() {
          isLoading = true;
        });
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: _emailController.text.trim());
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Password reset Email has been send to ${_emailController.text}')));
        setState(() {
          isLoading = false;
        });
        // ignore: use_build_context_synchronously
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Scaffold(
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 100, 2, 1),
                    child: Text("Forgot ",
                        style: GoogleFonts.mPlusRounded1c(
                          color: Colors.white,
                          fontSize: 36.0,
                          //letterSpacing: 10,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 2, 0),
                    child: Text("Password ?",
                        style: GoogleFonts.mPlusRounded1c(
                          color: Colors.white,
                          fontSize: 36.0,
                          //letterSpacing: 10,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      width: size.width * .9,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5.0)),
                      child: TextFormField(
                        key: ValueKey('email'),
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
                            hintText: "Email address",
                            border: InputBorder.none,
                            hintStyle: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            contentPadding: EdgeInsets.fromLTRB(7, 14, 0, 0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 1),
                    child: Text(
                        "We will send you a message to set or reset your new password",
                        overflow: TextOverflow.visible,
                        style: GoogleFonts.mPlusRounded1c(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.normal,
                        )),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: ElevatedButton(
                        // ignore: sort_child_properties_last
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(80, 0, 80, 4),
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : Text(
                                  "Send Code",
                                  style: GoogleFonts.mPlusRounded1c(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2900FF),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.44))),
                        onPressed: resetPassword,
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(builder: (context) => GmailCode()
                        //         // Leaveform()));
                        //         ));
                      ),
                    ),
                  ),
                ]),
          )),
    );
  }
}
