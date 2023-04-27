import 'package:flutter/material.dart';

class SwitchProfile extends StatelessWidget {
  const SwitchProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
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
          child: const Center(
            child: Text(
              'There is no more profiles in this device',
              style: TextStyle(color: Colors.white),
            ),
          )
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     ListTile(
          //       leading: Container(
          //         // height: Size.fromHeight(height),
          //         padding: EdgeInsets.all(2),
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(50),
          //         ),

          //         child: ClipOval(
          //           child: Image.asset(
          //             "images/homepage/profile.jpg",
          //             height: 35,
          //             width: 35,
          //             fit: BoxFit.cover,
          //           ),
          //         ),
          //       ),
          //       title: Text('Jessi',
          //           style: GoogleFonts.mPlusRounded1c(
          //             color: Colors.white,
          //             fontSize: 14.0,
          //             fontWeight: FontWeight.bold,
          //           )),
          //       trailing: CircleAvatar(
          //         radius: 4,
          //       ),
          //     ),
          //     ListTile(
          //       leading: Container(
          //         // height: Size.fromHeight(height),
          //         padding: EdgeInsets.all(2),
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(50),
          //         ),

          //         child: ClipOval(
          //           child: Image.asset(
          //             "images/homepage/profile.jpg",
          //             height: 35,
          //             width: 35,
          //             fit: BoxFit.cover,
          //           ),
          //         ),
          //       ),
          //       title: Text('Jacklin',
          //           style: GoogleFonts.mPlusRounded1c(
          //             color: Colors.white,
          //             fontSize: 14.0,
          //             fontWeight: FontWeight.bold,
          //           )),
          //       trailing: Container(
          //           // height: Size.fromHeight(height),
          //           padding: EdgeInsets.all(1),
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(50),
          //             color: Colors.white,
          //           ),
          //           child: CircleAvatar(
          //             backgroundColor: Colors.black,
          //             radius: 2,
          //           )),
          //     ),
          //   ],
          // ),
          ),
    );
  }
}
