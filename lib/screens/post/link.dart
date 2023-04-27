import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LinkPage extends StatelessWidget {
  const LinkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: mediaQuery.viewInsets,
      child: SingleChildScrollView(
        child: Container(
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
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'images/icons/Linkchain.svg',
                    width: 28,
                    height: 28,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Link',
                    style: GoogleFonts.mPlusRounded1c(
                        color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'URL',
                    style: GoogleFonts.mPlusRounded1c(
                        color: Colors.white, fontSize: 15),
                  ),
                  Container(
                    width: size.width * 0.75,
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: 'http://example.com',
                          hintStyle: GoogleFonts.mPlusRounded1c(
                              color: Color(0XFF656161), fontSize: 13)),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
