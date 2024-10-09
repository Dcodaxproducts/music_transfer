import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CustomAnimatedWidget extends StatelessWidget {
  final int index;
  final Widget child;
  final bool vertical;
  const CustomAnimatedWidget(
      {required this.index,
      required this.child,
      this.vertical = true,
      super.key});

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 375),
      child: SlideAnimation(
        verticalOffset: vertical ? 100.sp : null,
        horizontalOffset: !vertical ? 100.sp : null,
        child: FadeInAnimation(child: child),
      ),
    );
  }
}

class AnimatedColumn extends StatelessWidget {
  final List<Widget> children;
  final int speed;
  final bool vertical;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  const AnimatedColumn(
      {required this.children,
      this.speed = 275,
      this.vertical = true,
      this.crossAxisAlignment = CrossAxisAlignment.center,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.mainAxisSize = MainAxisSize.max,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: AnimationConfiguration.toStaggeredList(
        duration: Duration(milliseconds: speed),
        childAnimationBuilder: (widget) => SlideAnimation(
          horizontalOffset: vertical ? null : 100.sp,
          verticalOffset: vertical ? 100.sp : null,
          child: FadeInAnimation(child: widget),
        ),
        children: children,
      ),
    );
  }
}

class CustomAnimatedList extends StatelessWidget {
  final List<Widget> children;
  final int speed;
  final bool vertical;
  final EdgeInsetsGeometry? padding;
  const CustomAnimatedList(
      {required this.children,
      this.speed = 275,
      this.vertical = true,
      this.padding,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: padding,
      children: AnimationConfiguration.toStaggeredList(
        duration: Duration(milliseconds: speed),
        childAnimationBuilder: (widget) => SlideAnimation(
          horizontalOffset: vertical ? null : 100.sp,
          verticalOffset: vertical ? 100.sp : null,
          child: FadeInAnimation(child: widget),
        ),
        children: children,
      ),
    );
  }
}
