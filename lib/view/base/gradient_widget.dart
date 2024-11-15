import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matrix_ai/utils/style.dart';
import '../../utils/colors.dart';

class GradientWidget extends StatelessWidget {
  final Widget child;
  final LinearGradient? gradient;
  const GradientWidget({required this.child, this.gradient, super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => (gradient ?? primaryGradient).createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: child,
    );
  }
}

class GradientBorder extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const GradientBorder({required this.child, this.padding, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(1.sp),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: primaryGradient,
      ),
      child: Container(
        padding: padding ?? EdgeInsets.all(12.sp),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: child,
      ),
    );
  }
}
