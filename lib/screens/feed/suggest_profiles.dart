import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SuggestProfiles extends StatefulWidget {
  const SuggestProfiles({super.key});

  @override
  State<SuggestProfiles> createState() => _SuggestProfilesState();
}

class _SuggestProfilesState extends State<SuggestProfiles> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      color: Colors.black,
      height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profile',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          Container(
            height: 225,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.all(10),
                height: 190,
                width: 160,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(5.0)),
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                    ),
                    Container(
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
