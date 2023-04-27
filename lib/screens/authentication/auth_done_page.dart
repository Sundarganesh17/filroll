import 'dart:async';

import 'package:filroll_app/screens/feed/home_screen.dart';
import 'package:flutter/material.dart';

class AuthDonePage extends StatefulWidget {
  const AuthDonePage({super.key});

  @override
  State<AuthDonePage> createState() => _AuthDonePageState();
}

class _AuthDonePageState extends State<AuthDonePage> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen())));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Image.asset("images/homepage/Splash.png");
  }
}
