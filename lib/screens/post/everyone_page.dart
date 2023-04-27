import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class EveryonePage extends StatelessWidget {
  const EveryonePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(20),
        height: size.height * 0.2,
        width: size.width * 0.9,
        decoration: const BoxDecoration(
          color: Color(0XFF1A1920),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 12, top: 10),
              child: SvgPicture.asset(
                'images/icons/Globe.svg',
                height: 25,
                width: 25,
              ),
            ),
            Row(
              children: [
                const SizedBox(
                  width: 5,
                ),
                const CircleAvatar(
                  radius: 4,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text('Everyone',
                    style: GoogleFonts.mPlusRounded1c(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
            Row(
              children: [
                const SizedBox(
                  width: 17,
                ),
                Text('People Follow You',
                    style: GoogleFonts.mPlusRounded1c(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
            Row(
              children: [
                const SizedBox(
                  width: 17,
                ),
                Text('People  You Follow',
                    style: GoogleFonts.mPlusRounded1c(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
            Row(
              children: [
                const SizedBox(
                  width: 17,
                ),
                Text('No One',
                    style: GoogleFonts.mPlusRounded1c(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
