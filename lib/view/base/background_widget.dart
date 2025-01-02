import 'package:flutter/material.dart';
import 'package:matrix_ai/utils/images.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget child;
  const BackgroundWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage(Images.background), fit: BoxFit.cover),
          ),
        ),
        child,
      ],
    );
  }
}
