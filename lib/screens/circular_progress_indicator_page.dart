import 'package:flutter/material.dart';

class CircularProgrssIndicatorPage extends StatelessWidget {
  const CircularProgrssIndicatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.65,
      width: double.infinity,
      color: Colors.black.withOpacity(0.2),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
