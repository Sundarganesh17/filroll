import 'package:flutter/material.dart';

class Pic extends StatelessWidget {
  final pic;
  const Pic({super.key, this.pic});

  @override
  Widget build(BuildContext context) {
    return Image.memory(pic);
  }
}
