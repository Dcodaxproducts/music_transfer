import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/images.dart';

class CircleLoading extends StatefulWidget {
  final double size;
  const CircleLoading({this.size = 150, super.key});

  @override
  CircleLoadingState createState() => CircleLoadingState();
}

class CircleLoadingState extends State<CircleLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(); // This will make the rotation continuously.
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animationController,
      child: Image.asset(
        Images.gradient_circle,
        width: widget.size.sp,
        height: widget.size.sp,
      ),
    );
  }
}
