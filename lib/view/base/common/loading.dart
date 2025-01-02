import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:matrix_ai/utils/images.dart';
import '../../../utils/colors.dart';
import '../loading/rotation_loading.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Loading()],
    );
  }
}

class Loading extends StatelessWidget {
  final double size;
  const Loading({super.key, this.size = 150});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'loading',
      child: SizedBox(
        height: size.sp,
        width: size.sp,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(child: CircleLoading(size: size)),
            Center(
              child: Lottie.asset(
                Images.starAnimation,
                width: (size / 1.5).sp,
                height: (size / 1.5).sp,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedProgressBar extends StatefulWidget {
  final Duration duration;
  final Color color;

  const AnimatedProgressBar({super.key, required this.duration, this.color = primaryColor});

  @override
  AnimatedProgressBarState createState() => AnimatedProgressBarState();
}

class AnimatedProgressBarState extends State<AnimatedProgressBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration, // Use the duration passed via the widget
    )..repeat(); // Repeat the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            padding: EdgeInsets.all(2.sp),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.sp),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: SizedBox(
              height: 6.sp,
              child: LinearProgressIndicator(
                value: _controller.value,
                valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                borderRadius: BorderRadius.circular(10.sp),
                backgroundColor: Theme.of(context).dividerColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
