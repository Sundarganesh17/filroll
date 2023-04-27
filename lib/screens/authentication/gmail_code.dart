import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GmailCode extends StatefulWidget {
  const GmailCode({Key? key}) : super(key: key);

  @override
  State<GmailCode> createState() => _GmailCodeState();
}

class _GmailCodeState extends State<GmailCode> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 50, 2, 0),
              child: Text("Gmail ",
                  style: GoogleFonts.mPlusRounded1c(
                    color: Colors.white,
                    fontSize: 36.0,
                    //letterSpacing: 10,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 2, 0),
              child: Text("code ",
                  style: GoogleFonts.mPlusRounded1c(
                    color: Colors.white,
                    fontSize: 36.0,
                    //letterSpacing: 10,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(17, 13, 13, 13),
              child: Row(
                children: [
                  Container(
                    height: size.height * 0.045,
                    width: size.width * 0.1,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xFF262626)),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          hintText: '  .',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 13, 13, 13),
                    child: Container(
                      height: size.height * 0.045,
                      width: size.width * 0.1,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0xFF262626)),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: '  .',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: size.height * 0.045,
                      width: size.width * 0.1,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0xFF262626)),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: '  .',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: size.height * 0.045,
                      width: size.width * 0.1,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0xFF262626)),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: '  .',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: size.height * 0.045,
                      width: size.width * 0.1,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0xFF262626)),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: '  .',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: size.height * 0.045,
                      width: size.width * 0.1,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0xFF262626)),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: '  .',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(23, 13, 13, 13),
              child: ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(130, 4, 110, 3),
                    child: Text(
                      "Done",
                      style: GoogleFonts.mPlusRounded1c(
                        // style: GoogleFonts.
                        color: Colors.white,
                        fontSize: 15.0,
                        //letterSpacing: 3.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xFF2900FF),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.44))),
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(builder: (context) => loginscreen()
                    //         // Leaveform()));
                    //         ));
                  }),
            ),
          ]),
    );
  }
}
