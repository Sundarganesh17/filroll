import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MenuItem {
  final String text;
  final dynamic icon;

  MenuItem({required this.text, required this.icon});
}

class MenuItems {
  static List<MenuItem> itemsfirst = [
    itemSaved,
    itemSettings,
    itemFavourite,
    itemCopy,
    itemunFollow,
  ];

  static List<MenuItem> itemSecond = [
    itemReport,
  ];

  static var itemSaved = MenuItem(
    text: 'Saved',
    icon: SvgPicture.asset(
      "images/icons/Saved.svg",
    ),
  );
  static var itemSettings = MenuItem(
    text: 'Share',
    icon: SvgPicture.asset(
      "images/icons/Share.svg",
    ),
  );
  static var itemFavourite = MenuItem(
    text: 'Favourite',
    icon: SvgPicture.asset(
      //color: Colors.transparent,
      "images/icons/Fav.svg",
    ),
  );
  static var itemCopy = MenuItem(
    text: 'Copy Link',
    icon: SvgPicture.asset(
      "images/icons/Copy Link.svg",
    ),
  );
  static var itemunFollow = MenuItem(
    text: 'Unfollow',
    icon: Image.asset(
      "images/icons/Not interested1.png",
    ),
  );
  static var itemReport = MenuItem(
    text: 'Report',
    icon: Image.asset(
      "images/icons/Report crop.png",
    ),
  );
}
