import 'package:flutter/material.dart';

class ProfileBox extends StatefulWidget {
  const ProfileBox({Key? key}) : super(key: key);

  @override
  State<ProfileBox> createState() => _ProfileBoxState();
}

class _ProfileBoxState extends State<ProfileBox> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        // scrollDirection: axis,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      //  mainAxisAlignment:MainAxisAlignment.start,
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Profile",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ),

      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //  scrollDirection:Axis.vertical,
          children: [
            Container(
              height: size.height * 0.22,
              width: size.width * 0.37,
              decoration: ShapeDecoration(
                  color: const Color(0xFF212121),
                  //

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  )),
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(children: [
                    Container(
                      height: size.height * 0.11,
                      width: size.width * 0.37,
                      decoration: const BoxDecoration(
                          // color: Colors.white,
                          image: DecorationImage(
                              image: AssetImage(
                                "images/homepage/profile1.png",
                              ),
                              fit: BoxFit.cover),
                          // shape: RoundedRectangleBorder(
                          // borderRadius: BorderRadius.circular(10),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5))),
                      child: Positioned(
                        left: 60,
                        top: 50,
                        child: SizedBox(
                          height: size.height * 0.05,
                          width: size.width * 0.03,
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage(
                              "images/homepage/profile2.jpg",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                )
              ]),
            ),

            /////////////////////////////////////////////////////////////////////////////////
            Container(
              height: size.height * 0.22,
              width: size.width * 0.35,

              decoration: ShapeDecoration(
                  color: const Color(0xFF212121),
                  // image:DecorationImage(image: AssetImage("images/homepage/profile.jpg",),fit: BoxFit.fitWidth),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  )),
              //color: Colors.deepPurpleAccent.shade400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Column(children: [
                          Container(
                            height: size.height * 0.11,
                            width: size.width * 0.35,
                            decoration: const BoxDecoration(
                              // color: Colors.white,
                              image: DecorationImage(
                                  image: AssetImage(
                                    "images/homepage/profile.jpg",
                                  ),
                                  fit: BoxFit.fitWidth),
                              // shape: RoundedRectangleBorder(
                              // borderRadius: BorderRadius.circular(13),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5)),
                            ),
                          )
                        ])),
                    Container(
                      // ignore: sort_child_properties_last
                      child: ClipOval(
                        child: Image.asset(
                          "images/homepage/leon-macapagal-1kZF9ltbRjo-unsplash.jpg",
                          height: 30,
                          width: 35,
                          fit: BoxFit.fill,
                        ),
                      ),
                      padding: const EdgeInsets.all(1),
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13.0),
                          gradient: const LinearGradient(colors: [
                            Color.fromARGB(720, 114, 5, 255),
                            Color.fromARGB(167, 22, 115, 255),
                            Color(0xFF2900FF),
                          ])),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text("willy",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                            //letterSpacing: 3.0,
                            //fontWeight: FontWeight.bold
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        height: size.height * 0.045,
                        width: size.width * 0.25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2900FF)),
                          child: const Text(
                            "Follow",
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    )
                  ])
                ],
              ),
            ),
            /*Container(
            height: size.height * 0.4,
            width: size.width * 0.35,
    
            decoration: ShapeDecoration(
                color: Colors.black,
                // image:DecorationImage(image: AssetImage("images/homepage/profile.jpg",),fit: BoxFit.fitWidth),
    
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                )),
            //color: Colors.deepPurpleAccent.shade400,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                      child: Column(children: [
                        Container(
                          height: size.height * 0.09,
                          width: size.width * 0.35,
                          decoration: ShapeDecoration(
                              // color: Colors.white,
                              image: DecorationImage(
                                  image: AssetImage(
                                    "images/homepage/profile.jpg",
                                  ),
                                  fit: BoxFit.fitWidth),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              )),
                        ),*/
          ])
    ]));
  }
}
