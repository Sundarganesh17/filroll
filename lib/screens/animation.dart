import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AnimationPage extends StatelessWidget {
  final picName;
  const AnimationPage({super.key, required this.picName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: picName == 'Search4'
          ? const EdgeInsets.only(top: 30)
          : EdgeInsets.zero,
      child: Shimmer.fromColors(
          baseColor: const Color.fromARGB(255, 64, 64, 64),
          highlightColor: Colors.grey.withOpacity(0.5),
          child: Image.asset("images/homepage/$picName.png")),
    );
  }
}
