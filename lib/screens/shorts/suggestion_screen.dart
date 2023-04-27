import 'dart:io';

import 'package:filroll_app/screens/shorts/shorts_screen.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({super.key});

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  List videourl = [
    'https://static.videezy.com/system/resources/previews/000/044/285/original/Mail-Digital-Network-2.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-waves-in-the-water-1164-large.mp4',
    'https://static.videezy.com/system/resources/previews/000/052/814/original/futuristic-digital-big-data-processing-technology.mp4'
  ];
  List moviesname = ['Tamilmovies', 'Vijay', 'AlluArjun', 'Hindi', 'HitSongs'];
  List news = ['TamilNadu', 'Technews', 'Japan', 'Filroll', 'Newyork'];
  List<String> thumnails = [];
  List<bool> moviename1=[
     false,
    false,
    false,
    false,
    false,
  ];
  List<bool> newsname=[
    false,
    false,
    false,
    false,
    false,
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    urlthumbnails();
  }

  Future<String> getThumbnail(String videoPath) async {
    final thumbnailFile = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      imageFormat: ImageFormat.PNG,
      maxWidth:
          128, // specify the width of the thumbnail, in this case 128 pixels
      quality: 50, // specify the quality of the thumbnail, from 0 to 100
    );

    return thumbnailFile!;
  }

  void urlthumbnails() async {
    var t = 0;
    for (t; t < videourl.length; t++) {
      var paths = await getThumbnail(videourl[t]);
      thumnails.add(paths);
    }
    print(thumnails);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var mediaqurey = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(top: 6,left: 14),
          child: CircleAvatar(),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'Select Your Favourites',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: mediaqurey.height * 0.02,
              ),
              SizedBox(
                  height: mediaqurey.height * 0.27,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return profilepicture(mediaqurey, context);
                    },
                  )),
              SizedBox(
                height: mediaqurey.height * 0.03,
              ),
              SizedBox(
                width: mediaqurey.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Movies',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      child: Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: InkWell(
                              onTap: (){
                                setState(() {
                                  moviename1[0]=!moviename1[0];
                                });
                              },
                              child: Chip(
                                side:!moviename1[0]?BorderSide(): BorderSide(color: Colors.white60),
                                backgroundColor:
                                  Colors.black87,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                label: Text(
                                  moviesname[0],
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: InkWell(
                                onTap: (){
                                setState(() {
                                  moviename1[1]=!moviename1[1];
                                });
                              },
                              child: Chip(
                                  side:!moviename1[1]? BorderSide():BorderSide(color: Colors.white60),
                                  backgroundColor:Colors.black87,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                  label: Text(
                                    moviesname[1],
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: InkWell(
                                onTap: (){
                                setState(() {
                                  moviename1[2]=!moviename1[2];
                                });
                              },
                              child: Chip(
                                  side:!moviename1[2]?BorderSide():BorderSide(color: Colors.white60),
                                  backgroundColor:Colors.black87,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                  label: Text(
                                    moviesname[2],
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: InkWell(
                                onTap: (){
                                setState(() {
                                  moviename1[3]=!moviename1[3];
                                });
                              },
                              child: Chip(
                                  side:!moviename1[3]?BorderSide(): BorderSide(color: Colors.white60),
                                  backgroundColor:Colors.black87,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                  label: Text(
                                    moviesname[3],
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: InkWell(
                                onTap: (){
                                setState(() {
                                  moviename1[4]=!moviename1[4];
                                });
                              },
                              child: Chip(
                                  side:!moviename1[4]?BorderSide(): BorderSide(color: Colors.white60),
                                  backgroundColor:Colors.black87,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                  label: Text(
                                    moviesname[4],
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: mediaqurey.height * 0.03,
              ),
              SizedBox(
                width: mediaqurey.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'News',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      child: Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: InkWell(
                              onTap: (){
                                setState(() {
                                newsname[0]=!newsname[0];
                                });
                              },
                              child: Chip(
                                  side:!newsname[0]?BorderSide() :BorderSide(color: Colors.white60),
                                  backgroundColor:Colors.black87,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                  label: Text(
                                    news[0],
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: InkWell(
                               onTap: (){
                                setState(() {
                                newsname[1]=!newsname[1];
                                });
                              },
                              child: Chip(
                                  side:!newsname[1]? BorderSide():BorderSide(color: Colors.white60),
                                  backgroundColor:Colors.black87,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                  label: Text(
                                    news[1],
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: InkWell(
                               onTap: (){
                                setState(() {
                                newsname[2]=!newsname[2];
                                });
                              },
                              child: Chip(
                                  side:!newsname[2]?BorderSide() :BorderSide(color: Colors.white60),
                                  backgroundColor:Colors.black87,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                  label: Text(
                                    news[2],
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: InkWell(
                               onTap: (){
                                setState(() {
                                newsname[3]=!newsname[3];
                                });
                              },
                              child: Chip(
                                  side:!newsname[3]?BorderSide(): BorderSide(color: Colors.white60),
                                  backgroundColor:Colors.black87,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                  label: Text(
                                    news[3],
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: InkWell(
                               onTap: (){
                                setState(() {
                                newsname[4]=!newsname[4];
                                });
                              },
                              child: Chip(
                                  side:!newsname[4]? BorderSide():BorderSide(color: Colors.white60),
                                  backgroundColor:Colors.black87,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                  label: Text(
                                    news[4],
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: mediaqurey.height * 0.03,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Roll',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      height: mediaqurey.height * 0.2,
                      width: mediaqurey.width,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: thumnails.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                              height: mediaqurey.height * 0.2,
                              width: mediaqurey.width * 0.3,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                      builder: (context) => ShortsScreen(index),
                                    ));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: FileImage(
                                              File(thumnails[index]),
                                            ),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.all(Radius.circular(12))
                                            ),
                                  ),
                                ),
                              ));
                        },
                      )),
                       SizedBox(
                height: mediaqurey.height * 0.03,
              ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

Widget profilepicture(mediaquery, context) {
  var mediaqurey = MediaQuery.of(context).size;
  return SizedBox(
      height: mediaquery.height * 0.4,
      width: mediaquery.width * 0.43,
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                              'https://images.freeimages.com/images/large-previews/5b1/water-bubble-1183419.jpg',
                            ),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 32,),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(34, 158, 158, 158),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8))),
                    child: Column(
                      children: [
                        Text(
                          'Josh_I',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Container(
                          height: 25,
                          width: 90,
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 8, 39, 244),
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          child: Center(
                            child: Text(
                              'Follow',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                        'https://media.istockphoto.com/id/1434359956/photo/male-urban-dancer-in-the-air.jpg?s=1024x1024&w=is&k=20&c=FzgRliO3xc5DxWb7US1BTN_gFlJf-yJoZvwJD9Q4cgk=',
                      ),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
              ),
            )
          ],
        ),
      ));
}

Widget reels(String url, mediaquery, BuildContext context, int int) {
  return SizedBox(
      height: mediaquery.height * 0.25,
      width: mediaquery.width * 0.3,
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => ShortsScreen(int),
            ));
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            url,
                          ),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                ),
              ),
            ],
          ),
        ),
      ));
}

Widget movies(context, names) {
  var mediaqurey = MediaQuery.of(context).size;
  return SizedBox(
    height: mediaqurey.height * 0.4,
    width: mediaqurey.width * 0.96,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Movies',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Container(
          width: double.infinity,
          child: Wrap(
            children: [],
          ),
        )
      ],
    ),
  );
}
