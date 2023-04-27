import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filroll_app/screens/feed/trial1.dart';
import 'package:filroll_app/widgets/feed_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class SearchPostsFeedList extends StatefulWidget {
  final feedsnap;
  const SearchPostsFeedList({super.key, this.feedsnap});

  @override
  State<SearchPostsFeedList> createState() => _SearchPostsFeedListState();
}

class _SearchPostsFeedListState extends State<SearchPostsFeedList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.feedsnap.length,
          itemBuilder: (context, index) => Trial1(
            snap: widget.feedsnap[index],
          ),
        ),
      ),
    );
  }
}
