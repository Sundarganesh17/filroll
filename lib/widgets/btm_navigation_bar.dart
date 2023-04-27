import 'package:filroll_app/screens/animation.dart';
import 'package:filroll_app/screens/authentication/login_screen.dart';
import 'package:filroll_app/screens/authentication/phone_screen.dart';
import 'package:filroll_app/screens/authentication/signup_screen.dart';
import 'package:filroll_app/screens/dum.dart';
import 'package:filroll_app/screens/feed/feed.dart';
import 'package:filroll_app/screens/feed/home_screen.dart';
import 'package:filroll_app/screens/longvideo/longvideo_screen.dart';
import 'package:filroll_app/screens/post/add_post_video_stories_bar.dart';
import 'package:filroll_app/screens/search/search.dart';
import 'package:filroll_app/screens/update_soon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../screens/shorts/shorts_screen.dart';
import '../screens/shorts/suggestion_screen.dart';

class BtmNavigationBar extends StatefulWidget {
  const BtmNavigationBar({super.key});

  @override
  State<BtmNavigationBar> createState() => _BtmNavigationBarState();
}

class _BtmNavigationBarState extends State<BtmNavigationBar> {
  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;
    return Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.black),
        child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            iconSize: 25,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: selectedIndex,
            onTap: (selectedindex) => {
                  if (selectedindex == 0)
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen())),
                  if (selectedindex == 1)
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Search())),
                  if (selectedindex == 2)
                    showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const AddPostVideoStoriesBar()),
                  if (selectedindex == 3)
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  ShortsScreen(0))),
                  if (selectedindex == 4)
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LongVideoScreen())),
                },
            items: [
              BottomNavigationBarItem(
                label: "",
                icon: SvgPicture.asset(
                  "images/icons/Home.svg",
                  width: 20,
                  height: 20,
                ),
              ),
              BottomNavigationBarItem(
                label: "",
                icon: Image.asset(
                  "images/icons/Search.png",
                  width: 20,
                  height: 20,
                ),
              ),
              BottomNavigationBarItem(
                label: "",
                icon: SvgPicture.asset(
                  "images/icons/Plus.svg",
                  width: 20,
                  height: 20,
                ),
              ),
              BottomNavigationBarItem(
                label: "",
                icon: SvgPicture.asset(
                  "images/icons/Roll.svg",
                  width: 20,
                  height: 20,
                ),
              ),
              BottomNavigationBarItem(
                label: "",
                icon: SvgPicture.asset(
                  "images/icons/Explore.svg",
                  width: 20,
                  height: 20,
                ),
              ),
            ]));
  }
}
