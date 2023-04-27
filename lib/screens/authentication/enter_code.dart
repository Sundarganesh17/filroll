import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class codescreen extends StatefulWidget {
  const codescreen({Key? key}) : super(key: key);

  @override
  State<codescreen> createState() => _codescreenState();
}

class _codescreenState extends State<codescreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget buildContainer() {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Color(0xFF262626)),
        height: 48,
        width: 44,
        child: TextFormField(
          style: TextStyle(color: Colors.white),
          onChanged: (value) {
            if (value.length == 1) {
              FocusScope.of(context).nextFocus();
            }
          },
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            hintText: '_',
            border: InputBorder.none,
            hintStyle: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 100, 2, 1),
              child: Text("Enter ",
                  style: GoogleFonts.mPlusRounded1c(
                    color: Colors.white,
                    fontSize: 36.0,
                    //letterSpacing: 10,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 1, 2, 1),
              child: Text("code ",
                  style: GoogleFonts.mPlusRounded1c(
                    color: Colors.white,
                    fontSize: 36.0,
                    //letterSpacing: 10,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildContainer(),
                  buildContainer(),
                  buildContainer(),
                  buildContainer(),
                  buildContainer(),
                  buildContainer(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
              child: Center(
                child: ElevatedButton(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(100, 5, 100, 5),
                      child: Text(
                        "Done",
                        style: GoogleFonts.mPlusRounded1c(
                          color: Colors.white,
                          fontSize: 17.0,
                          //letterSpacing: 3.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xFF2900FF),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.44))),
                    onPressed: () {}),
              ),
            ),
          ]),
    );
  }
}
