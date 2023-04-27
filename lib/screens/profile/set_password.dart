import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SetPassword extends StatefulWidget {
  const SetPassword({super.key});

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final reNewPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<bool> validatePassword() async {
    try {
      _formKey.currentState!.validate();
      var authCredentials = EmailAuthProvider.credential(
          email: FirebaseAuth.instance.currentUser!.email!,
          password: oldPasswordController.text);
      var authResult = await FirebaseAuth.instance.currentUser
          ?.reauthenticateWithCredential(authCredentials);
      print(authResult);
      return authResult!.user != null;
    } on FirebaseAuthException catch (error) {
      var msg = 'An error occured, please check your credentials! ';
      if (error.message != null) {
        msg = error.message!;
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            )),
        title: Center(
          child: Text(
            'Set Password',
            style: GoogleFonts.mPlusRounded1c(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                var checkCurrentPasswordValid = await validatePassword();
                if (_formKey.currentState!.validate() &&
                    checkCurrentPasswordValid) {
                  FirebaseAuth.instance.currentUser!
                      .updatePassword(newPasswordController.text);
                  // ignore: use_build_context_synchronously
                  FocusScope.of(context).unfocus();
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password is updated successfully'),
                    ),
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                }
              },
              icon: const Icon(
                Icons.check,
                color: Colors.white,
              )),
        ],
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: size.width * .9,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(13)),
                    child: TextFormField(
                      controller: oldPasswordController,
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
                          fillColor: const Color(0xFF1A1920),
                          hintText: "Enter Old Password",
                          border: InputBorder.none,
                          hintStyle: GoogleFonts.mPlusRounded1c(
                            fontSize: 14,
                            color: const Color(0XFF6B6B6C),
                            fontWeight: FontWeight.bold,
                          ),
                          contentPadding:
                              const EdgeInsets.fromLTRB(17, 0, 0, 4)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Container(
                    // height: size.height * 0.15,
                    width: size.width * .9,
                    decoration: BoxDecoration(
                        color: const Color(0xFF1A1920),
                        borderRadius: BorderRadius.circular(13)),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: newPasswordController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: 'Set New Password',
                              border: InputBorder.none,
                              hintStyle: GoogleFonts.mPlusRounded1c(
                                fontSize: 14,
                                color: const Color(0XFF6B6B6C),
                                fontWeight: FontWeight.bold,
                              ),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(17, 8, 0, 0)),
                        ),
                        const Divider(
                          color: Color(0XFF555151),
                        ),
                        TextFormField(
                          controller: reNewPasswordController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: 'Enter Password Again',
                              border: InputBorder.none,
                              hintStyle: GoogleFonts.mPlusRounded1c(
                                fontSize: 14,
                                color: const Color(0XFF6B6B6C),
                                fontWeight: FontWeight.bold,
                              ),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(17, 0, 0, 4)),
                          validator: ((value) {
                            if (value!.isEmpty ||
                                newPasswordController.text != value) {
                              return 'Password do not match or Empty';
                            }
                            return null;
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, top: 4),
                    child: Text(
                      '6 Characters, Letters or Numbers',
                      style: GoogleFonts.mPlusRounded1c(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
